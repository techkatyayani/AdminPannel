class Category {
  final String collectionId;
  final String categoryName;
  final String categoryImage;
  final String categoryColor1;
  final String categoryColor2;
  final String position;
  final String docId;

  final String nameBn;
  final String nameEn;
  final String nameHi;
  final String nameKn;
  final String nameMl;
  final String nameMr;
  final String nameOr;
  final String nameTa;
  final String nameTl;

  Category({
    required this.collectionId,
    required this.categoryName,
    required this.categoryImage,
    required this.categoryColor1,
    required this.categoryColor2,
    required this.position,
    required this.docId,
    required this.nameBn,
    required this.nameEn,
    required this.nameHi,
    required this.nameKn,
    required this.nameMl,
    required this.nameMr,
    required this.nameOr,
    required this.nameTa,
    required this.nameTl,
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
      nameBn: json['name_bn'] ?? '',
      nameEn: json['name_en'] ?? '',
      nameHi: json['name_hi'] ?? '',
      nameKn: json['name_kn'] ?? '',
      nameMl: json['name_ml'] ?? '',
      nameMr: json['name_mr'] ?? '',
      nameOr: json['name_or'] ?? '',
      nameTa: json['name_ta'] ?? '',
      nameTl: json['name_tl'] ?? '',
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
      'name_bn': nameBn,
      'name_en': nameEn,
      'name_hi': nameHi,
      'name_kn': nameKn,
      'name_ml': nameMl,
      'name_mr': nameMr,
      'name_or': nameOr,
      'name_ta': nameTa,
      'name_tl': nameTl,
    };
  }

  Category copyWith({
    String? collectionId,
    String? categoryName,
    String? categoryImage,
    String? categoryColor1,
    String? categoryColor2,
    String? position,
    String? docId,
    String? nameBn,
    String? nameEn,
    String? nameHi,
    String? nameKn,
    String? nameMl,
    String? nameMr,
    String? nameOr,
    String? nameTa,
    String? nameTl,
  }) {
    return Category(
      collectionId: collectionId ?? this.collectionId,
      categoryName: categoryName ?? this.categoryName,
      categoryImage: categoryImage ?? this.categoryImage,
      categoryColor1: categoryColor1 ?? this.categoryColor1,
      categoryColor2: categoryColor2 ?? this.categoryColor2,
      position: position ?? this.position,
      docId: docId ?? this.docId,
      nameBn: nameBn ?? this.nameBn,
      nameEn: nameEn ?? this.nameEn,
      nameHi: nameHi ?? this.nameHi,
      nameKn: nameKn ?? this.nameKn,
      nameMl: nameMl ?? this.nameMl,
      nameMr: nameMr ?? this.nameMr,
      nameOr: nameOr ?? this.nameOr,
      nameTa: nameTa ?? this.nameTa,
      nameTl: nameTl ?? this.nameTl,
    );
  }

}
