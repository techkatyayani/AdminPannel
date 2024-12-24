class Category {
  final String collectionId;
  final String categoryName;
  final String categoryImage;
  final String categoryColor1;
  final String categoryColor2;
  final String position;
  final String docId;

  Category({
    required this.collectionId,
    required this.categoryName,
    required this.categoryImage,
    required this.categoryColor1,
    required this.categoryColor2,
    required this.position,
    required this.docId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      collectionId: json['collectionId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      categoryImage: json['categoryImage'] ?? '',
      categoryColor1: json['categoryColor1'] ?? '',
      categoryColor2: json['categoryColor2'] ?? '',
      position: json['position'] ?? '',
      docId: json['docId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'collectionId': collectionId,
      'categoryName': categoryName,
      'categoryImage': categoryImage,
      'categoryColor1': categoryColor1,
      'categoryColor2': categoryColor2,
      'position': position,
      'docId': docId,
    };
  }
}
