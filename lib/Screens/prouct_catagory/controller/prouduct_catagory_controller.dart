import 'dart:developer';
import 'dart:io';

import 'package:adminpannal/Screens/Crops/cropCalenderScreen.dart';
import 'package:adminpannal/Screens/prouct_catagory/model/product_catagory_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProuductCatagoryController extends ChangeNotifier {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  List<ProductCatagoryModel> productCategories = [];
  bool isLoading = true;

  Future<void> fetchAllProductCategories() async {
    try {
      isLoading = true;
      QuerySnapshot snapshot = await firebaseFirestore
          .collection('/DynamicSection/Categories/categories_data')
          .get();

      final fetchedCategories = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ProductCatagoryModel.fromJson(data);
      }).toList();

      productCategories = fetchedCategories;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      debugPrint('Error fetching product categories: $e');
    }
  }

  final languages = ['Hindi', 'English', 'Malayalam', 'Tamil'];
  final Map<String, String?> selectedImages = {
    for (var language in ['Hindi', 'English', 'Malayalam', 'Tamil'])
      language: null,
  };

  Future<void> pickImage(BuildContext context, String language) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Use the blob URL directly for web
      selectedImages[language] = pickedFile.path;
      notifyListeners();
      log('$language Image Selected: ${pickedFile.path}');
    } else {
      log('No image selected for $language.');
    }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController collectionIdController = TextEditingController();
  TextEditingController colorHexController = TextEditingController();
  bool isLoadingAddcatagory = false;

  Future<void> addImagesAndSaveCategory(BuildContext context) async {
    try {
      isLoadingAddcatagory = true;
      notifyListeners();
      final firestore = FirebaseFirestore.instance;
      final storage = FirebaseStorage.instance;

      // Generate a unique collection ID
      final docRef = firestore
          .collection('/DynamicSection/Categories/categories_data')
          .doc();
      final collectionId = docRef.id;

      String title = titleController.text.trim();
      String colorHex = colorHexController.text.trim();

      // Validate inputs
      if (title.isEmpty || colorHex.isEmpty) {
        isLoadingAddcatagory = false;
        notifyListeners();

        throw Exception("Title and Color Hex must not be empty.");
      }

      // Map to store image download URLs
      final Map<String, String> imageUrls = {};

      // Loop through selected images and upload them
      for (var language in selectedImages.keys) {
        final imagePath = selectedImages[language];
        if (imagePath != null) {
          final xFile = XFile(imagePath);
          final fileName = '$language-${DateTime.now().millisecondsSinceEpoch}';
          final storageRef = storage
              .ref()
              .child('ProductCategoryImages/$collectionId/$fileName');

          // Upload the file as bytes
          final uploadTask =
              await storageRef.putData(await xFile.readAsBytes());
          final downloadURL = await uploadTask.ref.getDownloadURL();

          // Store the download URL
          imageUrls[language] = downloadURL;
        }
      }

      // Create the ProductCategoryModel
      final newCategory = ProductCatagoryModel(
        collectionID: collectionId,
        colorHex: colorHex,
        imageEn: imageUrls['English'] ?? '',
        imageHi: imageUrls['Hindi'] ?? '',
        imageMal: imageUrls['Malayalam'] ?? '',
        imageTam: imageUrls['Tamil'] ?? '',
        title: title,
      );

      // Save the category to Firestore
      await docRef.set(newCategory.toJson());
      await fetchAllProductCategories();
      isLoadingAddcatagory = false;
      notifyListeners();

      log('Category added successfully to Firestore with ID: $collectionId');
      Navigator.pop(context);
    } catch (e) {
      isLoadingAddcatagory = false;
      notifyListeners();
      log('Error uploading images or saving category: $e');
    }
  }

  Future<void> addImageToCategory(
      String collectionId, String language, String imagePath) async {
    try {
      // Generate a unique filename
      final fileName = '$language-${DateTime.now().millisecondsSinceEpoch}';

      // Create a reference to Firebase Storage
      final storageRef = firebaseStorage
          .ref()
          .child('ProductCategoryImages/$collectionId/$fileName');

      // Upload the file
      final uploadTask = await storageRef.putFile(File(imagePath));

      // Get the download URL
      final downloadURL = await uploadTask.ref.getDownloadURL();

      // Update the Firestore document
      await firebaseFirestore
          .collection('/DynamicSection/Categories/categories_data')
          .doc(collectionId)
          .update({language: downloadURL});

      log('Image added successfully to Firestore and Storage.');
    } catch (e) {
      log('Error adding image: $e');
    }
  }

  ProductCatagoryModel? productCatagoryModel;
  bool isLoadingCatagory = false;
  String? errorMessage;

  // Fetch collection data from Firestore
  Future<void> getCollectionData(String collectionId) async {
    try {
      isLoadingCatagory = true;
      errorMessage = null; // Reset error before making a new request
      notifyListeners();

      final firestore = FirebaseFirestore.instance;
      final categoryDoc = await firestore
          .collection('/DynamicSection/Categories/categories_data')
          .doc(collectionId)
          .get();

      if (categoryDoc.exists) {
        final data = categoryDoc.data() as Map<String, dynamic>;
        productCatagoryModel = ProductCatagoryModel.fromJson(data);
        isLoadingCatagory = false;
        notifyListeners();
      } else {
        isLoadingCatagory = false;
        errorMessage = 'Document not found';
        notifyListeners();
      }
    } catch (e) {
      isLoadingCatagory = false;
      errorMessage = 'Error retrieving collection data: $e';
      notifyListeners();
    }
  }

  // Future<void> deleteImageFromCategory(
  //     String collectionId, String language) async {
  //   try {
  //     log('Deleting the $language from $collectionId');
  //     final storage = FirebaseStorage.instance;
  //     final firestore = FirebaseFirestore.instance;

  //     // Construct the path to the image in Firebase Storage
  //     final storageRef =
  //         storage.ref().child('ProductCategoryImages/$collectionId/$language');

  //     // Try to delete the image from Firebase Storage
  //     await storageRef.delete();
  //     log('Image deleted successfully from Firebase Storage.');

  //     // Now update Firestore to remove the image URL or set it to null/empty
  //     await firestore
  //         .collection('/DynamicSection/Categories/categories_data')
  //         .doc(collectionId)
  //         .update({
  //       language: FieldValue
  //           .delete(), // This will remove the image URL from Firestore
  //     });

  //     log('Image URL removed from Firestore.');
  //   } catch (e) {
  //     log('Error deleting image: $e');
  //     // Handle the case where the file does not exist or there's another error
  //     if (e is FirebaseException && e.code == 'object-not-found') {
  //       log('The image to delete does not exist in Firebase Storage.');
  //     } else {
  //       log('Unexpected error: $e');
  //     }
  //   }
  // }

  final Map<String, String> languageFieldMapping = {
    'Hindi': 'imageHi',
    'English': 'imageEn',
    'Malayalam': 'imageMal',
    'Tamil': 'imageTam',
  };
  Future<void> deleteImageFromCategory(
      String collectionId, String language, String imageUrl) async {
    try {
      // Map display language to Firestore field name
      final fieldName = languageFieldMapping[language];

      if (fieldName == null) {
        log('Invalid language: $language');
        return;
      }

      // Step 1: Delete the image from Firebase Storage
      if (imageUrl.isNotEmpty) {
        final ref = FirebaseStorage.instance.refFromURL(imageUrl);
        await ref.delete();
        log('Image deleted successfully from Firebase Storage: $imageUrl');
      }

      // Step 2: Set the image reference in Firestore to an empty string
      await firebaseFirestore
          .collection('/DynamicSection/Categories/categories_data')
          .doc(collectionId)
          .update({
        fieldName: "", // Update the mapped field
      });

      log('Image reference set to an empty string in Firestore for field: $fieldName');
      getCollectionData(collectionId);
    } catch (e) {
      log('Error setting image field to empty string in Firestore: $e');

      // Additional debugging
      if (e is FirebaseException) {
        if (e.code == 'not-found') {
          log('The document does not exist in Firestore.');
        } else {
          log('FirebaseException: ${e.message}');
        }
      }
    }
  }

  Future<void> updateCategoryDetails(
      String defaultCollectionId,
      String collectionId,
      String newTitle,
      String newColorHex,
      BuildContext context) async {
    try {
      log("Default id : $defaultCollectionId , Update id : $collectionId");
      final firestore = FirebaseFirestore.instance;

      // Validate inputs
      if (newTitle.isEmpty || newColorHex.isEmpty) {
        throw Exception("Title and Color Hex must not be empty.");
      }

      // Fetch the document from Firestore using the collectionId
      final docRef = firestore
          .collection('/DynamicSection/Categories/categories_data')
          .doc(defaultCollectionId);

      // Get the existing document data
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        throw Exception("Document with the given collectionId does not exist.");
      }

      // Update the fields in the document
      await docRef.update({
        'title': newTitle, // Update the title field
        'colorHex': newColorHex, // Update the colorHex field
        'collectionID': collectionId,
      });

      await getCollectionData(collectionId);

      log('Category details updated successfully in Firestore.');
      Navigator.of(context).pop();
      // getCollectionData(collectionId);
    } catch (e) {
      log('Error updating category details: $e');
      // Handle any potential errors during the update operation
    }
  }

  Future<void> deleteCategory(String collectionId) async {
    try {
      // Delete category document from Firestore
      await firebaseFirestore
          .collection('/DynamicSection/Categories/categories_data')
          .doc(collectionId)
          .delete();

      log('Category document deleted successfully from Firestore.');

      // Delete the images from Firebase Storage
      final storageRef =
          firebaseStorage.ref().child('ProductCategoryImages/$collectionId');

      // List all items in the category folder
      final listResult = await storageRef.listAll();
      for (var item in listResult.items) {
        // Delete each item
        await item.delete();
        log('Deleted image: ${item.fullPath}');
      }

      log('All images deleted successfully from Firebase Storage.');
      await fetchAllProductCategories(); // Refresh categories after deletion
    } catch (e) {
      log('Error deleting category: $e');
      // Handle specific error cases (e.g., document not found, storage errors)
      if (e is FirebaseException) {
        if (e.code == 'not-found') {
          log('Category or images not found.');
        } else {
          log('Unexpected Firebase error: ${e.message}');
        }
      } else {
        log('Unexpected error: $e');
      }
    }
  }
}
