import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SimilarProductsProvider with ChangeNotifier {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Map<String, String> languagesMap = {
    'Bengali': 'bn',
    'English': 'en',
    'Hindi': 'hi',
    'Kannada': 'kn',
    'Malayalam': 'ml',
    'Marathi': 'mr',
    'Odia': 'or',
    'Tamil': 'ta',
    'Telugu': 'tl',
  };

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

      final downloadUrls = await Future.wait(
        pickedImages.entries.map((entry) async {
          String key = entry.key;
          Uint8List? file = entry.value;

          if (file != null) {
            String? url = await uploadImage(file: file, path: key);
            return {
              key: url
            };
          }

        }).toList()
      );

      for (var entries in downloadUrls) {

      }

      return true;

    } catch (e, s) {
      log('Error saving similar products banners images..!!\n$e\n$s');
      return false;
    }
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