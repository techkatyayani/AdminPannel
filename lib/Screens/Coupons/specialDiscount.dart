import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SpecialDiscount extends StatefulWidget {
  const SpecialDiscount({super.key});

  @override
  State<SpecialDiscount> createState() => _SpecialDiscountState();
}

class _SpecialDiscountState extends State<SpecialDiscount> {
  final TextEditingController _buttonTextController = TextEditingController();
  final TextEditingController _cancelTextController = TextEditingController();
  final TextEditingController _couponNameController = TextEditingController();
  final TextEditingController _discountPercentageController =
      TextEditingController();
  final TextEditingController _discountTextController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  bool isVisible = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchSpecialDiscountData();
  }

  @override
  void dispose() {
    _buttonTextController.dispose();
    _cancelTextController.dispose();
    _couponNameController.dispose();
    _discountPercentageController.dispose();
    _discountTextController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> fetchSpecialDiscountData() async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('DynamicSection')
          .doc('SpecialDiscount')
          .get();

      if (response.exists) {
        final document = response.data();
        if (document != null) {
          setState(() {
            _buttonTextController.text = document['buttonText'] ?? '';
            _cancelTextController.text = document['cancelText'] ?? '';
            _couponNameController.text = document['coupanName'] ?? '';
            _discountPercentageController.text =
                document['discountPercentage'] ?? '';
            _discountTextController.text = document['discountText'] ?? '';
            isVisible = document['isVisible'] ?? false;
            _titleController.text = document['title'] ?? '';
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching data: $e');
      }
    }
  }

  Future<void> updateSpecialDiscountData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('DynamicSection')
          .doc('SpecialDiscount')
          .update(
        {
          'buttonText': _buttonTextController.text,
          'cancelText': _cancelTextController.text,
          'couponName': _couponNameController.text,
          'discountPercentage': _discountPercentageController.text,
          'discountText': _discountTextController.text,
          'isVisible': isVisible,
          'title': _titleController.text,
        },
      );
      if (kDebugMode) {
        print('Data updated successfully');
      }
      Navigator.pop(context);
    } catch (e) {
      if (kDebugMode) {
        print('Error updating data: $e');
      }
    } finally {
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
        title: const Text(
          "Special Discount",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: size.width * .2, vertical: 10),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(size.width * .04),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: boxColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Special Discount",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildTextField("Apply Button Text: ", _buttonTextController),
                  buildTextField("Cancel Button Text: ", _cancelTextController),
                  buildTextField("Coupon Name: ", _couponNameController),
                  buildTextField(
                      "Discount Percentage: ", _discountPercentageController),
                  buildTextField("Discount Text: ", _discountTextController),
                  buildTextField("Title: ", _titleController),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text(
                        "Is Show: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Switch(
                        value: isVisible,
                        onChanged: (value) {
                          setState(() {
                            isVisible = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(size.width * .25, size.height * .06)),
                      onPressed: updateSpecialDiscountData,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Update",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
