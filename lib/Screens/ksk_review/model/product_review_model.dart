class ProductReviewModel {
  String? reviewId;
  String? productId;
  String? userName;
  String? userEmail;
  String? userPhoneNumber;
  String? reviewImage;
  String? userRating;
  String? userReview;
  bool? isApproved;

  ProductReviewModel({
    this.productId,
    this.reviewId,
    this.userName,
    this.userEmail,
    this.userPhoneNumber,
    this.reviewImage,
    this.userRating,
    this.userReview,
    this.isApproved,
  });

  ProductReviewModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    reviewId = json['reviewId'];
    userName = json['userName'];
    userEmail = json['userEmail'];
    userPhoneNumber = json['userPhoneNumber'];
    reviewImage = json['reviewImage'];
    userRating = json['userRating'];
    userReview = json['userReview'];
    isApproved = json['isApproved'];
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'reviewId': reviewId,
      'userName': userName,
      'userEmail': userEmail,
      'userPhoneNumber': userPhoneNumber,
      'reviewImage': reviewImage,
      'userRating': userRating,
      'userReview': userReview,
      'isApproved': isApproved,
    };
  }
}
