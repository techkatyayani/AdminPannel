import 'dart:io';
import 'package:adminpannal/Screens/prouct_catagory/controller/prouduct_catagory_controller.dart';
import 'package:adminpannal/Screens/prouct_catagory/model/product_catagory_model.dart';
import 'package:adminpannal/common/custom_color_picker.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class AddProductCatagoryDialog extends StatefulWidget {
  const AddProductCatagoryDialog({super.key});

  @override
  State<AddProductCatagoryDialog> createState() =>
      _AddProductCatagoryDialogState();
}

class _AddProductCatagoryDialogState extends State<AddProductCatagoryDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: boxColor,
      child: Consumer<ProuductCatagoryController>(
        builder: (context, provider, child) {

          Color color = getColorFromCode(provider.colorHex);

        return Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.5,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add Product Category',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: provider.titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter Category Title',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: provider.collectionIdController,
                  decoration: InputDecoration(
                    hintText: 'Enter Collection Id',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // TextFormField(
                //   controller: provider.colorHexController,
                //   decoration: InputDecoration(
                //     hintText: 'Enter Color Hex',
                //     hintStyle: TextStyle(color: Colors.grey[400]),
                //     filled: true,
                //     fillColor: Colors.grey[800],
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(8),
                //       borderSide: BorderSide.none,
                //     ),
                //   ),
                // ),

                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {

                        return CustomColorPicker(
                          pickerColor: color,
                          onColorChanged: (color) {
                            provider.setColorHex(color.toHexString());
                          }
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        color: color,
                      ),

                      const SizedBox(width: 30),

                      const Text(
                        'Pick Color',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                const Text(
                  'Add Image (Strip Banner Like Image)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.languages.length,
                    itemBuilder: (context, index) {
                      final language = provider.languages[index];
            
                      return InkWell(
                        onTap: () {
                          provider.pickImage(context, language);
                        },
                        child: Container(
                          height: 150,
                          width: 160,
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 102, 84, 143),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: provider.selectedImages[language] != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: provider.selectedImages[language]!
                                          .startsWith('blob:')
                                      ? Image.network(
                                          provider.selectedImages[language]!,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(
                                              provider.selectedImages[language]!),
                                          fit: BoxFit.cover,
                                        ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '$language Image',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      provider.addImagesAndSaveCategory(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      backgroundColor: Colors.purple,
                    ),
                    child: provider.isLoadingAddcatagory
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
