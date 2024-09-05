// banner_provider.dart

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

class BannerProvider with ChangeNotifier {
  final List<String> englishStripBanner = [
    'new arrival.jpg',
    'farmersStrep',
    'organic product.jpg',
    'fertilizer.jpg',
    'insecticide.jpg',
    'herbicides.jpg',
    'plant_growth.jpg',
    'fungicide.jpg',
    'SpecialKitEnglish',
    'agri',
    'refer and earn.jpg',
    'Gst.jpg',
    'find your product.jpg',
    'shopByCategoryEng',
    'shopByCropEng'
  ];

  final List<String> hindiStripBanner = [
    'new arrival hindi.jpg',
    'farmersStrep hindi',
    'organic product hindi.jpg',
    'fertilizer hindi.jpg',
    'insecticide hindi.jpg',
    'herbicides hindi.jpg',
    'plant_growth hindi.jpg',
    'fungicide hindi.jpg',
    'SpecialKitHindi',
    'agri hindi',
    'refer and earn hindi.jpg',
    'Gst hindi.jpg',
    'find your product hindi.jpg',
    'shopByCategoryHi',
    'shopByCropHi',
  ];

  final List<String> productBetweenStripBanners = [
    'stripBanner1',
    'stripBanner2',
    'stripBanner3',
  ];

  final List<String> productBetweenStripBannersHindi = [
    'stripBannerHindi1',
    'stripBannerHindi2',
    'stripBannerHindi3',
  ];

  late Future<Map<String, dynamic>> userDataFuture;
  bool isLoading = false;

  BannerProvider() {
    userDataFuture = getImage();
  }

  Future<void> updateImage() async {
    userDataFuture = getImage();
    notifyListeners();
  }

  Future<Map<String, dynamic>> getImage() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('imagefromfirebase')
          .doc('Category')
          .get();
      return doc.data() ?? {};
    } catch (e) {
      print('Error fetching image data: $e');
      return {};
    }
  }

  Future<void> pickImageAndUpdate(String imageName) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      isLoading = true;
      notifyListeners();
      try {
        await FirebaseStorage.instance
            .ref()
            .child('swipe banner')
            .child(imageName)
            .delete();
      } catch (e) {
        print('Error deleting existing image: $e');
      }
      String? imageUrl =
          await uploadImage(result.files.single.bytes!, imageName);
      if (imageUrl != null) {
        await FirebaseFirestore.instance
            .collection('imagefromfirebase')
            .doc('Category')
            .set({imageName: imageUrl}, SetOptions(merge: true));
        updateImage();
      }
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> uploadImage(List<int> imageBytes, String imageName) async {
    try {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('swipe banner')
          .child(imageName)
          .putData(Uint8List.fromList(imageBytes));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
