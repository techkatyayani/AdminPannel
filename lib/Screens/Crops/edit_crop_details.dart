import 'package:adminpannal/Screens/Crops/controller/crop_provider.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditCropDetails extends StatefulWidget {

  final String cropId;

  const EditCropDetails({super.key, required this.cropId});

  @override
  State<EditCropDetails> createState() => _EditCropDetailsState();
}

class _EditCropDetailsState extends State<EditCropDetails> {

  late TextEditingController cropName;
  late CropProvider provider;

  bool isLoading = true;
  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<CropProvider>(context, listen: false);
    cropName = TextEditingController();
    fetchCropDetails();
  }

  Future<void> fetchCropDetails() async {
    setState(() {
      isLoading = true;
    });

    data = await provider.fetchCropDetails(widget.cropId);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    cropName.dispose();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(

      appBar: AppBar(
        title: Text(
          data['Name'],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20
          ),
        ),
      ),

      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ElevatedButton.icon(
                onPressed: () {
                  provider.addField();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: krishiFontColorPallets[0],
                ),
                icon: const Icon(
                  Icons.add,
                  color: krishiPrimaryColor,
                ),
                label: const Text(
                  'Add Fields',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: krishiPrimaryColor,
                  ),
                )
              ),

              const SizedBox(height: 20),

              Consumer<CropProvider>(
                builder: (context, provider, child) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: provider.keys.length,
                      itemBuilder: (context, index) {

                        TextEditingController keyController = provider.keys.entries.toList()[index].value;
                        TextEditingController valueController = provider.values.entries.toList()[index].value;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(width: 20),

                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: _customTextField(
                                  hintText: 'Key',
                                  controller: keyController
                                ),
                              ),

                              const SizedBox(width: 20),

                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: _customTextField(
                                  hintText: 'Value',
                                  controller: valueController
                                ),
                              ),

                              const SizedBox(width: 20),

                              IconButton(
                                onPressed: () {
                                  provider.removeFiled(index);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )
                              ),
                            ],
                          ),
                        );
                      }
                    ),
                  );
                }
              ),

            ],
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      floatingActionButton: GestureDetector(
        onTap: () {
          if (formKey.currentState!.validate()) {
            provider.saveCropDetails(context, widget.cropId);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30)
          ),
          child: const Text(
            'Submit',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
        )
      ),
    );
  }

  Widget _customTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        fontSize: 16,
        color: boxColor,
      ),
      validator: (string) {
        if (controller.text.isEmpty) {
          return '$hintText is required..!!';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 16,
          color: boxColor
        ),

        filled: true,
        fillColor: Colors.white,

        errorStyle:  const TextStyle(
          fontSize: 16,
          color: Colors.red
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1
          )
        )
      ),
    );
  }
}
