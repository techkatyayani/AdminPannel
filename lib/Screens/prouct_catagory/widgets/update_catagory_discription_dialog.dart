import 'package:adminpannal/Screens/prouct_catagory/controller/prouduct_catagory_controller.dart';
import 'package:adminpannal/Screens/prouct_catagory/model/product_catagory_model.dart';
import 'package:adminpannal/common/custom_color_picker.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class UpdateCatagoryDiscriptionDialog extends StatefulWidget {
  final String defaultCatagoryTitle;
  final String defaultCatagoryId;
  final String defaultCatagoryColorHex;
  const UpdateCatagoryDiscriptionDialog(
      {super.key,
      required this.defaultCatagoryTitle,
      required this.defaultCatagoryId,
      required this.defaultCatagoryColorHex});

  @override
  State<UpdateCatagoryDiscriptionDialog> createState() =>
      _UpdateCatagoryDiscriptionDialogState();
}

class _UpdateCatagoryDiscriptionDialogState
    extends State<UpdateCatagoryDiscriptionDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: boxColor,
      child: Consumer<ProuductCatagoryController>(
          builder: (context, provider, child) {

        provider.titleController.text = widget.defaultCatagoryTitle;
        provider.collectionIdController.text = widget.defaultCatagoryId;

        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height / 1.5,
          width: MediaQuery.of(context).size.width / 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Update Discription',
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
                  hintText: 'Enter Category Collection Id',
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
                          pickerColor: getColorFromCode(widget.defaultCatagoryColorHex),
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
                      color: getColorFromCode(widget.defaultCatagoryColorHex),
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


              const Expanded(child: SizedBox()),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    provider.updateCategoryDetails(
                      widget.defaultCatagoryId,
                      provider.collectionIdController.text.trim(),
                      provider.titleController.text.trim(),
                      provider.colorHex,
                      context,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    backgroundColor: Colors.purple,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }
}
