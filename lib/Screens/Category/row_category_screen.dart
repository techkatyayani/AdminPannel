import 'package:adminpannal/Screens/Category/category_detail_screen.dart';
import 'package:adminpannal/Screens/Category/controller/category_provider.dart';
import 'package:adminpannal/Screens/Category/model/category.dart';
import 'package:adminpannal/Screens/Krishi%20News/widgets/custom_post_text_field.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:adminpannal/common/custom_color_picker.dart';
import 'package:adminpannal/common/custom_media_upload_card.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../Krishi News/krishi_news_screen.dart';

class RowCategoryScreen extends StatelessWidget {

  final int categoryIndex;

  const RowCategoryScreen({super.key, required this.categoryIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white
          ),
        ),
      ),
      body: Consumer<CategoryProvider>(
        builder: (BuildContext context, CategoryProvider provider, Widget? child) {
          return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 300,
              ),
              itemCount: provider.category[categoryIndex].length,
              itemBuilder: (context, i) {

                Category category = provider.category[categoryIndex][i];

                return GestureDetector(
                  onTap: () {

                    provider.setCategoryDetails(category);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CategoryDetailScreen(
                        categoryIndex: categoryIndex,
                        subCategoryIndex: i,
                      ))
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                category.categoryName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white
                                  ),
                                ),
                              )
                            ],
                          ),

                          const SizedBox(height: 10),

                          Image.network(
                            category.categoryImage,
                            fit: BoxFit.fill,
                            height: 200,
                            errorBuilder: (c, e, s) {
                              return const Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.photo,
                                      color: boxColor,
                                      size: 50,
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
          );
        },
      ),

      floatingActionButton: GestureDetector(
        onTap: () {
          showAddCategoryDialog(context);
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

  void showAddCategoryDialog(BuildContext context) {
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
                            child: provider.addCategoryImage == null
                                ?
                            const CustomMediaUploadCard(
                              mediaRatio: 'Small Icon with transparent background (50 x 50)',
                            )
                                :
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(
                                provider.addCategoryImage!,
                                width: MediaQuery.of(context).size.width * 0.25,
                                height: MediaQuery.of(context).size.height * 0.25,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          CustomPostTextField(
                            controller: provider.addCategoryNameController,
                            hintText: 'Category Name',
                            width: 150,
                          ),

                          CustomPostTextField(
                            controller: provider.addCollectionIdController,
                            hintText: 'Collection ID',
                            width: 150,
                          ),

                          CustomPostTextField(
                            controller: provider.addPositionController,
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
                                        if (provider.addCategoryImage != null) {

                                          Utils.showLoadingBox(context: context, title: 'Adding Category...');

                                          bool isAdded = await provider.addCategory(categoryIndex);

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
