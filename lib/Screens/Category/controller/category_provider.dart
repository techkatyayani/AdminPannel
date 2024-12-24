import 'dart:developer';

import 'package:adminpannal/Screens/Category/service/category_service.dart';
import 'package:adminpannal/Screens/Crops/cropCalenderScreen.dart';
import 'package:flutter/material.dart';

import '../model/category.dart';

class CategoryProvider with ChangeNotifier {

  CategoryService categoryService = CategoryService();

  List<List<Category>> _category = [];
  List<List<Category>> get category => _category;
  void removeCategory(int i1, int i2) {
    _category[i1].removeAt(i2);
    notifyListeners();
  }

  Map<String, dynamic> data = {
    'Fungicides': {
      'categoryName': TextEditingController(),
      'collectionID': TextEditingController(),
      'position': TextEditingController(),
    }
  };

  final Map<String, TextController> _controllers = {};
  Map<String, TextController> get controllers => _controllers;
  void initController(List<Category> categories) {
    _controllers.clear();

    for (var category in categories) {
      _controllers[category.categoryName] = TextController(
        categoryNameController: TextEditingController(text: category.categoryName),
        collectionIdController: TextEditingController(text: category.collectionId),
        positionController: TextEditingController(text: category.position),
      );
    }

    notifyListeners();
  }
  void addController(String categoryName, String key) {
    if (!_controllers.containsKey(categoryName)) {
      _controllers[categoryName] = TextController(
        categoryNameController: TextEditingController(),
        collectionIdController: TextEditingController(),
        positionController: TextEditingController(),
      );
      notifyListeners();
    }
  }
  void removeController(String categoryName) {
    if (_controllers.containsKey(categoryName)) {
      _controllers.remove(categoryName);
      notifyListeners();
    }
  }

  final Map<String, CategoryColor> _categoryColors = {};
  Map<String, CategoryColor> get categoryColors => _categoryColors;
  void initCategoryColors(List<Category> categories) {
    _categoryColors.clear();

    for (var category in categories) {
      _categoryColors[category.categoryName] = CategoryColor(
        color1: category.categoryColor1,
        color2: category.categoryColor1
      );
    }

    notifyListeners();
  }
  void setCategoryColor(String categoryName, int index, String colorCode) {
    if (_categoryColors.containsKey(categoryName)) {

      index == 1
          ?
      _categoryColors[categoryName]!.color1 = colorCode
          :
      _categoryColors[categoryName]!.color2 = colorCode;

      notifyListeners();
    }
  }
  void removeCategoryColor(String categoryName) {
    if (_categoryColors.containsKey(categoryName)) {
      _categoryColors.remove(categoryName);
      notifyListeners();
    }
  }

  Stream<List<List<Category>>> fetchCategoryRows() async* {
    List<List<Category>> category = await categoryService.fetchCategoryRows();
    _category = category;
    notifyListeners();
    yield category;
  }

  Future<bool> saveCategory({
    required int rowIndex,
    required List<Category> categories
  }) async {

    List<Category> updatedCategories = [];

    for (var category in categories) {

      String categoryName = category.categoryName;

      Category data = Category(
        collectionId: controllers[categoryName]!.collectionIdController.text.trim(),
        categoryName: controllers[categoryName]!.categoryNameController.text.trim(),
        categoryImage: category.categoryImage,
        categoryColor1: categoryColors[categoryName]!.color1.trim(),
        categoryColor2: categoryColors[categoryName]!.color2.trim(),
        position: controllers[categoryName]!.positionController.text.trim(),
        docId: category.docId,
      );

      updatedCategories.add(data);
    }

    bool isSaved = await categoryService.saveCategory(rowIndex: rowIndex, categories: updatedCategories);

    return isSaved;
  }
}

class TextController {
  final TextEditingController categoryNameController;
  final TextEditingController collectionIdController;
  final TextEditingController positionController;

  TextController({required this.categoryNameController, required this.collectionIdController, required this.positionController});
}

class CategoryColor {
  String color1;
  String color2;

  CategoryColor({required this.color1, required this.color2});
}