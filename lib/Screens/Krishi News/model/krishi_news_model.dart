import 'package:cloud_firestore/cloud_firestore.dart';

class KrishiNewsModel {
  final String id;
  final String author;
  final String title;
  final String caption;
  final String product;
  final String mediaType;
  final String mediaUrl;
  final bool isCommentHidden;
  final List<String> likedBy;
  final List<Comments> comments;
  final int totalComments;
  final Timestamp timestamp;

  KrishiNewsModel({
    required this.id,
    required this.author,
    required this.title,
    required this.caption,
    required this.product,
    required this.mediaType,
    required this.mediaUrl,
    required this.isCommentHidden,
    required this.likedBy,
    required this.comments,
    required this.totalComments,
    required this.timestamp,
  });

  factory KrishiNewsModel.fromJson(Map<String, dynamic> json) {
    return KrishiNewsModel(
      id: json['id'] ?? '',
      author: json['author'] ?? '',
      title: json['title'] ?? '',
      caption: json['caption'] ?? '',
      product: json['product'] ?? '',
      mediaType: json['mediaType'] ?? '',
      mediaUrl: json['mediaUrl'] ?? '',
      isCommentHidden: json['isCommentHidden'] ?? false,
      likedBy: List<String>.from(json['likedBy'] ?? []),
      comments: [],
      totalComments: json['totalComments'] != null ? int.tryParse(json['totalComments'].toString()) ?? 0 : 0,
      timestamp: json['timestamp'] != null ? json['timestamp'] as Timestamp : Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'title': title,
      'caption': caption,
      'product': product,
      'mediaType': mediaType,
      'mediaUrl': mediaUrl,
      'likedBy': likedBy,
      'totalComments': totalComments,
      'isCommentHidden': isCommentHidden,
    };
  }

  KrishiNewsModel copyWith({
    String? id,
    String? author,
    String? title,
    String? caption,
    String? product,
    String? mediaType,
    String? mediaUrl,
    bool? isCommentHidden,
    List<String>? likedBy,
    List<Comments>? comments,
    int? totalComments,
    Timestamp? timestamp,
  }) {
    return KrishiNewsModel(
      id: id ?? this.id,
      author: author ?? this.author,
      title: title ?? this.title,
      caption: caption ?? this.caption,
      product: product ?? this.product,
      mediaType: mediaType ?? this.mediaType,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      isCommentHidden: isCommentHidden ?? this.isCommentHidden,
      likedBy: likedBy ?? this.likedBy,
      comments: comments ?? this.comments,
      totalComments: totalComments ?? this.totalComments,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class Comments {
  final String commentId;
  final String authorId;
  final String authorName;
  final String imageUrl;
  final String text;
  final List<String> likedBy;
  final Timestamp timestamp;

  Comments({
    required this.commentId,
    required this.authorId,
    required this.authorName,
    required this.imageUrl,
    required this.text,
    required this.likedBy,
    required this.timestamp,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      commentId: json['commentId'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      text: json['text'] ?? '',
      likedBy: List<String>.from(json['likedBy'] ?? []),
      timestamp: json['timestamp'] != null ? json['timestamp'] as Timestamp : Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'authorId': authorId,
      'authorName': authorName,
      'imageUrl': imageUrl,
      'text': text,
      'likedBy': likedBy,
      'timestamp': timestamp,
    };
  }
}
