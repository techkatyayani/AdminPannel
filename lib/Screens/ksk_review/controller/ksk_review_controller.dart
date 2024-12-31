import 'dart:developer';
import 'package:adminpannal/Screens/ksk_review/model/product_review_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class KskReviewController extends ChangeNotifier {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  List<ProductReviewModel> allReviews = [];
  List<String> allProducts = [];
  List<ProductReviewModel> allapprovedReviews = [];
  List<ProductReviewModel> allUnApprovedReviews = [];

  bool isLoadingReviews = true;
  bool isLoadingProducts = true;

  // Future<void> fetchAllReviewsFromAllProducts(bool showApproved) async {
  //   try {
  //     isLoadingReviews = true;
  //     notifyListeners();

  //     // Query the productReviews collection to get all products
  //     final productSnapshot =
  //         await FirebaseFirestore.instance.collection('productReviews').get();

  //     if (productSnapshot.docs.isEmpty) {
  //       log("No products found in 'productReviews'.");
  //       allReviews = [];
  //       isLoadingReviews = false;
  //       notifyListeners();
  //       return;
  //     }

  //     log("Found ${productSnapshot.docs.length} products.");
  //     List<ProductReviewModel> allFetchedReviews = [];

  //     for (var productDoc in productSnapshot.docs) {
  //       try {
  //         final reviewsSnapshot =
  //             await productDoc.reference.collection('reviews').get();

  //         if (reviewsSnapshot.docs.isNotEmpty) {
  //           log("Product ${productDoc.id} has ${reviewsSnapshot.docs.length} reviews.");
  //           List<ProductReviewModel> productReviews = reviewsSnapshot.docs
  //               .map((doc) => ProductReviewModel.fromJson(doc.data()))
  //               .toList();

  //           allFetchedReviews.addAll(productReviews);
  //         }
  //       } catch (e) {
  //         log("Failed to fetch reviews for product ${productDoc.id}: $e");
  //       }
  //     }

  //     // Filter reviews based on approval status
  //     allReviews = showApproved
  //         ? allFetchedReviews.where((review) => review.isApproved!).toList()
  //         : allFetchedReviews.where((review) => !review.isApproved!).toList();

  //     log("Total reviews fetched: ${allFetchedReviews.length}");
  //     log("Filtered reviews to display: ${allReviews.length}");

  //     isLoadingReviews = false;
  //     notifyListeners();
  //   } catch (e) {
  //     isLoadingReviews = false;
  //     notifyListeners();
  //     log("Failed to fetch all reviews: $e");
  //   }
  // }

  Future<void> getAllReviewForUser(String productId) async {
    try {
      isLoadingReviews = true;
      notifyListeners();

      final reviewCollection = FirebaseFirestore.instance
          .collection('productReviews')
          .doc(productId)
          .collection('reviews');

      final querySnapshot = await reviewCollection.get();
      List<ProductReviewModel> reviews = querySnapshot.docs
          .map((doc) => ProductReviewModel.fromJson(doc.data()))
          .toList();

      log("Fetched ${reviews.length} reviews for productId: $productId");
      allReviews = reviews;
      allapprovedReviews =
          reviews.where((review) => review.isApproved!).toList();
      isLoadingReviews = false;
      notifyListeners();
    } catch (e) {
      isLoadingReviews = false;
      notifyListeners();
      log("Failed to fetch reviews: $e");
    }
  }

  Future<void> fetchAllReviewsFromAllProducts(bool showApproved) async {
    try {
      isLoadingReviews = true;
      notifyListeners();

      // Query the productReviews collection to get all products
      final productSnapshot =
          await FirebaseFirestore.instance.collection('productReviews').get();

      if (productSnapshot.docs.isEmpty) {
        log("No products found in 'productReviews'.");
        allReviews = [];
        isLoadingReviews = false;
        notifyListeners();
        return;
      }

      log("Found ${productSnapshot.docs.length} products.");

      // Fetch reviews for all products
      List<ProductReviewModel> allFetchedReviews = [];

      for (var productDoc in productSnapshot.docs) {
        try {
          // Fetch the 'reviews' subcollection for this product
          final reviewsSnapshot =
              await productDoc.reference.collection('reviews').get();

          if (reviewsSnapshot.docs.isNotEmpty) {
            log("Product ${productDoc.id} has ${reviewsSnapshot.docs.length} reviews.");

            // Convert review documents to ProductReviewModel objects
            List<ProductReviewModel> productReviews = reviewsSnapshot.docs
                .map((doc) => ProductReviewModel.fromJson(doc.data()))
                .toList();

            allFetchedReviews.addAll(productReviews);
          }
        } catch (e) {
          log("Failed to fetch reviews for product ${productDoc.id}: $e");
        }
      }

      // Filter reviews based on approval status
      allReviews = showApproved
          ? allFetchedReviews.where((review) => review.isApproved!).toList()
          : allFetchedReviews.where((review) => !review.isApproved!).toList();

      log("Total reviews fetched: ${allFetchedReviews.length}");
      log("Filtered reviews to display: ${allReviews.length}");

      isLoadingReviews = false;
      notifyListeners();
    } catch (e) {
      isLoadingReviews = false;
      notifyListeners();
      log("Failed to fetch all reviews: $e");
    }
  }

  Future<void> fetchAllProducts() async {
    try {
      // Query the productReviews collection to get all products
      final productSnapshot =
          await FirebaseFirestore.instance.collection('productReviews').get();

      if (productSnapshot.docs.isEmpty) {
        log("No products found in 'productReviews'.");
        allProducts = [];
        isLoadingProducts = false;
        notifyListeners();
        return;
      }

      log("Found ${productSnapshot.docs.length} products.");

      // Fetch product data
      List<String> fetchedProducts = [];

      for (var productDoc in productSnapshot.docs) {
        try {
          // Convert the product document to a ProductModel
          String productModel = productDoc.data.toString();

          fetchedProducts.add(productModel);
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
}
