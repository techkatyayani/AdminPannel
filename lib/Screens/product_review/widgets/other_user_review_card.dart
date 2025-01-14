import 'package:adminpannal/Utils/utils.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controller/ksk_review_controller.dart';
import '../model/product_review_model.dart';

class OtherUserReviewCard extends StatelessWidget {

  final ProductReviewModel review;

  const OtherUserReviewCard({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<KskReviewController>(builder: (context, provider, child) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Image.network(
                        review.userProfileImage ?? '',
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stace) {
                          return Image.asset(
                            'assets/images/Default User Image.png',
                            fit: BoxFit.fill,
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 15),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          review.userName.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          review.userId != null ? review.userId == 'Katyayani Organics' ? 'Katyayani Organics' : 'Verified User' : '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          review.timestamp != null ? DateFormat('dd MMM yyyy hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(review.timestamp!)) : '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                RatingBar.builder(
                  itemSize: 25,
                  initialRating: double.tryParse(review.userRating ?? '') ?? 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  ignoreGestures: true,
                  onRatingUpdate: (value) {},
                  itemBuilder: (context, _) {
                    return const Icon(
                      Icons.star,
                      color: Colors.amber,
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userReview ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 10),

                      if (review.reviewImage != null)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: review.reviewImage!.map((image) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                    image,
                                    fit: BoxFit.fill,
                                    width: MediaQuery.of(context).size.width * 0.15,
                                    errorBuilder: (_, e, s) {
                                      return const Icon(
                                        Icons.error,
                                        color: Colors.white,
                                      );
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                    ],
                  ),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(120, 40),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    provider.toggleReviewApproval(review.reviewId ?? '', review.productId ?? '');
                  },
                  child: Text(
                    (review.isApproved ?? true) ? 'Disapprove' : 'Approve',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(width: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    fixedSize: const Size(120, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () async {
                    Utils.showLoadingBox(context: context, title: 'Deleting Review..');

                    bool isDeleted = await provider.deleteReview(review.reviewId ?? '', review.productId ?? '');

                    Navigator.pop(context);

                    if (isDeleted) {
                      Utils.showSnackBar(context: context, message: 'Review Deleted Successfully');
                    } else {
                      Utils.showSnackBar(context: context, message: 'Something Went Wrong while deleting product review..!!');
                    }

                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
