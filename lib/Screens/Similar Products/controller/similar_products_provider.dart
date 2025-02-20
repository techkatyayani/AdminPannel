import 'dart:developer';
import 'dart:typed_data';

import 'package:adminpannal/Utils/app_language.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SimilarProductsProvider with ChangeNotifier {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Stream<Map<String, dynamic>> fetchSimilarProductsBanner() async* {
    try {
      log('Fetching Similar Products Banner...');

      QuerySnapshot<Map<String, dynamic>> query = await firestore.collection('Similar Products').get();

      int index = query.docs.indexWhere((doc) => doc.id == 'banner');

      if (index != -1) {
        final doc = query.docs[index];
        Map<String, dynamic> data = doc.data();
        yield data;
      }

    } catch (e, s) {
      log('Error fetching Similar Products Banner :- $e\n$s');
    }
  }

  Stream<Map<String, Map<String, dynamic>>> fetchSimilarProductsData() async* {
    try {
      log('Fetching Similar Products Data...');

      QuerySnapshot<Map<String, dynamic>> query = await firestore.collection('Similar Products').get();

      Map<String, Map<String, dynamic>> similarProductsData = {};

      for (var doc in query.docs) {
        if (doc.exists) {
          if (doc.id != 'banner') {
            similarProductsData[doc.id] = doc.data();
          }
        }
      }

      yield similarProductsData;

    } catch (e, s) {
      log('Error fetching Similar Products Data :- $e\n$s');
    }
  }


  /// SIMILAR PRODUCT IDs

  final TextEditingController _productIdController = TextEditingController();
  TextEditingController get productIdController => _productIdController;

  final List<TextEditingController> _productControllers = [];

  List<TextEditingController> get productControllers => _productControllers;

  void addProductController() {
    _productControllers.add(TextEditingController());
    notifyListeners();
  }

  void removeProductController(int index) {
    _productControllers.removeAt(index);
    notifyListeners();
  }

  void initProductControllers(List<String> ids) {

    _productControllers.clear();

    for (var id in ids) {
      _productControllers.add(TextEditingController(text: id));
    }
    notifyListeners();
  }

  void initAddProductIdDialog() {
    _productIdController.clear();
    _productControllers.clear();
  }

  Future<bool> saveSimilarProductsIds({String? docId}) async {
    try {

      log('Saving product ids...');

      final ref = firestore.collection('Similar Products');

      Map<String, dynamic> data = {
        'products': productControllers.map((controller) => controller.text.trim()).toList()
      };

      if (docId != null) {
        ref.doc(docId).set(data);
      }
      else {
        ref.doc(productIdController.text.trim()).set(data);
      }

      return true;

    } catch (e, s) {
      log('Error saving product ids..!!\n$e\n$s');
      return false;
    }
  }


  /// SIMILAR PRODUCT BANNER

  final Map<String, Uint8List?> _pickedImages = {};
  Map<String, Uint8List?> get pickedImages => _pickedImages;
  void addPickedImage(String key, Uint8List? image) {
    _pickedImages[key] = image;
    notifyListeners();
  }
  void removePickedImage(String key) {
    _pickedImages.remove(key);
    notifyListeners();
  }

  Future<bool> saveSimilarProductsBannerImages() async {
    try {

      log('Saving similar products banners images...');

      final ref = firestore.collection('Similar Products').doc('banner');

      for (var entries in pickedImages.entries) {
        String language = entries.key;
        Uint8List? file = entries.value;

        if (file != null) {
          String? url = await uploadImage(file: file, path: language);

          String docKey = AppLanguage.languageNameToCode[language]!;

          ref.set(
            {'banner_$docKey': url ?? ''},
            SetOptions(merge: true),
          );
        }
      }

      return true;

    } catch (e, s) {
      log('Error saving similar products banners images..!!\n$e\n$s');
      return false;
    }
  }

  Future<Uint8List?> pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final Uint8List imageBytes = await pickedImage.readAsBytes();
      return imageBytes;
    }

    return null;
  }

  Future<String?> uploadImage({
    required Uint8List file,
    required String path,
  }) async {
    try {

      var ref = storage.ref('Similar Products').child(path);

      UploadTask task = ref.putData(file);

      TaskSnapshot snapshot = await task;

      String imageUrl = await snapshot.ref.getDownloadURL();

      return imageUrl;

    } catch (e, s) {
      log('Error uploading image..!!\n$e\n$s');
      return null;
    }
  }
}