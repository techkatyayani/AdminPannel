// class ProductReviewModel {
//   String? reviewId;
//   String? productId;
//   String? userName;
//   String? userEmail;
//   String? userPhoneNumber;
//   String? reviewImage;
//   String? userRating;
//   String? userReview;
//   bool? isApproved;

//   ProductReviewModel({
//     this.productId,
//     this.reviewId,
//     this.userName,
//     this.userEmail,
//     this.userPhoneNumber,
//     this.reviewImage,
//     this.userRating,
//     this.userReview,
//     this.isApproved,
//   });

//   ProductReviewModel.fromJson(Map<String, dynamic> json) {
//     productId = json['productId'];
//     reviewId = json['reviewId'];
//     userName = json['userName'];
//     userEmail = json['userEmail'];
//     userPhoneNumber = json['userPhoneNumber'];
//     reviewImage = json['reviewImage'];
//     userRating = json['userRating'];
//     userReview = json['userReview'];
//     isApproved = json['isApproved'];
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'productId': productId,
//       'reviewId': reviewId,
//       'userName': userName,
//       'userEmail': userEmail,
//       'userPhoneNumber': userPhoneNumber,
//       'reviewImage': reviewImage,
//       'userRating': userRating,
//       'userReview': userReview,
//       'isApproved': isApproved,
//     };
//   }
// }

class ProductReviewModel {
  String? reviewId;
  String? productId;
  String? userId;
  String? userName;
  String? userProfileImage;
  List<String>? reviewImage;
  String? userRating;
  String? userReview;
  bool? isApproved;
  int? timestamp;

  ProductReviewModel({
    this.productId,
    this.reviewId,
    this.userId,
    this.userName,
    this.reviewImage,
    this.userRating,
    this.userReview,
    this.isApproved,
    this.userProfileImage,
    this.timestamp,
  });

  ProductReviewModel.fromJson(Map<String, dynamic> json) {
    reviewId = json['id'] ?? '';
    productId = json['productId'] ?? '';
    userId = json['userId'] ?? '';
    userName = json['username'] ?? '';
    reviewImage = List<String>.from(json['reviewImage'] ?? []);
    userRating = json['rating'] ?? '';
    userReview = json['review'] ?? '';
    isApproved = json['isApproved'] ?? false;
    userProfileImage = json['userProfileImage'] ?? '';
    timestamp = json['timestamp'] ?? -1;
  }
}
