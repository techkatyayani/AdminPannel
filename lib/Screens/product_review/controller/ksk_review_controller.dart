import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/product_model.dart';
import '../model/product_review_model.dart';

class KskReviewController extends ChangeNotifier {

  final String adminImageUrl = 'https://firebasestorage.googleapis.com/v0/b/krishisevakendra-8430a.appspot.com/o/review%2FDefault%20User%20Image.png?alt=media&token=c7f45e8b-d729-4638-92eb-856f1449b808';

  final ImagePicker imagePicker = ImagePicker();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  List<ProductModel> allProducts = [];

  List<ProductReviewModel> allReviews = [];

  List<ProductReviewModel> allFilteredReviews = [];

  bool isLoadingReviews = true;
  bool isLoadingProducts = true;
  bool isSavingReview = false;


  // Create Review Data

  TextEditingController userNameController = TextEditingController();
  TextEditingController reviewController = TextEditingController();

  double _ratings = 3.0;
  double get ratings => _ratings;
  void setRatings(double value) {
    _ratings = value;
    notifyListeners();
  }

  final List<Uint8List> _reviewImages = [];
  List<Uint8List> get reviewImages => _reviewImages;
  Future<void> pickFile() async {
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      Uint8List image = await file.readAsBytes();
      addReviewImage(image);
    }
  }

  void addReviewImage(Uint8List image) {
    if (_reviewImages.length < 3) {
      _reviewImages.add(image);
      notifyListeners();
    }
  }

  void removeReviewImage(int index) {
    if (index < _reviewImages.length) {
      _reviewImages.removeAt(index);
      notifyListeners();
    }
  }

  void resetReviewDialog() {
    _ratings = 3.0;
    _reviewImages.clear();
    userNameController.clear();
    reviewController.clear();

    notifyListeners();
  }

  Future<void> saveReview({
    required String productId,
  }) async {
    try {
      List<String> uploadedImageUrls = [];

      if (_reviewImages.isEmpty) {
        log('No images found to upload');
      }
      else {
        for (var image in _reviewImages) {
          try {
            String fileName = DateTime.now().millisecondsSinceEpoch.toString();

            final storagePath = 'review/$fileName';

            Reference storageRef = firebaseStorage.ref().child(storagePath);

            final uploadTask = await storageRef.putData(image);

            log('Getting download URL for uploaded file...');
            String mediaUrl = await uploadTask.ref.getDownloadURL();
            log('Media URL: $mediaUrl');

            uploadedImageUrls.add(mediaUrl);
          } catch (e) {
            log('Error uploading photo: $e');
          }
        }
      }


      log('Upload URLs : $uploadedImageUrls');

      final doc = await firebaseFirestore.collection('Product Reviews').doc(productId).collection('Reviews').add({});

      final id = doc.id;

      String userId = 'Katyayani Organics';

      log('Saving Product Review in doc...');

      Map<String, dynamic> data = {
        'id': id,
        'contact': userId,
        'userId': userId,
        'username': userNameController.text.trim(),
        'userProfileImage': adminImageUrl,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'review': reviewController.text.trim(),
        'rating': ratings.toString(),
        'isApproved': true,
        'reviewImage': uploadedImageUrls,
      };

      log('Saving Product Review Data :- $data');

      await doc.set(data);

      log('Product Review Saved..!!');

      resetReviewDialog();

      ProductReviewModel productReviewModel = ProductReviewModel(
        reviewId: data['id'],
        productId: productId,
        isApproved: true,
        reviewImage: uploadedImageUrls,
        userId: data['userId'],
        userName: data['username'],
        userProfileImage: data['userProfileImage'],
        userRating: data['rating'],
        userReview: data['review'],
        timestamp: data['timestamp'],
      );

      allReviews.add(productReviewModel);

      notifyListeners();

    } catch (e) {
      log('Error saving product review: $e');
    }
  }

  Future<void> getAllReviewForUser(String productId) async {
    try {
      isLoadingReviews = true;
      notifyListeners();

      final reviewCollection = FirebaseFirestore.instance
          .collection('Product Reviews')
          .doc(productId)
          .collection('Reviews')
          .orderBy('timestamp', descending: true);

      final querySnapshot = await reviewCollection.get();

      List<ProductReviewModel> reviews = querySnapshot.docs
          .map((doc) {
            Map<String, dynamic> data = doc.data();
            data['productId'] = productId;
            return ProductReviewModel.fromJson(data);
          })
          .toList();

      log("Fetched ${reviews.length} reviews for productId: $productId");

      allReviews = reviews;

      allFilteredReviews = allReviews;

      isLoadingReviews = false;

      notifyListeners();
    } catch (e) {
      isLoadingReviews = false;
      notifyListeners();
      log("Failed to fetch reviews: $e");
    }
  }

  Future<void> fetchAllProducts() async {
    try {
      // Query the productReviews collection to get all products
      final productSnapshot =
          await FirebaseFirestore.instance.collection('Product Reviews').get();

      if (productSnapshot.docs.isEmpty) {
        log("No products found in 'Product Reviews'.");
        allProducts = [];
        isLoadingProducts = false;
        notifyListeners();
        return;
      }

      log("Found ${productSnapshot.docs.length} products.");

      // Fetch product data
      List<ProductModel> fetchedProducts = [];

      for (var productDoc in productSnapshot.docs) {
        try {
          // Convert the product document to a ProductModel
          ProductModel productModel = ProductModel(
            productId: productDoc['productId'], // Firestore field
            productImage: productDoc['productImage'], // Firestore field
            productName: productDoc['productName'], // Firestore field
            variantId: productDoc['variantId'], // Firestore field
            variantName: productDoc['variantName'], // Firestore field
          );

          fetchedProducts.add(productModel);
          log("Fetched product: ${productModel.productName}");
        } catch (e) {
          log("Failed to fetch product data for ${productDoc.id}: $e");
        }
      }

      // Update the list of all fetched products
      allProducts = fetchedProducts;

      log("Total products fetched: ${fetchedProducts.length}");

      isLoadingProducts = false;
      notifyListeners();
    } catch (e) {
      isLoadingProducts = false;
      notifyListeners();
      log("Failed to fetch products: $e");
    }
  }

  Future<void> filterReviews(String filterName) async {
    try {
      if (filterName == 'Approved') {
        allFilteredReviews =
            allReviews.where((review) => review.isApproved == true).toList();
      } else if (filterName == 'Unapproved') {
        allFilteredReviews =
            allReviews.where((review) => review.isApproved == false).toList();
      } else if (filterName == 'All') {
        allFilteredReviews = allReviews.toList();
      } else if (filterName == 'Top Rated') {
        allFilteredReviews.sort((a, b) => double.parse(b.userRating ?? '0')
            .compareTo(double.parse(a.userRating ?? '0')));
      } else if (filterName == 'Lowest Rated') {
        allFilteredReviews.sort((a, b) => double.parse(a.userRating ?? '0')
            .compareTo(double.parse(b.userRating ?? '0')));
      } else if (filterName == 'Verified Users') {
        allFilteredReviews = allReviews.where((review) => review.userId != 'Katyayani Organics').toList();
      } else if (filterName == 'Admins') {
        allFilteredReviews = allReviews.where((review) => review.userId == 'Katyayani Organics').toList();
      }

      notifyListeners();
    } catch (e) {
      log("Error in filtering reviews: $e");
    }
  }

  Future<void> toggleReviewApproval(String reviewId, String productId) async {
    try {
      if (reviewId.isEmpty || productId.isEmpty) {
        log('Review Id or Product Id is Empty');
        return;
      }
      final reviewDocRef = FirebaseFirestore.instance
          .collection('Product Reviews')
          .doc(productId)
          .collection('Reviews')
          .doc(reviewId);

      log(reviewDocRef.path);

      final reviewDoc = await reviewDocRef.get();

      if (reviewDoc.exists) {
        // Get the current 'isApproved' status and toggle it
        bool currentApprovalStatus = reviewDoc['isApproved'] ?? false;
        bool newApprovalStatus = !currentApprovalStatus;

        // Update the 'isApproved' field in Firestore
        await reviewDocRef.update({
          'isApproved': newApprovalStatus,
        });

        // Update the local list of reviews
        for (var review in allFilteredReviews) {
          if (review.reviewId == reviewId) {
            review.isApproved = newApprovalStatus;
            break; // Exit the loop once the review is found
          }
        }

        log("Review approval status for $reviewId updated to $newApprovalStatus");

        notifyListeners();
      }




    } catch (e) {
      log("Error toggling review approval: $e");
    }
  }

  Future<bool> deleteReview(String reviewId, String productId) async {
    try {
      if (reviewId.isEmpty || productId.isEmpty) {
        log('Review Id or Product Id is Empty');
        return false;
      }
      final reviewDocRef = FirebaseFirestore.instance
          .collection('Product Reviews')
          .doc(productId)
          .collection('Reviews')
          .doc(reviewId);

      final reviewDoc = await reviewDocRef.get();

      if (reviewDoc.exists) {

        await reviewDocRef.delete();

        allFilteredReviews.removeWhere((review) => review.reviewId.toString() == reviewId);

        log("Review Deleted :)");

        notifyListeners();

        return true;
      }

      return false;
    } catch (e) {
      log("Error toggling review approval: $e");
      return false;
    }
  }
}
