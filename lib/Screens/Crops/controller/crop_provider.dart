import 'dart:developer';
import 'dart:typed_data';

import 'package:adminpannal/Utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CropProvider with ChangeNotifier {

  ImagePicker imagePicker = ImagePicker();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController cropNameController = TextEditingController();

  final TextEditingController bengaliNameController = TextEditingController();
  final TextEditingController englishNameController = TextEditingController();
  final TextEditingController hindiNameController = TextEditingController();
  final TextEditingController kannadaNameController = TextEditingController();
  final TextEditingController malayalamNameController = TextEditingController();
  final TextEditingController marathiNameController = TextEditingController();
  final TextEditingController oriyaNameController = TextEditingController();
  final TextEditingController tamilNameController = TextEditingController();
  final TextEditingController teluguNameController = TextEditingController();


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

    bengaliNameController.clear();
    englishNameController.clear();
    hindiNameController.clear();

    kannadaNameController.clear();
    malayalamNameController.clear();
    marathiNameController.clear();

    oriyaNameController.clear();
    tamilNameController.clear();
    teluguNameController.clear();

    _pickedCropImage = null;
    _cropImageUrl = null;

    notifyListeners();
  }

  Future<bool> updateCropDetails({
    required String cropId
  }) async {
    try {

      Map<String, dynamic> data = {
        'Name': cropNameController.text.trim(),
        'Image': cropImageUrl,

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

      // return true;

      await firestore.collection('product').doc(cropId).set(data, SetOptions(merge: true));

      clearCropDetailsDialog();

      return true;

    } catch (e, s) {
      log('Error Updating Crop Details..!!\n$e\n$s');
      return false;
    }
  }


}