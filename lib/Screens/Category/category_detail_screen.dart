import 'dart:developer';

import 'package:adminpannal/Screens/Category/controller/category_provider.dart';
import 'package:adminpannal/Screens/Category/model/category.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:adminpannal/common/custom_color_picker.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class CategoryDetailScreen extends StatefulWidget {

  final int index;

  const CategoryDetailScreen({super.key, required this.index});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {

  final formKey = GlobalKey<FormState>();

  Color getColorFromCode(String code) {
    return code != "" ? Color(int.parse('0x$code')) : boxColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Category Details',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: Consumer<CategoryProvider>(
          builder: (BuildContext context, CategoryProvider provider, Widget? child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.category[widget.index].length,
                      itemBuilder: (context, index) {

                        Category category = provider.category[widget.index][index];
                        String categoryName = category.categoryName;

                        Color color1 = getColorFromCode(provider.categoryColors[categoryName]!.color1);
                        Color color2 = getColorFromCode(provider.categoryColors[categoryName]!.color2);

                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // Category Name
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    categoryName,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: krishiPrimaryColor
                                    ),
                                  ),

                                  IconButton(
                                      onPressed: () {
                                        // provider.removeController(categoryName);
                                        // provider.removeCategoryColor(categoryName);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )
                                  ),
                                ],
                              ),

                              // Category Name
                              _customDetailRow(
                                key: 'Category Name',
                                controller: provider.controllers[categoryName]!.categoryNameController,
                              ),

                              // Collection ID
                              _customDetailRow(
                                key: 'Collection ID',
                                controller: provider.controllers[categoryName]!.collectionIdController,
                              ),

                              Row(
                                children: [

                                  // Position
                                  Expanded(
                                    child: _customDetailRow(
                                        key: 'Position',
                                        controller: provider.controllers[categoryName]!.positionController,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                        ]
                                    ),
                                  ),

                                  const SizedBox(width: 100),

                                  const Text(
                                    'Gradient Colors',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:  Colors.black,
                                    ),
                                  ),

                                  const SizedBox(width: 25),

                                  // Gradient Color 1
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      children: [
                                        Container(
                                            width: 25,
                                            height: 25,
                                            color: color1
                                        ),

                                        TextButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return CustomColorPicker(
                                                      pickerColor: color1,
                                                      onColorChanged: (color) {
                                                        provider.setCategoryColor(categoryName, 1, color.toHexString());
                                                      }
                                                  );
                                                },
                                              );
                                            },
                                            child: Text(
                                              'Gradient Color 1',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: color1,
                                              ),
                                            )
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 50),

                                  // Gradient Color 2
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      children: [
                                        Container(
                                            width: 25,
                                            height: 25,
                                            color: color2
                                        ),

                                        TextButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return CustomColorPicker(
                                                      pickerColor: color2,
                                                      onColorChanged: (color) {
                                                        provider.setCategoryColor(categoryName, 2, color.toHexString());
                                                      }
                                                  );
                                                },
                                              );
                                            },
                                            child: Text(
                                              'Gradient Color 2',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: color2,
                                              ),
                                            )
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 50),
                                ],
                              )
                            ],
                          ),
                        );
                      }
                  ),

                  const SizedBox(height: 20),

                  InkWell(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        Utils.showLoadingBox(context: context, title: 'Saving Category...');
                        bool isSaved = await provider.saveCategory(rowIndex: widget.index + 1, categories: provider.category[widget.index]);
                        if (isSaved) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      } else {
                        log('Not Validated..!');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 50),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(25)
                      ),
                      child: const Text(
                        'SAVE',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _customDetailRow({
    required String key,
    required TextEditingController controller,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            child: Text(
              key,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Flexible(
            child: TextFormField(
              controller: controller,
              inputFormatters: inputFormatters,
              validator: (string) {
                if (controller.text.trim().isEmpty) {
                  return '$key is required..!!';
                }
                return null;
              },
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: key,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
                fillColor: boxColor,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 1,
                  )
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}
