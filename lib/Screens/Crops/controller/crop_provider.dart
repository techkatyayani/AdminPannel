import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class CropProvider with ChangeNotifier {

  ImagePicker imagePicker = ImagePicker();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;


  /// ADD CROP

  TextEditingController newCropNameController = TextEditingController();

  TextEditingController totalDurationOfNewCrop = TextEditingController();

  TextEditingController newDiseaseNameController = TextEditingController();
  TextEditingController newCropCollectionIdController = TextEditingController();

  Uint8List? _selectedCropImage;
  Uint8List? get selectedCropImage => _selectedCropImage;
  void setSelectedCropImage(Uint8List? image) {
    _selectedCropImage = image;
    notifyListeners();
  }

  Uint8List? _selectedEnglishBannerImage;
  Uint8List? get selectedEnglishBannerImage => _selectedEnglishBannerImage;
  void setSelectedEnglishBannerImage(Uint8List? image) {
    _selectedEnglishBannerImage = image;
    notifyListeners();
  }

  Uint8List? _selectedHindiBannerImage;
  Uint8List? get selectedHindiBannerImage => _selectedHindiBannerImage;
  void setSelectedHindiBannerImage(Uint8List? image) {
    _selectedHindiBannerImage = image;
    notifyListeners();
  }

  Uint8List? _selectedDiseaseImage;
  Uint8List? get selectedDiseaseImage => _selectedDiseaseImage;
  void setSelectedDiseaseImage(Uint8List? image) {
    _selectedDiseaseImage = image;
    notifyListeners();
  }

  final List<Map<String, dynamic>> _diseaseDetails = [];
  List<Map<String, dynamic>> get diseaseDetails => _diseaseDetails;
  void addDiseaseDetails(Map<String, dynamic> data) {
    _diseaseDetails.add(data);

    newDiseaseNameController.clear();
    newCropCollectionIdController.clear();
    setSelectedDiseaseImage(null);

    notifyListeners();
  }
  void removeDiseaseDetails(int index) {
    _diseaseDetails.removeAt(index);
    notifyListeners();
  }

  void resetAddCropScreen() {
    newCropNameController.clear();
    totalDurationOfNewCrop.clear();
    _selectedCropImage = null;
    _selectedEnglishBannerImage = null;
    _selectedHindiBannerImage = null;

    _selectedDiseaseImage = null;
    newDiseaseNameController.clear();
    newCropCollectionIdController.clear();

    _diseaseDetails.clear();

    notifyListeners();
  }

  Future<Uint8List?> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      Uint8List? image = result.files.single.bytes;
      return image;
    }

    return null;
  }

  Future<bool> addNewCrop() async {
    try {
      log('Saving Crop Data...');

      final ref = firestore.collection('product');

      log('Getting Existing Crop Length...');
      final existingCrops = await ref.get();

      int length = existingCrops.docs.length;

      log('Uploading Crop Details Images...');
      List<String?> urls = await Future.wait([
        uploadImage(file: selectedCropImage!, path: 'Crops'),
        uploadImage(file: selectedEnglishBannerImage!, path: 'Crop Banners'),
        uploadImage(file: selectedHindiBannerImage!, path: 'Crop Banners'),
      ]);

      Map<String, dynamic> cropData = {
        'Image': urls[0].toString(),
        'Name': newCropNameController.text.trim(),
        'image2': urls[1].toString(),
        'hindiimage2': urls[2].toString(),
        'index': length + 1,
        'totalDuration': totalDurationOfNewCrop.text.trim(),
      };

      log('Saving Crop Details..');
      final docRef = ref.doc();

      await docRef.set(cropData);

      String id = docRef.id;

      log('Crop Doc Created with id = $id');

      final diseaseRef = docRef.collection('Disease');

      for (var disease in diseaseDetails) {
        log('Extracting Disease Image...');
        Uint8List image = disease['image'];

        log('Uploading Disease Image...');
        String? url = await uploadImage(file: image, path: 'Crop Disease');

        Map<String, dynamic> diseaseData = {
          'Image': url ?? '',
          'Name': disease['name'] ?? '',
          'id': disease['collectionId'] ?? '',
        };

        log('Saving Disease Details...');
        await diseaseRef.add(diseaseData);
      }

      log('New Crop Added Successfully :)');
      resetAddCropScreen();

      return true;

    } catch (e, s) {
      log('Error adding new crops..!!\n$e\n$s');
      return false;
    }
  }

  /// LANGUAGE FIELDS

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