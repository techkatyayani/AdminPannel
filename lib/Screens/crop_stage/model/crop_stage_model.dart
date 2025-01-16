class Stage {
  final String stageId;
  final String stageName;
  final String stageImage;
  final String stageIcon;
  final String from;
  final String to;
  final List<String> products;

  final List<Activities> activities;

  Stage({
    required this.stageId,
    required this.stageName,
    required this.stageImage,
    required this.stageIcon,
    required this.from,
    required this.to,
    required this.activities,
    required this.products,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      stageId: json['stageId'] ?? '',
      stageName: json['stageName'] ?? '',
      stageImage: json['stageImage'] ?? '',
      stageIcon: json['stageIcon'] ?? '',
      from: json['from'] != null ? json['from'].toString() : '',
      to: json['to'] != null ? json['to'].toString() : '',
      activities: json['activities'] ?? [],
      products: List<String>.from(json['products'] ?? []),
    );
  }

  Stage copyWith({
    String? stageId,
    String? stageName,
    String? stageImage,
    String? stageIcon,
    String? from,
    String? to,
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
  final String name;
  final String image;
  final String summary;
  final String description;
  final String instructions;

  Activity({
    required this.name,
    required this.image,
    required this.summary,
    required this.description,
    required this.instructions,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      summary: json['summary'] ?? '',
      description: json['description'] ?? '',
      instructions: json['instructions'] ?? '',
    );
  }
}
