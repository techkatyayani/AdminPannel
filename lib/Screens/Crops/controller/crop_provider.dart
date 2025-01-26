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

  List<String> states = [
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chhattisgarh",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal"
  ];


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
    _pickedStates.clear();

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
  
  final List<String> _pickedStates = [];
  List<String> get pickedStates => _pickedStates;
  void addPickedState(String state) {
    _pickedStates.add(state);
    notifyListeners();
  }
  void removePickedState(String state) {
    _pickedStates.removeWhere((test) => test == state);
    notifyListeners();
  }

  bool doesPickedStatesContain(String state){
    return _pickedStates.contains(state);
  }

  Future<bool> addNewCrop() async {
    try {
      log('Saving Crop Data...');

      final ref = firestore.collection('product');

      final docRef = ref.doc();
      String id = docRef.id;

      log('Getting Existing Crop Length...');
      final existingCrops = await ref.get();

      int length = existingCrops.docs.length;

      log('Uploading Crop Details Images...');
      List<String?> urls = await Future.wait([
        uploadImage(file: selectedCropImage!, path: '$id/Crop'),
        uploadImage(file: selectedEnglishBannerImage!, path: '$id/Crop Banners/English'),
        uploadImage(file: selectedHindiBannerImage!, path: '$id/Crop Banners/Hindi'),
      ]);

      Map<String, dynamic> cropData = {
        'Image': urls[0].toString(),
        'Name': newCropNameController.text.trim(),
        'image2': urls[1].toString(),
        'hindiimage2': urls[2].toString(),
        'index': (length + 1).toString(),
        'totalDuration': totalDurationOfNewCrop.text.trim(),
      };

      log('Saving Crop Details..');

      await docRef.set(cropData);

      log('Crop Doc Created with id = $id');

      final diseaseRef = docRef.collection('Disease');

      for (var disease in diseaseDetails) {

        final diseaseDocRef = diseaseRef.doc();

        log('Extracting Disease Image...');
        Uint8List image = disease['image'];

        log('Uploading Disease Image...');
        String? url = await uploadImage(file: image, path: '$id/Diseases/${diseaseDocRef.id}');

        Map<String, dynamic> diseaseData = {
          'Image': url ?? '',
          'Name': disease['name'] ?? '',
          'id': disease['collectionId'] ?? '',
        };

        log('Saving Disease Details...');
        await diseaseDocRef.set(diseaseData);

        await diseaseDocRef.collection('Symptoms').add({
          'englishSymptoms': [
            ''
          ],
        });
      }

      log('New Crop Added Successfully :)');

      if (pickedStates.isNotEmpty) {
        final stateRef = firestore.collection('Crops By State');
        for (var state in pickedStates) {
          await stateRef.doc(state)
            .set({
              'crops': [id]
            });
        }
      }
      
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
        imageUrl = await uploadImage(file: pickedCropImage!, path: '$cropId/Crops');
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

      final ref = firestore
          .collection('product')
          .doc(cropId)
          .collection('Disease')
          .doc(diseaseId);

      if (pickedDiseaseImage != null) {
        imageUrl = await uploadImage(file: pickedDiseaseImage!, path: '$cropId/Diseases/${ref.id}');
      }

      Map<String, dynamic> data = {
        'Name': diseaseNameController.text.trim(),
        'Image': imageUrl ?? '',
        'id': collectionIdController.text.trim(),

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


      await ref.set(data, SetOptions(merge: true));

      clearDiseaseDetailsDialog();

      return true;

    } catch (e, s) {
      log('Error Updating Disease Details..!!\n$e\n$s');
      return false;
    }
  }

  Future<bool> addDisease({
    required String cropId,
  }) async {
    try {

      String? imageUrl;

      final diseaseDocRef = firestore
          .collection('product')
          .doc(cropId)
          .collection('Disease')
          .doc();

      if (pickedDiseaseImage != null) {
        imageUrl = await uploadImage(file: pickedDiseaseImage!, path: '$cropId/Diseases/${diseaseDocRef.id}');
      }

      Map<String, dynamic> data = {
        'Name': diseaseNameController.text.trim(),
        'Image': imageUrl ?? diseaseImageUrl ?? '',
        'id': collectionIdController.text.trim(),

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

      await diseaseDocRef.set(data);

      await diseaseDocRef.collection('Symptoms').add({
        'englishSymptoms': [
          ''
        ],
      });

      clearDiseaseDetailsDialog();

      return true;

    } catch (e, s) {
      log('Error Adding Disease Details..!!\n$e\n$s');
      return false;
    }
  }

  Future<String?> uploadImage({
    required Uint8List file,
    required String path,
  }) async {
    try {

      final name = DateTime.now().millisecondsSinceEpoch;

      var ref = storage.ref('Crops').child('$path/$name');

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