class CropModel {

  final String id;
  final String name;
  final String image;
  final String index;
  final String totalDuration;

  CropModel({
    required this.id,
    required this.name,
    required this.image,
    required this.index,
    required this.totalDuration,
  });

  factory CropModel.fromJson(Map<String, dynamic> json) {
    return CropModel(
      id: json['id'] ?? '',
      name: json['Name'] ?? '',
      image: json['Image'] ?? '',
      index: json['index'] ?? '',
      totalDuration: json['totalDuration'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Name': name,
      'Image': image,
      'index': index,
      'totalDuration': totalDuration
    };
  }
}