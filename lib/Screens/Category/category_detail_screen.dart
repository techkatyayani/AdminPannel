import 'dart:developer';

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

class CategoryDetailScreen extends StatefulWidget {

  final int categoryIndex;
  final int subCategoryIndex;

  const CategoryDetailScreen({
    super.key,
    required this.categoryIndex,
    required this.subCategoryIndex,
  });

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          'Category Details',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white
          ),
        ),
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: const Text(
              'Category Name refers to unique key for category, it should be in english language only',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),

      body: Form(
        key: formKey,
        child: Consumer<CategoryProvider>(
          builder: (BuildContext context, CategoryProvider provider, Widget? child) {

            Category category = provider.category[widget.categoryIndex][widget.subCategoryIndex];

            String categoryName = category.categoryName;

            Color color1 = provider.getColorFromCode(provider.categoryColor1);
            Color color2 = provider.getColorFromCode(provider.categoryColor2);

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
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
                                      controller: provider.categoryNameController,
                                    ),

                                    const SizedBox(height: 15),

                                    // Collection ID
                                    _customDetailRow(
                                      key: 'Collection ID',
                                      controller: provider.collectionIdController,
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
                                    showUploadImageDialog();
                                  },
                                  child: provider.categoryImageUrl != ''
                                      ?
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      provider.categoryImageUrl,
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

                          const SizedBox(height: 10),

                          Row(
                            children: [

                              // Position
                              Expanded(
                                child: _customDetailRow(
                                  key: 'Position',
                                  controller: provider.positionController,
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
                                                    provider.setCategoryColor1(color.toHexString());
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
                                                    provider.setCategoryColor2(color.toHexString());
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
                          ),

                          const SizedBox(height: 15),

                          const Text(
                            'Multi Language Category Name',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: boxColor
                            ),
                          ),

                          const SizedBox(height: 15),

                          CustomPostTextField(
                            controller: provider.bengaliNameController,
                            hintText: 'Bengali',
                          ),

                          CustomPostTextField(
                            controller: provider.englishNameController,
                            hintText: 'English',
                          ),

                          CustomPostTextField(
                            controller: provider.hindiNameController,
                            hintText: 'Hindi',
                          ),

                          CustomPostTextField(
                            controller: provider.kannadaNameController,
                            hintText: 'Kannada',
                          ),

                          CustomPostTextField(
                            controller: provider.malayalamNameController,
                            hintText: 'Malayalam',
                          ),

                          CustomPostTextField(
                            controller: provider.marathiNameController,
                            hintText: 'Marathi',
                          ),

                          CustomPostTextField(
                            controller: provider.oriyaNameController,
                            hintText: 'Oriya',
                          ),

                          CustomPostTextField(
                            controller: provider.tamilNameController,
                            hintText: 'Tamil',
                          ),

                          CustomPostTextField(
                            controller: provider.teluguNameController,
                            hintText: 'Telugu',
                          ),

                          const SizedBox(width: 15),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  InkWell(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        Utils.showLoadingBox(context: context, title: 'Saving Category Details...');

                        bool isSaved = await provider.saveCategory(
                          categoryIndex: widget.categoryIndex,
                          subCategoryIndex: widget.subCategoryIndex,
                          docId: category.docId,
                        );

                        if (isSaved) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }

                      }
                      else {
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

                  const SizedBox(height: 25),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void showUploadImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Consumer<CategoryProvider>(
              builder: (BuildContext context, CategoryProvider provider, Widget? child) {
                return Container(
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

                      GestureDetector(
                        onTap: () async {
                          await provider.pickFile();
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
                              height: 100,
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
                      ),

                      const SizedBox(height: 50),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                provider.removePickedFile();
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
                                }
                                else {
                                  provider.setCategoryImageUrl(path);
                                  Navigator.pop(context);
                                  Utils.showSnackBar(context: context, message: 'Image uploaded successfully. Press Save button to apply changes :)');
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
                );
              },
            ),
          );
        }
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
