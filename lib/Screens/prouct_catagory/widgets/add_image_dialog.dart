import 'dart:developer';
import 'dart:io'; // Add this import to work with File

import 'package:adminpannal/Screens/ksk_review/widgets/cutom_dropdown_button.dart';
import 'package:adminpannal/Screens/prouct_catagory/controller/prouduct_catagory_controller.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddImageDialog extends StatefulWidget {
  final String collectionId;

  const AddImageDialog({super.key, required this.collectionId});

  @override
  State<AddImageDialog> createState() => _AddImageDialogState();
}

class _AddImageDialogState extends State<AddImageDialog> {
  final ImagePicker _picker = ImagePicker();

  final Map<String, String> languageMap = {
    'Hindi': 'imageHi',
    'English': 'imageEn',
    'Malayalam': 'imageMal',
    'Tamil': 'imageTam',
  };

  final Map<String, String?> selectedImages = {
    'Hindi': null,
    'English': null,
    'Malayalam': null,
    'Tamil': null
  };

  String? selectedLanguage;
  bool isUploading = false; // Track the upload status

  Future<void> _pickImage(String language) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImages[language] = pickedFile.path;
      setState(() {});
      log('$language Image Selected: ${pickedFile.path}');
    } else {
      log('No image selected for $language.');
    }
  }

  Future<void> _uploadAndUpdateImage(String language) async {
    final pro = Provider.of<ProuductCatagoryController>(context, listen: false);
    final imagePath = selectedImages[language];
    if (imagePath != null) {
      setState(() {
        isUploading = true; // Start the uploading process
      });

      final storage = FirebaseStorage.instance;
      final file = XFile(imagePath);
      final fileName = '$language-${DateTime.now().millisecondsSinceEpoch}';
      final storageRef = storage
          .ref()
          .child('ProductCategoryImages/${widget.collectionId}/$fileName');

      try {
        final uploadTask = await storageRef.putData(await file.readAsBytes());
        final downloadURL = await uploadTask.ref.getDownloadURL();
        log('$language Image URL: $downloadURL');

        // Resolve the field name using the languageMap
        final fieldName = languageMap[language];

        // Ensure the fieldName is not null before updating Firestore
        if (fieldName != null) {
          // Update Firestore document with the new image URL
          final firestore = FirebaseFirestore.instance;
          await firestore
              .collection('/DynamicSection/Categories/categories_data')
              .doc(widget.collectionId)
              .update({
            fieldName: downloadURL, // Use the resolved field name
          });
          await pro.getCollectionData(widget.collectionId);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$language image updated successfully!')));
        } else {
          log('No field name found for language $language');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: const Text('Invalid language selected!')));
        }
      } catch (e) {
        log('Error uploading $language image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload $language image!')));
      } finally {
        setState(() {
          isUploading = false; // Stop the uploading process
        });
      }
    } else {
      log('No image selected for $language.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: boxColor,
      child: Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height / 1.5,
        width: MediaQuery.of(context).size.width / 3,
        child: Column(
          children: [
            // Show the selected image or placeholder (add icon)
            InkWell(
              onTap: () {
                _pickImage(selectedLanguage!);
              },
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 102, 84, 143),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: selectedImages[selectedLanguage] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: selectedImages[selectedLanguage] != null
                            ? selectedImages[selectedLanguage]!
                                    .startsWith('blob:')
                                ? Image.network(
                                    selectedImages[selectedLanguage]!,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                      Icons.image,
                                      color: Colors.white,
                                    ),
                                  )
                                : Image.network(
                                    selectedImages[
                                        selectedLanguage]!, // Assuming it's a URL
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                      Icons.image,
                                      color: Colors.white,
                                    ),
                                  )
                            : const Icon(
                                Icons.image,
                                color: Colors.white,
                              ),
                      )
                    : const Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.white,
                      ),
              ),
            ),
            const SizedBox(height: 20),
            CustomDropDownMenu(
              textColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 102, 84, 143),
              items: const ['Hindi', 'English', 'Malayalam', 'Tamil'],
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value;
                });
              },
            ),
            const SizedBox(height: 30),
            // Button to update the image
            ElevatedButton(
              onPressed: selectedLanguage != null &&
                      selectedImages[selectedLanguage] != null
                  ? () {
                      if (selectedLanguage != null) {
                        _uploadAndUpdateImage(selectedLanguage!);
                      }
                    }
                  : null, // Disable if no image is selected for the selected language
              child: isUploading
                  ? const CircularProgressIndicator() // Show loading indicator while uploading
                  : const Text('Update Image'),
            ),
          ],
        ),
      ),
    );
  }
}
