import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DiseaseController extends ChangeNotifier {
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController symptomController = TextEditingController();
  TextEditingController symptomDiscriptionController = TextEditingController();

  // Future<void> updateSyptom({
  //   required String cropId,
  //   required String diseaseId,
  //   required String symptomName,
  //   required List<String> symptomNewValue,
  // }) async {
  //   try {
  //     FirebaseFirestore.instance
  //         .collection('product')
  //         .doc(cropId)
  //         .collection('Disease')
  //         .doc(diseaseId)
  //         .collection('Symptoms')
  //         .doc()
  //         .update(
  //       {
  //         symptomName: symptomNewValue,
  //       },
  //     );
  //   } catch (e) {
  //     log("Could not update $symptomName : $symptomNewValue");
  //   }
  // }

  Future<void> updateSyptom({
    required String cropId,
    required String diseaseId,
    required String symptomName,
    required List<dynamic> symptomNewValue,
  }) async {
    try {
      // Get the Symptoms collection reference
      var symptomsCollection = FirebaseFirestore.instance
          .collection('product')
          .doc(cropId)
          .collection('Disease')
          .doc(diseaseId)
          .collection('Symptoms');
      var snapshot = await symptomsCollection.get();
      if (snapshot.docs.isEmpty) {
        log("No symptoms document found.");
        return;
      }
      if (symptomDiscriptionController.text.isEmpty) {
        log("No Discription Provided");
        return;
      } else {
        symptomNewValue.add(symptomDiscriptionController.text.trim());
      }
      var symptomDocId = snapshot.docs.first.id;
      var symptomDocRef = symptomsCollection.doc(symptomDocId);
      await symptomDocRef.update({
        symptomName: symptomNewValue,
      });
      symptomDiscriptionController.clear();

      log("Successfully updated $symptomName for diseaseId $diseaseId and cropId $cropId");
    } catch (e) {
      log("Could not update $symptomName: $e");
    }
  }

  Future<void> deleteSymptom({
    required String cropId,
    required String diseaseId,
    required String symptomId,
    required String symptomName,
    required String symptomValue,
    required List<dynamic> symptomNewValue,
  }) async {
    try {
      // Get the Symptoms collection reference
      var symptomsCollection = FirebaseFirestore.instance
          .collection('product')
          .doc(cropId)
          .collection('Disease')
          .doc(diseaseId)
          .collection('Symptoms');
      var symptomDocRef = symptomsCollection.doc(symptomId);
      symptomNewValue.remove(symptomValue);
      await symptomDocRef.update({symptomName: symptomNewValue});
      notifyListeners();
      log("Symptom $symptomName deleted successfully for symptomId $symptomId");
    } catch (e) {
      log("Error deleting symptom: $e");
    }
  }

  Future<void> editSymptom({
    required String cropId,
    required String diseaseId,
    required String symptomId,
    required String symptomName,
    required String oldSymptomValue, // the value to be replaced
    required String newSymptomValue, // the new value
  }) async {
    try {
      // Get the Symptoms collection reference
      var symptomsCollection = FirebaseFirestore.instance
          .collection('product')
          .doc(cropId)
          .collection('Disease')
          .doc(diseaseId)
          .collection('Symptoms');

      var symptomDocRef = symptomsCollection.doc(symptomId);

      // Retrieve the current symptom values list
      var snapshot = await symptomDocRef.get();
      if (snapshot.exists) {
        var symptomData = snapshot.data() as Map<String, dynamic>;
        var symptomValues = List<String>.from(symptomData[symptomName] ?? []);

        // Check if the old value exists and replace it
        if (symptomValues.contains(oldSymptomValue)) {
          // Replace the old value with the new value
          int index = symptomValues.indexOf(oldSymptomValue);
          symptomValues[index] = newSymptomValue;

          // Update the document with the modified list
          await symptomDocRef.update({symptomName: symptomValues});
          log("Symptom $symptomName updated successfully for symptomId $symptomId");
        } else {
          log("Error: old symptom value not found.");
        }
      } else {
        log("Error: Symptom document not found.");
      }

      notifyListeners();
    } catch (e) {
      log("Error updating symptom: $e");
    }
  }

  Future<void> updateProduct(String cropId, String documentId,
      List<int>? imageBytes, BuildContext context) async {
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

  Future<void> showUpdateDialog(
    String documentId,
    String currentName,
    String currentImageUrl,
    String currentId,
    String cropId,
    List<int>? imageBytes,
    BuildContext context,
  ) async {
    List<int>? bytes;

    nameController.text = currentName;
    imageUrlController.text = currentImageUrl;
    idController.text = currentId;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: AlertDialog(
                title: const Text('Update Disease'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextField(
                        controller: idController,
                        decoration: const InputDecoration(labelText: 'Id'),
                      ),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.image,
                            allowMultiple: false,
                          );

                          if (result != null) {
                            setState(() {
                              bytes = result.files.single.bytes;
                            });
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: bytes == null
                              ? Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.network(
                                        currentImageUrl,
                                      ),
                                      Container(
                                        height: double.infinity,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.black.withOpacity(.4),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Tap to select image",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Image.memory(
                                  Uint8List.fromList(bytes!),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Update'),
                    onPressed: () {
                      // updateProduct(
                      //   documentId,
                      //   bytes,

                      // );
                      updateProduct(
                        cropId,
                        documentId,
                        imageBytes,
                        context,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
