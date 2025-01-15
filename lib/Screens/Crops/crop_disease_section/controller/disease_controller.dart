import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DiseaseController extends ChangeNotifier {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController imageUrlController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();

  TextEditingController symptomDescriptionController = TextEditingController();

  Future<bool> addSymptom({
    required String cropId,
    required String diseaseId,
    required String symptomId,
    required String symptomName,
    required List<dynamic> symptomNewValue,
  }) async {
    try {

      final snapshot = firestore
          .collection('product')
          .doc(cropId)
          .collection('Disease')
          .doc(diseaseId)
          .collection('Symptoms')
          .doc(symptomId);

      symptomNewValue.add(symptomDescriptionController.text.trim());

      await snapshot.update({
        symptomName: symptomNewValue
      });

      symptomDescriptionController.clear();

      log("Successfully updated $symptomName for diseaseId $diseaseId and cropId $cropId");

      return true;

    } catch (e) {
      log("Could not update $symptomName: $e");
      return false;
    }
  }

  Future<bool> editSymptom({
    required String cropId,
    required String diseaseId,
    required String symptomId,
    required String symptomName,
    required String oldSymptomValue,
    required String newSymptomValue,
  }) async {
    try {

      var symptomsCollection = firestore
          .collection('product')
          .doc(cropId)
          .collection('Disease')
          .doc(diseaseId)
          .collection('Symptoms');

      var symptomDocRef = symptomsCollection.doc(symptomId);

      var snapshot = await symptomDocRef.get();

      if (snapshot.exists) {
        var symptomData = snapshot.data() as Map<String, dynamic>;

        var symptomValues = List<String>.from(symptomData[symptomName] ?? []);

        if (symptomValues.contains(oldSymptomValue)) {
          int index = symptomValues.indexOf(oldSymptomValue);
          symptomValues[index] = newSymptomValue;

          await symptomDocRef.update({symptomName: symptomValues});
          symptomDescriptionController.clear();

          log("Symptom $symptomName updated successfully for symptomId $symptomId");

          return true;
        } else {
          log("Error: old symptom value not found.");
          return false;
        }
      } else {
        log("Error: Symptom document not found.");
        return false;
      }

    } catch (e) {
      log("Error updating symptom: $e");
      return false;
    }
  }

  Future<bool> deleteSymptom({
    required String cropId,
    required String diseaseId,
    required String symptomId,
    required String symptomName,
    required String symptomValue,
    required List<dynamic> symptomNewValue,
  }) async {
    try {

      var symptomsCollection = FirebaseFirestore.instance
          .collection('product')
          .doc(cropId)
          .collection('Disease')
          .doc(diseaseId)
          .collection('Symptoms');

      var symptomDocRef = symptomsCollection.doc(symptomId);

      symptomNewValue.remove(symptomValue);

      await symptomDocRef.update({symptomName: symptomNewValue});

      log("Symptom $symptomName deleted successfully for symptomId $symptomId");

      return true;
    } catch (e) {
      log("Error deleting symptom: $e");
      return false;
    }
  }

  Future<void> updateProduct(String cropId, String documentId, List<int>? imageBytes, BuildContext context) async {
    String imageUrl = '';

    Navigator.of(context).pop();

    if (imageBytes != null) {
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('product_images')
          .child('$documentId.jpg');
      Uint8List uint8List = Uint8List.fromList(imageBytes);
      UploadTask uploadTask = ref.putData(uint8List);
      TaskSnapshot snapshot = await uploadTask;
      await uploadTask.whenComplete(() async {
        imageUrl = await snapshot.ref.getDownloadURL();
        imageUrlController.text = imageUrl;
      });
    }

    await FirebaseFirestore.instance
        .collection('product')
        .doc(cropId)
        .collection('Disease')
        .doc(documentId)
        .update({
      'Image': imageUrl.isNotEmpty ? imageUrl : imageUrlController.text,
      'Name': nameController.text,
      'id': idController.text
    });
  }
}
