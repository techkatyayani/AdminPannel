import 'dart:developer';
import 'dart:typed_data';
import 'package:adminpannal/constants/app_constants.dart';

import 'package:adminpannal/Screens/Category/service/category_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/category.dart';

class CategoryProvider with ChangeNotifier {
  CategoryService categoryService = CategoryService();

  ImagePicker imagePicker = ImagePicker();

  Color getColorFromCode(String code) {
    return code != "" ? Color(int.parse('0x$code')) : boxColor;
  }

  List<List<Category>> _category = [];

  List<List<Category>> get category => _category;

  // Category Details

  final TextEditingController categoryNameController = TextEditingController();
  final TextEditingController collectionIdController = TextEditingController();
  final TextEditingController positionController = TextEditingController();

  final TextEditingController bengaliNameController = TextEditingController();
  final TextEditingController englishNameController = TextEditingController();
  final TextEditingController hindiNameController = TextEditingController();
  final TextEditingController kannadaNameController = TextEditingController();
  final TextEditingController malayalamNameController = TextEditingController();
  final TextEditingController marathiNameController = TextEditingController();
  final TextEditingController oriyaNameController = TextEditingController();
  final TextEditingController tamilNameController = TextEditingController();
  final TextEditingController teluguNameController = TextEditingController();

  String _categoryColor1 = '';

  String get categoryColor1 => _categoryColor1;

  void setCategoryColor1(String code) {
    _categoryColor1 = code;
    notifyListeners();
  }

  String _categoryColor2 = '';

  String get categoryColor2 => _categoryColor2;

  void setCategoryColor2(String code) {
    _categoryColor2 = code;
    notifyListeners();
  }

  String _categoryImageUrl = '';

  String get categoryImageUrl => _categoryImageUrl;

  void setCategoryImageUrl(String url) {
    _categoryImageUrl = url;
    notifyListeners();
  }

  Uint8List? _pickedFile;

  Uint8List? get pickedFile => _pickedFile;

  void removePickedFile() {
    _pickedFile = null;
    notifyListeners();
  }

  void setCategoryDetails(Category category) {
    categoryNameController.text = category.categoryName;
    collectionIdController.text = category.collectionId;
    positionController.text = category.position;

    bengaliNameController.text = category.nameBn;
    englishNameController.text = category.nameEn;
    hindiNameController.text = category.nameHi;

    kannadaNameController.text = category.nameKn;
    malayalamNameController.text = category.nameMl;
    marathiNameController.text = category.nameMr;

    oriyaNameController.text = category.nameOr;
    tamilNameController.text = category.nameTa;
    teluguNameController.text = category.nameBn;

    _categoryColor1 = category.categoryColor1;
    _categoryColor2 = category.categoryColor2;
    _categoryImageUrl = category.categoryImage;

    notifyListeners();
  }

  void resetCategoryDetails() {
    categoryNameController.clear();
    collectionIdController.clear();
    positionController.clear();

    bengaliNameController.clear();
    englishNameController.clear();
    hindiNameController.clear();

    kannadaNameController.clear();
    malayalamNameController.clear();
    marathiNameController.clear();

    oriyaNameController.clear();
    tamilNameController.clear();
    teluguNameController.clear();

    _categoryColor1 = '';
    _categoryColor2 = '';
    _categoryImageUrl = '';
    _pickedFile = null;

    notifyListeners();
  }

  Future<void> pickFile() async {
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
    required int categoryIndex,
    required int subCategoryIndex,
    required String docId,
  }) async {
    int rowIndex = categoryIndex + 1;

    Category updatedCategory = Category(
      collectionId: collectionIdController.text.trim(),
      categoryName: categoryNameController.text.trim(),
      categoryImage: categoryImageUrl,
      categoryColor1: categoryColor1,
      categoryColor2: categoryColor2,
      position: positionController.text.trim(),
      docId: docId,
      nameBn: bengaliNameController.text.trim(),
      nameEn: englishNameController.text.trim(),
      nameHi: hindiNameController.text.trim(),
      nameKn: kannadaNameController.text.trim(),
      nameMl: malayalamNameController.text.trim(),
      nameMr: marathiNameController.text.trim(),
      nameOr: oriyaNameController.text.trim(),
      nameTa: tamilNameController.text.trim(),
      nameTl: teluguNameController.text.trim(),
    );

    bool isSaved = await categoryService.saveCategory(
        rowIndex: rowIndex, category: updatedCategory);

    if (isSaved) {
      _category[categoryIndex][subCategoryIndex] = updatedCategory;
      notifyListeners();
    }

    return isSaved;
  }

  // Add Category

  TextEditingController addCategoryNameController = TextEditingController();
  TextEditingController addCollectionIdController = TextEditingController();
  TextEditingController addPositionController = TextEditingController();

  final TextEditingController addBengaliNameController = TextEditingController();
  final TextEditingController addEnglishNameController = TextEditingController();
  final TextEditingController addHindiNameController = TextEditingController();

  final TextEditingController addKannadaNameController = TextEditingController();
  final TextEditingController addMalayalamNameController = TextEditingController();
  final TextEditingController addMarathiNameController = TextEditingController();

  final TextEditingController addOriyaNameController = TextEditingController();
  final TextEditingController addTamilNameController = TextEditingController();
  final TextEditingController addTeluguNameController = TextEditingController();

  Uint8List? _addCategoryImage;

  Uint8List? get addCategoryImage => _addCategoryImage;

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
      _addCategoryImage = await file.readAsBytes();
      notifyListeners();
    }
  }

  void clearCategoryAddDialog() {
    addCategoryNameController.clear();
    addCollectionIdController.clear();
    addPositionController.clear();

    addBengaliNameController.clear();
    addEnglishNameController.clear();
    addHindiNameController.clear();

    addKannadaNameController.clear();
    addMalayalamNameController.clear();
    addMarathiNameController.clear();

    addOriyaNameController.clear();
    addTamilNameController.clear();
    addTeluguNameController.clear();

    _addCategoryImage = null;
    _color1 = '';
    _color2 = '';
    notifyListeners();
  }

  Future<bool> addCategory(int categoryIndex) async {
    int rowIndex = categoryIndex + 1;

    String categoryName = addCategoryNameController.text.trim();
    String collectionId = addCollectionIdController.text.trim();
    String position = addPositionController.text.trim();

    String nameBn = addBengaliNameController.text.trim();
    String nameEn = addEnglishNameController.text.trim();
    String nameHi = addHindiNameController.text.trim();

    String nameKn = addKannadaNameController.text.trim();
    String nameMl = addMalayalamNameController.text.trim();
    String nameMr = addMarathiNameController.text.trim();

    String nameOr = addOriyaNameController.text.trim();
    String nameTa = addTamilNameController.text.trim();
    String nameTl = addTeluguNameController.text.trim();

    Category newCategory = Category(
      collectionId: collectionId,
      categoryName: categoryName,
      position: position,
      categoryImage: '',
      categoryColor1: categoryColor1,
      categoryColor2: categoryColor2,
      docId: '',
      nameBn: nameBn,
      nameEn: nameEn,
      nameHi: nameHi,
      nameKn: nameKn,
      nameMl: nameMl,
      nameMr: nameMr,
      nameOr: nameOr,
      nameTa: nameTa,
      nameTl: nameTl
    );

    Category? category = await categoryService.addCategory(
      category: newCategory,
      file: addCategoryImage,
      rowIndex: rowIndex,
    );

    if (category != null) {
      _category[categoryIndex].add(category);
    }

    return category != null ? true : false;
  }
}
