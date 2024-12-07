import 'dart:developer';

import 'package:adminpannal/Utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CropProvider with ChangeNotifier {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final Map<int, TextEditingController> _keys = {};
  Map<int, TextEditingController> get keys => _keys;

  final Map<int, TextEditingController> _values = {};
  Map<int, TextEditingController> get values => _values;

  void addField() {

    int index = keys.entries.length;

    _keys[index] = TextEditingController();
    _values[index] = TextEditingController();

    notifyListeners();
  }
  void removeFiled(int index) {

    _keys.remove(index);
    _values.remove(index);

    notifyListeners();
  }

  Future<Map<String, dynamic>> fetchCropDetails(String cropId) async {
    DocumentSnapshot<Map<String, dynamic>> doc = await firestore.collection('product').doc(cropId).get();
    Map<String, dynamic> data = doc.data()!;
    return data;
  }

  Future<void> saveCropDetails(BuildContext context, String cropId) async {

    Utils.showLoadingBox(context: context, title: 'Saving Details..');

    try {
      Map<String, dynamic> data = {};

      final allKeys = keys.entries.toList();
      final allValues = values.entries.toList();

      for (int i=0; i<keys.length; i++) {
        String key = allKeys[i].value.text.trim();
        String value = allValues[i].value.text.trim();
        if (!data.containsKey(key)) {
          data[key] = value;
        }
      }

      DocumentSnapshot<Map<String, dynamic>> doc = await firestore.collection('product').doc(cropId).get();
      Map<String, dynamic> oldData = doc.data()!;

      log('Old Data - $oldData');
      log('New Data - $data');

      data.addEntries(oldData.entries);

      log('Final data - $data');

      await firestore.collection('product').doc(cropId).set(data);

      keys.clear();
      values.clear();
      notifyListeners();

      Navigator.pop(context);

      Utils.showSnackBar(context: context, message: 'Crop Details Saved :)');
    } catch (e) {
      Navigator.pop(context);
      log("Error saving crop details - $e");
      Utils.showSnackBar(context: context, message: 'Unable to save crop details :(');
    }
  }
}