class ProductCatagoryModel {
  final String productID;
  final String collectionID;
  final String colorHex;
  final String imageEn;
  final String imageHi;
  final String imageMal;
  final String imageTam;
  final String title;

  ProductCatagoryModel({
    required this.productID,
    required this.collectionID,
    required this.colorHex,
    required this.imageEn,
    required this.imageHi,
    required this.imageMal,
    required this.imageTam,
    required this.title,
  });

  factory ProductCatagoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCatagoryModel(
      productID: json['productID'] ?? '',
      collectionID: json['collectionID'] ?? '',
      colorHex: json['colorHex'] ?? '#FFFFFF',
      imageEn: json['imageEn'] ?? '',
      imageHi: json['imageHi'] ?? '',
      imageMal: json['imageMal'] ?? '',
      imageTam: json['imageTam'] ?? '',
      title: json['title'] ?? 'Untitled',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'collectionID': collectionID,
      'productID': productID,
      'colorHex': colorHex,
      'imageEn': imageEn,
      'imageHi': imageHi,
      'imageMal': imageMal,
      'imageTam': imageTam,
      'title': title,
    };
  }
}
