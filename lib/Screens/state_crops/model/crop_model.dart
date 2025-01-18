class CropModel {

  final String id;
  final String name;
  final String image;
  final String index;

  CropModel({
    required this.id,
    required this.name,
    required this.image,
    required this.index
  });

  factory CropModel.fromJson(Map<String, dynamic> json) {
    return CropModel(
      id: json['id'],
      name: json['Name'],
      image: json['Image'],
      index: json['index'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Name': name,
      'Image': image,
      'index': index,
    };
  }
}