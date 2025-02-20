import 'dart:developer';

class Stage {
  final String stageId;
  final String stageIcon;
  final int from;
  final int to;
  final List<Activities> activities;
  final CollectionProductModel? product;

  final String stageNameBn;
  final String stageNameEn;
  final String stageNameHi;
  final String stageNameKn;
  final String stageNameMl;
  final String stageNameMr;
  final String stageNameOr;
  final String stageNameTa;
  final String stageNameTl;

  Stage({
    required this.stageId,
    required this.stageIcon,
    required this.from,
    required this.to,
    required this.activities,
    this.product,

    required this.stageNameBn,
    required this.stageNameEn,
    required this.stageNameHi,
    required this.stageNameKn,
    required this.stageNameMl,
    required this.stageNameMr,
    required this.stageNameOr,
    required this.stageNameTa,
    required this.stageNameTl,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      stageId: json['stageId'] ?? '',
      stageIcon: json['stageIcon'] ?? '',
      from: json['from'] ?? 0,
      to: json['to'] ?? 0,
      product: json['product'],
      activities: json['activities'] ?? [],
      stageNameBn: json['stageNameBn'] ?? '',
      stageNameEn: json['stageNameEn'] ?? '',
      stageNameHi: json['stageNameHi'] ?? '',
      stageNameKn: json['stageNameKn'] ?? '',
      stageNameMl: json['stageNameMl'] ?? '',
      stageNameMr: json['stageNameMr'] ?? '',
      stageNameOr: json['stageNameOr'] ?? '',
      stageNameTa: json['stageNameTa'] ?? '',
      stageNameTl: json['stageNameTl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stageId': stageId,
      'stageIcon': stageIcon,
      'from': from,
      'to': to,
      'stageNameBn': stageNameBn,
      'stageNameEn': stageNameEn,
      'stageNameHi': stageNameHi,
      'stageNameKn': stageNameKn,
      'stageNameMl': stageNameMl,
      'stageNameMr': stageNameMr,
      'stageNameOr': stageNameOr,
      'stageNameTa': stageNameTa,
      'stageNameTl': stageNameTl,
    };
  }


  Stage copyWith({
    String? stageId,
    String? stageIcon,
    int? from,
    int? to,
    List<Activities>? activities,
    CollectionProductModel? product,
    String? stageNameBn,
    String? stageNameEn,
    String? stageNameHi,
    String? stageNameKn,
    String? stageNameMl,
    String? stageNameMr,
    String? stageNameOr,
    String? stageNameTa,
    String? stageNameTl,
  }) {
    return Stage(
      stageId: stageId ?? this.stageId,
      stageIcon: stageIcon ?? this.stageIcon,
      from: from ?? this.from,
      to: to ?? this.to,
      product: product,
      activities: activities ?? this.activities,
      stageNameBn: stageNameBn ?? this.stageNameBn,
      stageNameEn: stageNameEn ?? this.stageNameEn,
      stageNameHi: stageNameHi ?? this.stageNameHi,
      stageNameKn: stageNameKn ?? this.stageNameKn,
      stageNameMl: stageNameMl ?? this.stageNameMl,
      stageNameMr: stageNameMr ?? this.stageNameMr,
      stageNameOr: stageNameOr ?? this.stageNameOr,
      stageNameTa: stageNameTa ?? this.stageNameTa,
      stageNameTl: stageNameTl ?? this.stageNameTl
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
  final String actId;
  final String image;

  final Map<String, String> name;
  final Map<String, String> summary;
  final Map<String, String> description;
  final Map<String, List<String>> instructions;

  final DateTime timestamp;

  Activity({
    required this.id,
    required this.actId,
    required this.image,
    required this.name,
    required this.summary,
    required this.description,
    required this.instructions,
    required this.timestamp,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {

    final instructions = (json['instructions'] as Map?)?.map<String, List<String>>((key, value) {
      return MapEntry(
        key.toString(),
        List<String>.from(value ?? []),
      );
    }) ?? {};

    try {
      Activity activity = Activity(
        id: json['id'] ?? '',
        actId: json['act_id'] ?? '',
        image: json['image'] ?? '',
        name: Map<String, String>.from(json['name'] ?? {}),
        summary: Map<String, String>.from(json['summary'] ?? {}),
        description: Map<String, String>.from(json['description'] ?? {}),
        instructions: instructions,
        timestamp: DateTime.parse(json['timestamp'] ?? ''),
      );

      return activity;

    } catch (e, s) {
      log('Error in activity model\n\nError = $e\n\nStace = $s\n\n');
      throw Exception('Exception in Activity Model..!!');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'act_id': actId,
      'name': name,
      'image': image,
      'summary': summary,
      'description': description,
      'instructions': instructions,
      'timestamp': timestamp.toString(),
    };
  }
}

class CollectionProductModel {

  final String collectionId;
  final Map<String, String> collectionName;
  final Map<String, String> bannerImageUrl;
  final String backgroundImageUrl;

  CollectionProductModel({
    required this.collectionId,
    required this.collectionName,
    required this.bannerImageUrl,
    required this.backgroundImageUrl,
  });

  factory CollectionProductModel.fromJson(Map<String, dynamic> json) {
    return CollectionProductModel(
      collectionId: json['collectionId'] ?? '',
      collectionName: json['collectionName'] != null
          ? Map<String, String>.from(json['collectionName'])
          : {},
      bannerImageUrl: json['bannerImageUrl'] != null
          ? Map<String, String>.from(json['bannerImageUrl'])
          : {},
      backgroundImageUrl: json['backgroundImageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'collectionId': collectionId,
      'collectionName': collectionName,
      'bannerImageUrl': bannerImageUrl,
      'backgroundImageUrl': backgroundImageUrl,
    };
  }

  CollectionProductModel copyWith({
    String? collectionId,
    Map<String, String>? collectionName,
    Map<String, String>? bannerImageUrl,
    String? backgroundImageUrl,
  }) {
    return CollectionProductModel(
      collectionId: collectionId ?? this.collectionId,
      collectionName: collectionName ?? this.collectionName,
      bannerImageUrl: bannerImageUrl ?? this.bannerImageUrl,
      backgroundImageUrl: backgroundImageUrl ?? this.backgroundImageUrl,
    );
  }

}