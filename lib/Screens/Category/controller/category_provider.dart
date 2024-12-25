import 'dart:developer';
import 'dart:typed_data';
import 'package:adminpannal/constants/app_constants.dart';

import 'package:adminpannal/Screens/Category/service/category_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


import '../model/category.dart';

class CategoryProvider with ChangeNotifier {

  CategoryService categoryService = CategoryService();

  Color getColorFromCode(String code) {
    return code != "" ? Color(int.parse('0x$code')) : boxColor;
  }

  List<List<Category>> _category = [];

  List<List<Category>> get category => _category;

  void removeCategory(int i1, int i2) {
    _category[i1].removeAt(i2);
    notifyListeners();
  }

  void initCategoryData(List<Category> categories) {
    initController(categories);
    initCategoryColors(categories);
    initCategoryImages(categories);

    notifyListeners();
  }

  final Map<String, TextController> _controllers = {};

  Map<String, TextController> get controllers => _controllers;

  void initController(List<Category> categories) {
    _controllers.clear();

    for (var category in categories) {
      _controllers[category.categoryName] = TextController(
        categoryNameController: TextEditingController(
            text: category.categoryName),
        collectionIdController: TextEditingController(
            text: category.collectionId),
        positionController: TextEditingController(text: category.position),
      );
    }
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

  final Map<String, String> _categoryImages = {};

  Map<String, String> get categoryImages => _categoryImages;

  void initCategoryImages(List<Category> categories) {
    _categoryImages.clear();

    for (var category in categories) {
      _categoryImages[category.categoryName] = category.categoryImage;
    }
  }

  void setCategoryImages(String categoryName, String path) {
    _categoryImages[categoryName] = path;
    notifyListeners();
  }

  ImagePicker imagePicker = ImagePicker();

  Uint8List? _pickedFile;

  Uint8List? get pickedFile => _pickedFile;

  void removePickedFile() {
    _pickedFile = null;
    notifyListeners();
  }

  Future<void> pickFile(String categoryName) async {
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      log('Image Picked..!!');
      log('Before $_pickedFile');
      _pickedFile = await file.readAsBytes();
      log('After $_pickedFile');
      notifyListeners();
    }
  }

  Future<String?> uploadFile() async {
    String? url = await categoryService.uploadImage(pickedFile);
    return url;
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
        collectionId: controllers[categoryName]!.collectionIdController.text
            .trim(),
        categoryName: controllers[categoryName]!.categoryNameController.text
            .trim(),
        categoryImage: categoryImages[categoryName]!,
        categoryColor1: categoryColors[categoryName]!.color1.trim(),
        categoryColor2: categoryColors[categoryName]!.color2.trim(),
        position: controllers[categoryName]!.positionController.text.trim(),
        docId: category.docId,
      );

      updatedCategories.add(data);
    }

    bool isSaved = await categoryService.saveCategory(
        rowIndex: rowIndex, categories: updatedCategories);

    if (isSaved) {
      _category[rowIndex - 1] = updatedCategories;
      notifyListeners();
    }

    return isSaved;
  }


  // Add Category

  TextEditingController categoryNameController = TextEditingController();
  TextEditingController collectionIdController = TextEditingController();
  TextEditingController positionController = TextEditingController();

  Uint8List? _categoryImage;

  Uint8List? get categoryImage => _categoryImage;

  String _color1 = '';

  String get color1 => _color1;

  void setColor1(String value) {
    _color1 = value;
    notifyListeners();
  }

  String _color2 = '';

  String get color2 => _color2;

  void setColor2(String value) {
    _color2 = value;
    notifyListeners();
  }

  Future<void> pickCategoryImage() async {
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      _categoryImage = await file.readAsBytes();
      notifyListeners();
    }
  }

  void clearCategoryAddDialog() {
    categoryNameController.clear();
    collectionIdController.clear();
    positionController.clear();
    _categoryImage = null;
    _color1 = '';
    _color2 = '';
    notifyListeners();
  }

  Future<bool> addCategory(int rowIndex) async {

    String categoryName = categoryNameController.text.trim();
    String collectionId = collectionIdController.text.trim();
    String position = positionController.text.trim();

    log('Category Name = $categoryName');
    log('Collection Id = $collectionId');
    log('Position = $position');
    log('Color1 = $color1');
    log('Color2 = $color2');
    log('File = ${categoryImage == null ? 'No' : 'Yes'}');
    log('Row Index = $rowIndex');

    Category? category = await categoryService.addCategory(
      categoryName: categoryName,
      collectionId: collectionId,
      position: position,
      color1: color1,
      color2: color2,
      file: categoryImage,
      rowIndex: rowIndex
    );

    if (category != null) {
      _category[rowIndex - 1].add(category);
    }

    return category != null ? true : false;
  }


}

class TextController {
  final TextEditingController categoryNameController;
  final TextEditingController collectionIdController;
  final TextEditingController positionController;

  TextController(
      {required this.categoryNameController, required this.collectionIdController, required this.positionController});
}

class CategoryColor {
  String color1;
  String color2;

  CategoryColor({required this.color1, required this.color2});
}