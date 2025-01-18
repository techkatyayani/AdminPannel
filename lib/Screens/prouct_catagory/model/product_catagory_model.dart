import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ProductCatagoryModel {

  final String id;
  final String title;
  final Color color;
  final String collectionId;
  final String imageBn;
  final String imageEn;
  final String imageHi;
  final String imageKn;
  final String imageMl;
  final String imageMr;
  final String imageOr;
  final String imageTa;
  final String imageTl;

  ProductCatagoryModel({
    required this.id,
    required this.title,
    required this.color,
    required this.collectionId,
    required this.imageBn,
    required this.imageEn,
    required this.imageHi,
    required this.imageKn,
    required this.imageMl,
    required this.imageMr,
    required this.imageOr,
    required this.imageTa,
    required this.imageTl,
  });

  factory ProductCatagoryModel.fromJson(Map<String, dynamic> data) {
    final String colorHex = data['colorHex'] ?? '#FFFFFF';
    return ProductCatagoryModel(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      color: getColorFromCode(colorHex),
      collectionId: data['collectionId'] ?? '',
      imageBn: data['image_bn'] ?? '',
      imageEn: data['image_en'] ?? '',
      imageHi: data['image_hi'] ?? '',
      imageKn: data['image_kn'] ?? '',
      imageMl: data['image_ml'] ?? '',
      imageMr: data['image_mr'] ?? '',
      imageOr: data['image_or'] ?? '',
      imageTa: data['image_ta'] ?? '',
      imageTl: data['image_tl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'colorHex': color.toHexString(),
      'collectionId': collectionId,
      'image_bn': imageBn,
      'image_en': imageEn,
      'image_hi': imageHi,
      'image_kn': imageKn,
      'image_ml': imageMl,
      'image_mr': imageMr,
      'image_or': imageOr,
      'image_ta': imageTa,
      'image_tl': imageTl,
    };
  }
}

Color getColorFromCode(String code) {
  return code != "" ? Color(int.parse('0x$code')) : Colors.white;
}

