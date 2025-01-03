import 'dart:developer';
import 'package:adminpannal/Screens/ksk_review/model/product_model.dart';
import 'package:adminpannal/Screens/ksk_review/model/product_review_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class KskReviewController extends ChangeNotifier {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  List<ProductModel> allProducts = [];

  List<ProductReviewModel> allReviews = [];

  List<ProductReviewModel> allFilteredReviews = [];

  bool isLoadingReviews = true;
  bool isLoadingProducts = true;

  Future<void> getAllReviewForUser(String productId) async {
    try {
      isLoadingReviews = true;
      notifyListeners();

      final reviewCollection = FirebaseFirestore.instance
          .collection('Product Reviews')
          .doc(productId)
          .collection('Reviews');

      final querySnapshot = await reviewCollection.get();
      List<ProductReviewModel> reviews = querySnapshot.docs
          .map((doc) => ProductReviewModel.fromJson(doc.data()))
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

      final reviewDoc = await reviewDocRef.get();

      if (!reviewDoc.exists) {
        log("Review with ID $reviewId not found.");
        return;
      }

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

      notifyListeners();

      log("Review approval status for $reviewId updated to $newApprovalStatus");
    } catch (e) {
      log("Error toggling review approval: $e");
    }
  }
}
