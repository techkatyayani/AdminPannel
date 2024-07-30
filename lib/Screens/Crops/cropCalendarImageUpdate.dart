import 'package:adminpannal/Screens/Crops/addCropsForm.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CropCalendarImageUpdate extends StatefulWidget {
  final String id;
  final List<dynamic> products;
  final String language;
  final String calendarId;
  const CropCalendarImageUpdate(
      {super.key,
      required this.id,
      required this.products,
      required this.language,
      required this.calendarId});

  @override
  State<CropCalendarImageUpdate> createState() =>
      _CropCalendarImageUpdateState();
}

class _CropCalendarImageUpdateState extends State<CropCalendarImageUpdate> {
  List<TextEditingController> controllerList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    controllerList
        .addAll(widget.products.map((e) => TextEditingController(text: e)));
  }

  @override
  void dispose() {
    super.dispose();
    controllerList.map((e) => e.dispose());
  }

  void _addTextField() {
    setState(() {
      controllerList.add(TextEditingController());
    });
  }

  void _removeTextField(int index) {
    setState(() {
      if (controllerList.length > 1) {
        controllerList[index].dispose();
        controllerList.removeAt(index);
      }
    });
  }

  Future<void> updateProducts() async {
    // Check for empty text fields
    final productsList =
        controllerList.map((controller) => controller.text).toList();
    if (productsList.any((text) => text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final firestore = FirebaseFirestore.instance;
      final cropCalendarRef = widget.language == 'English'
          ? firestore
              .collection('product')
              .doc(widget.id)
              .collection('CropCalendar')
          : firestore
              .collection('product')
              .doc(widget.id)
              .collection('HindiCropCalendar');

      await cropCalendarRef
          .doc(widget.calendarId)
          .update({'products': productsList});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Crop Calendar Images Added')),
      );
      Navigator.pop(context);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving image URLs to Firestore: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Products"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: size.width * .3, vertical: 20),
            child: Container(
              decoration: BoxDecoration(
                color: boxColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Update Products",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    for (int i = 0; i < controllerList.length; i++)
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Product Id ${i + 1}",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            ListTile(
                              title: KrishiTextField(
                                controller: controllerList[i],
                                width: size.width * .2,
                                hintText: 'Product Id ${i + 1}',
                              ),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeTextField(i),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: krishiSpacing),
                    ElevatedButton(
                      onPressed: _addTextField,
                      child: const Text(
                        "+ Add Product Id",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(size.width * .3, size.height * .08)),
                      onPressed: () {
                        updateProducts();
                      },
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Update",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
