class Stage {
  final String stageId;
  final String stageName;
  final String stageImage;
  final String stageIcon;
  final int from;
  final int to;
  final List<String> products;
  final List<Activities> activities;

  Stage({
    required this.stageId,
    required this.stageName,
    required this.stageImage,
    required this.stageIcon,
    required this.from,
    required this.to,
    required this.products,
    required this.activities,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      stageId: json['stageId'] ?? '',
      stageName: json['stageName'] ?? '',
      stageImage: json['stageImage'] ?? '',
      stageIcon: json['stageIcon'] ?? '',
      from: json['from'] ?? 0,
      to: json['to'] ?? 0,
      activities: json['activities'] ?? [],
      products: List<String>.from(json['products'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stageId': stageId,
      'stageName': stageName,
      'stageImage': stageImage,
      'stageIcon': stageIcon,
      'from': from,
      'to': to,
      'products': products,
    };
  }


  Stage copyWith({
    String? stageId,
    String? stageName,
    String? stageImage,
    String? stageIcon,
    int? from,
    int? to,
    List<String>? products,
    List<Activities>? activities,
  }) {
    return Stage(
      stageId: stageId ?? this.stageId,
      stageName: stageName ?? this.stageName,
      stageImage: stageImage ?? this.stageImage,
      stageIcon: stageIcon ?? this.stageIcon,
      from: from ?? this.from,
      to: to ?? this.to,
      products: products ?? this.products,
      activities: activities ?? this.activities,
    );
  }
}

class Activities {
  final int duration;
  final List<Activity> activity;

  Activities({
    required this.duration,
    required this.activity,
  });

}

class Activity {
  final String id;
  final String name;
  final String image;
  final String summary;
  final String description;
  final List<String> instructions;
  final DateTime timestamp;

  Activity({
    required this.id,
    required this.name,
    required this.image,
    required this.summary,
    required this.description,
    required this.instructions,
    required this.timestamp,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      summary: json['summary'] ?? '',
      description: json['description'] ?? '',
      instructions: json['instructions'] != null ? List<String>.from(json['instructions']) : [],
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'summary': summary,
      'description': description,
      'instructions': instructions,
      'timestamp': timestamp.toString(),
    };
  }
}
