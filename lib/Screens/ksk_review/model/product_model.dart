import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? productId;
  String? productImage;
  String? productName;
  String? variantId;
  String? variantName;

  ProductModel({
    this.productId,
    this.productImage,
    this.productName,
    this.variantId,
    this.variantName,
  });

  // Factory method to create a ProductModel from Firestore document
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    return ProductModel(
      productId: data['productId'] ?? '', // Handle null values
      productImage: data['productImage'] ?? '', // Handle missing image
      productName: data['productName'] ?? 'Unknown Product', // Default name
      variantId: data['variantId'] ?? '', // Default empty variantId
      variantName: data['variantName'] ?? '', // Default empty variantName
    );
  }
}
