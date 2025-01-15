import 'dart:developer';
import 'dart:typed_data';

import 'package:adminpannal/Utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CropProvider with ChangeNotifier {

  ImagePicker imagePicker = ImagePicker();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  final TextEditingController bengaliNameController = TextEditingController();
  final TextEditingController englishNameController = TextEditingController();
  final TextEditingController hindiNameController = TextEditingController();
  final TextEditingController kannadaNameController = TextEditingController();
  final TextEditingController malayalamNameController = TextEditingController();
  final TextEditingController marathiNameController = TextEditingController();
  final TextEditingController oriyaNameController = TextEditingController();
  final TextEditingController tamilNameController = TextEditingController();
  final TextEditingController teluguNameController = TextEditingController();

  void initLanguageFields({
    required String bengaliName,
    required String englishName,
    required String hindiName,
    required String kannadaName,
    required String malayalamName,
    required String marathiName,
    required String oriyaName,
    required String tamilName,
    required String teluguName,
  }) {
    bengaliNameController.text = bengaliName;
    englishNameController.text = englishName;
    hindiNameController.text = hindiName;
    kannadaNameController.text = kannadaName;
    malayalamNameController.text = malayalamName;
    marathiNameController.text = marathiName;
    oriyaNameController.text = oriyaName;
    tamilNameController.text = tamilName;
    teluguNameController.text = teluguName;
  }

  void clearLanguageFields() {
    bengaliNameController.clear();
    englishNameController.clear();
    hindiNameController.clear();

    kannadaNameController.clear();
    malayalamNameController.clear();
    marathiNameController.clear();

    oriyaNameController.clear();
    tamilNameController.clear();
    teluguNameController.clear();
  }


  /// CROP DETAILS


  TextEditingController cropNameController = TextEditingController();

  Uint8List? _pickedCropImage;
  Uint8List? get pickedCropImage => _pickedCropImage;
  void setPickedCropImage(Uint8List? image) {
    _pickedCropImage = image;
    notifyListeners();
  }

  String? _cropImageUrl;
  String? get cropImageUrl => _cropImageUrl;
  void setCropImageUrl(String? url) {
    _cropImageUrl = url;
    notifyListeners();
  }

  Future<void> pickCropImage() async {
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      _pickedCropImage = await file.readAsBytes();
      notifyListeners();
    }
  }

  void initCropDetailsDialog({
    required String cropName,
    required String cropImage,
  }) {
    cropNameController.text = cropName;
    _cropImageUrl = cropImage;
    notifyListeners();
  }

  void clearCropDetailsDialog() {
    cropNameController.clear();

    _pickedCropImage = null;
    _cropImageUrl = null;

    clearLanguageFields();

    notifyListeners();
  }

  Future<bool> updateCropDetails({
    required String cropId
  }) async {
    try {

      String? imageUrl;

      if (pickedCropImage != null) {
        imageUrl = await uploadImage(file: pickedCropImage!, path: 'Crop Images');
      }

      Map<String, dynamic> data = {
        'Name': cropNameController.text.trim(),
        'Image': imageUrl ?? cropImageUrl ?? '',

        'name_bn': bengaliNameController.text.trim(),
        'name_en': englishNameController.text.trim(),
        'name_hi': hindiNameController.text.trim(),

        'name_kn': kannadaNameController.text.trim(),
        'name_ml': malayalamNameController.text.trim(),
        'name_mr': marathiNameController.text.trim(),

        'name_or': oriyaNameController.text.trim(),
        'name_ta': tamilNameController.text.trim(),
        'name_tl': teluguNameController.text.trim(),
      };

      log('Crop Details = $data');

      await firestore.collection('product').doc(cropId).set(data, SetOptions(merge: true));

      clearCropDetailsDialog();

      return true;

    } catch (e, s) {
      log('Error Updating Crop Details..!!\n$e\n$s');
      return false;
    }
  }


  /// CROP DISEASE DETAILS


  TextEditingController diseaseNameController = TextEditingController();
  TextEditingController collectionIdController = TextEditingController();

  Uint8List? _pickedDiseaseImage;
  Uint8List? get pickedDiseaseImage => _pickedDiseaseImage;
  void setPickedDiseaseImage(Uint8List? image) {
    _pickedDiseaseImage = image;
    notifyListeners();
  }

  String? _diseaseImageUrl;
  String? get diseaseImageUrl => _diseaseImageUrl;
  void setDiseaseImageUrl(String? url) {
    _diseaseImageUrl = url;
    notifyListeners();
  }

  Future<void> pickDiseaseImage() async {
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      _pickedDiseaseImage = await file.readAsBytes();
      notifyListeners();
    }
  }

  void initDiseaseDetailsDialog({
    required String diseaseName,
    required String collectionId,
    required String diseaseImage,
  }) {
    diseaseNameController.text = diseaseName;
    collectionIdController.text = collectionId;
    _diseaseImageUrl = diseaseImage;
    notifyListeners();
  }

  void clearDiseaseDetailsDialog() {
    diseaseNameController.clear();
    collectionIdController.clear();

    _pickedDiseaseImage = null;
    _diseaseImageUrl = null;

    clearLanguageFields();

    notifyListeners();
  }

  Future<bool> updateDiseaseDetails({
    required String cropId,
    required String diseaseId,
  }) async {
    try {

      String? imageUrl;

      if (pickedDiseaseImage != null) {
        imageUrl = await uploadImage(file: pickedDiseaseImage!, path: 'Crop Diseases');
      }

      Map<String, dynamic> data = {
        'Name': diseaseNameController.text.trim(),
        'Image': imageUrl ?? diseaseImageUrl ?? '',

        'name_bn': bengaliNameController.text.trim(),
        'name_en': englishNameController.text.trim(),
        'name_hi': hindiNameController.text.trim(),

        'name_kn': kannadaNameController.text.trim(),
        'name_ml': malayalamNameController.text.trim(),
        'name_mr': marathiNameController.text.trim(),

        'name_or': oriyaNameController.text.trim(),
        'name_ta': tamilNameController.text.trim(),
        'name_tl': teluguNameController.text.trim(),
      };

      log('Disease Details = $data');

      await firestore
          .collection('product')
          .doc(cropId)
          .collection('Disease')
          .doc(diseaseId)
          .set(data, SetOptions(merge: true));

      clearDiseaseDetailsDialog();

      return true;

    } catch (e, s) {
      log('Error Updating Disease Details..!!\n$e\n$s');
      return false;
    }
  }

  Future<String?> uploadImage({
    required Uint8List file,
    required String path,
  }) async {
    try {

      var ref = storage.ref().child(path);

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