import 'dart:developer';
import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/category.dart';

class CategoryService {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<List<Category>>> fetchCategoryRows() async {
    List<List<Category>> categories = [];

    for (int i=1; i<=3; i++) {
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore.collection('Category Row').doc('category-row-$i').collection('categories').get();

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

      CollectionReference<Map<String, dynamic>> collectionReference = firestore.collection('Category Row').doc('category-row-$rowIndex').collection('categories');

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

}