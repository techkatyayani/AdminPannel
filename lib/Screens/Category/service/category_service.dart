import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/category.dart';

class CategoryService {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<List<List<Category>>> fetchCategoryRows() async {
    List<List<Category>> categories = [];

    for (int i = 1; i <= 3; i++) {
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore.collection(
          'Category Row').doc('category-row-$i').collection('categories').get();

      List<Category> category = [];

      for (var doc in snapshot.docs) {
        if (doc.exists) {
          Map<String, dynamic> data = doc.data();
          category.add(Category.fromJson(data));
        }
      }

      category.sort((a, b) => a.position.compareTo(b.position));

      categories.add(category);
    }

    return categories;
  }

  Future<bool> saveCategory({
    required int rowIndex,
    required List<Category> categories
  }) async {
    try {
      log('Saving Category to doc category-row-$rowIndex...');

      CollectionReference<Map<String, dynamic>> collectionReference = firestore
          .collection('Category Row').doc('category-row-$rowIndex').collection(
          'categories');

      for (var category in categories) {
        log('Setting data ${category.toJson()} in Doc id ${category.docId}');
        String? id = category.docId != '' ? category.docId : null;
        await collectionReference.doc(id).set(category.toJson());
        log('Saved :)');
      }

      return true;
    } catch (e, stace) {
      log('Error while saving category - $e\n$stace');
      return false;
    }
  }

  Future<Category?> addCategory({
    required String categoryName,
    required String collectionId,
    required String position,
    required String color1,
    required String color2,
    required dynamic file,
    required int rowIndex,
  }) async {
    try {
      log('Adding Category to doc category-row-$rowIndex...');

      CollectionReference<Map<String, dynamic>> collectionReference = firestore.collection('Category Row').doc('category-row-$rowIndex').collection('categories');

      String? downloadUrl = await uploadImage(file);

      if (downloadUrl == null) {
        log('Download Url is null..!!');
        return null;
      }

      DocumentReference<Map<String, dynamic>> documentReference = collectionReference.doc();

      String docId = documentReference.id;

      Category category = Category(
        collectionId: collectionId,
        categoryName: categoryName,
        categoryImage: downloadUrl,
        categoryColor1: color1,
        categoryColor2: color2,
        position: position,
        docId: docId
      );

      await documentReference.set(category.toJson());

      return category;

    } catch (e, stace) {
      log('Error adding category - $e\n$stace');
      return null;
    }
  }

  Future<String?> uploadImage(final mediaFile) async {
    try {
      final fileName = DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();
      final storagePath = 'dynamic_category_images/$fileName';
      Reference storageRef = storage.ref().child(storagePath);

      log('Uploading media file to Firebase Storage...');
      final uploadTask = mediaFile is File
          ? await storageRef.putFile(mediaFile)
          : await storageRef.putData(mediaFile);

      log('Getting download URL for uploaded file...');
      final mediaUrl = await uploadTask.ref.getDownloadURL();
      log('Media URL: $mediaUrl');

      return mediaUrl;
    } catch (e, stace) {
      log('Error uploading file to firebase - $e\n$stace');
      return null;
    }
  }

}