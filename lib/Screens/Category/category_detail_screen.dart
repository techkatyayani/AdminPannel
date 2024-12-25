import 'dart:developer';
import 'dart:io';

import 'package:adminpannal/Screens/Category/controller/category_provider.dart';
import 'package:adminpannal/Screens/Category/model/category.dart';
import 'package:adminpannal/Screens/Krishi%20News/widgets/custom_post_text_field.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:adminpannal/common/custom_color_picker.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../Krishi News/krishi_news_screen.dart';

class CategoryDetailScreen extends StatefulWidget {

  final int index;

  const CategoryDetailScreen({super.key, required this.index});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {

  final formKey = GlobalKey<FormState>();

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

                        Color color1 = provider.getColorFromCode(provider.categoryColors[categoryName]?.color1 ?? '');
                        Color color2 = provider.getColorFromCode(provider.categoryColors[categoryName]?.color2 ?? '');

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
                              Text(
                                categoryName,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: krishiPrimaryColor
                                ),
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [

                                        // Category Name
                                        _customDetailRow(
                                          key: 'Category Name',
                                          controller: provider.controllers[categoryName]!.categoryNameController,
                                        ),

                                        const SizedBox(height: 15),

                                        // Collection ID
                                        _customDetailRow(
                                          key: 'Collection ID',
                                          controller: provider.controllers[categoryName]!.collectionIdController,
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.2,
                                    height: MediaQuery.of(context).size.height * 0.2,
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              backgroundColor: Colors.white,
                                              child: Container(
                                                width: MediaQuery.of(context).size.width * 0.4,
                                                padding: const EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [

                                                    const SizedBox(height: 25),

                                                    const Text(
                                                      'Select Image',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black
                                                      ),
                                                    ),

                                                    const SizedBox(height: 25),

                                                    Consumer<CategoryProvider>(
                                                      builder: (BuildContext context, CategoryProvider provider, Widget? child) {
                                                        return GestureDetector(
                                                          onTap: () async {
                                                            await provider.pickFile(categoryName);
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                                            child: provider.pickedFile != null
                                                                ?
                                                            ClipRRect(
                                                              borderRadius: BorderRadius.circular(10),
                                                              child: Image.memory(
                                                                provider.pickedFile!,
                                                                width: double.maxFinite,
                                                                errorBuilder: (context, error, stace) {
                                                                  return const Icon(
                                                                    Icons.error,
                                                                    color: boxColor,
                                                                    size: 50,
                                                                  );
                                                                },
                                                              ),
                                                            )
                                                                :
                                                            Container(
                                                              padding: const EdgeInsets.symmetric(vertical: 25),
                                                              decoration: BoxDecoration(
                                                                color: krishiFontColorPallets[2],
                                                                borderRadius: BorderRadius.circular(10),
                                                                border: const Border.fromBorderSide(
                                                                  BorderSide(
                                                                    color: boxColor,
                                                                    width: 2,
                                                                  ),
                                                                ),
                                                              ),
                                                              alignment: Alignment.center,
                                                              child: const Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Icon(
                                                                    Icons.cloud_upload_outlined,
                                                                    color: boxColor,
                                                                    size: 50,
                                                                  ),

                                                                  SizedBox(height: 20),

                                                                  Text(
                                                                    'Upload Image',
                                                                    style: TextStyle(
                                                                        fontSize: 16,
                                                                        color: boxColor,
                                                                        fontWeight: FontWeight.bold
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),

                                                    const SizedBox(height: 50),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            child: const Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.red,
                                                              ),
                                                            )
                                                        ),

                                                        const SizedBox(width: 5),

                                                        TextButton(
                                                          onPressed: () async {

                                                            Utils.showLoadingBox(context: context, title: 'Saving Image..');

                                                            String? path = await provider.uploadFile();

                                                            Navigator.pop(context);

                                                            if (path == null) {
                                                              Navigator.pop(context);
                                                              Utils.showSnackBar(context: context, message: 'Error uploading image..!!');
                                                            } else {
                                                              provider.setCategoryImages(categoryName, path ?? '');
                                                              Navigator.pop(context);
                                                            }
                                                          },
                                                          child: const Text(
                                                            'Upload',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black,
                                                            ),
                                                          )
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        );
                                      },
                                      child: category.categoryImage != ''
                                          ?
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          category.categoryImage,
                                          width: double.maxFinite,
                                          errorBuilder: (context, error, stace) {
                                            return const Icon(
                                              Icons.error,
                                              color: boxColor,
                                              size: 50,
                                            );
                                          },
                                        ),
                                      )
                                          :
                                      Container(
                                        width: double.maxFinite,
                                        decoration: BoxDecoration(
                                          color: krishiFontColorPallets[2],
                                          borderRadius: BorderRadius.circular(10),
                                          border: const Border.fromBorderSide(
                                            BorderSide(
                                              color: boxColor,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.cloud_upload_outlined,
                                              color: boxColor,
                                              size: 50,
                                            ),

                                            SizedBox(height: 20),

                                            Text(
                                              'Upload Image',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: boxColor,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              const SizedBox(width: 25),

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
      floatingActionButton: GestureDetector(
        onTap: () {
          showAddCategoryDialog();
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: krishiPrimaryColor,
            shape: BoxShape.circle
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
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

  void showAddCategoryDialog() {
    final formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) {
          return Form(
            key: formKey,
            child: Dialog(
              backgroundColor: Colors.white,
              child: Consumer<CategoryProvider>(
                builder: (BuildContext context, CategoryProvider provider, Widget? child) {

                  Color color1 = provider.getColorFromCode(provider.color1);
                  Color color2 = provider.getColorFromCode(provider.color2);

                  return Container(
                    height: MediaQuery.of(context).size.height * 0.9,
                    width: MediaQuery.of(context).size.width * 0.75,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Text(
                            'Add Category',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                            ),
                          ),

                          const SizedBox(height: 20),

                          GestureDetector(
                            onTap: provider.pickCategoryImage,
                            child: provider.categoryImage == null
                                ?
                            buildUploadIcon(context, false)
                                :
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(
                                provider.categoryImage!,
                                width: double.maxFinite,
                                height: MediaQuery.of(context).size.height * 0.25,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          CustomPostTextField(
                            controller: provider.categoryNameController,
                            hintText: 'Category Name',
                            width: 150,
                          ),

                          CustomPostTextField(
                            controller: provider.collectionIdController,
                            hintText: 'Collection ID',
                            width: 150,
                          ),

                          CustomPostTextField(
                            controller: provider.positionController,
                            hintText: 'Position',
                            width: 150,
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [

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
                                                  provider.setColor1(color.toHexString());
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
                                                    provider.setColor2(color.toHexString());
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
                            ],
                          ),

                          const SizedBox(height: 40),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _customButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  provider.clearCategoryAddDialog();
                                },
                                btnText: 'Cancel',
                                textColor: Colors.black
                              ),

                              const SizedBox(width: 30),

                              _customButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    if ( provider.color1 != '' && provider.color2 != '') {
                                      if (provider.categoryImage != null) {

                                        Utils.showLoadingBox(context: context, title: 'Adding Category...');

                                        bool isAdded = await provider.addCategory(widget.index + 1);

                                        Navigator.pop(context);

                                        if (isAdded) {
                                          provider.clearCategoryAddDialog();
                                          Navigator.pop(context);
                                          Navigator.pop(context);

                                          Utils.showSnackBar(context: context, message: 'Category Added Successfully :)');
                                        }
                                      } else {
                                        Utils.showSnackBar(context: context, message: 'Please add category image..!!');
                                      }
                                    } else {
                                      Utils.showSnackBar(context: context, message: 'Please add gradient color..!!');
                                    }
                                  }
                                },
                                btnText: 'Add',
                                textColor: krishiPrimaryColor
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
    );
  }

  Widget _customButton({
    required VoidCallback onPressed,
    required String btnText,
    required Color textColor,
  }) {
    return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
        ),
        child: Text(
          btnText,
          style: TextStyle(
              fontSize: 18,
              color: textColor,
              fontWeight: textColor == Colors.black ? FontWeight.normal : FontWeight.bold
          ),
        )
    );
  }

}
