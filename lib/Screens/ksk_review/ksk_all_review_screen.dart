import 'package:adminpannal/Screens/ksk_review/controller/ksk_review_controller.dart';
import 'package:adminpannal/Screens/ksk_review/widgets/other_user_review_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KskAllReviewScreen extends StatefulWidget {
  const KskAllReviewScreen({super.key});

  @override
  State<KskAllReviewScreen> createState() => _KskAllReviewScreenState();
}

class _KskAllReviewScreenState extends State<KskAllReviewScreen> {
  @override
  void initState() {
    super.initState();
    // Provider.of<KskReviewController>(context, listen: false)
    //     .fetchAllReviewsFromAllProducts(false);
    Provider.of<KskReviewController>(context, listen: false)
        .getAllReviewForUser('9200286531880');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<KskReviewController>(
        builder: (context, provider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'All Product Reviews',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          // provider.fetchAllReviewsFromAllProducts(false);
                        },
                        icon: const Icon(Icons.replay))
                  ],
                ),
              ),
              Container(
                child: provider.isLoadingReviews
                    ? const Center(
                        child: CircularProgressIndicator(
                          // color: KrishiColors.primary,
                          color: Colors.white,
                        ),
                      )
                    : provider.allReviews.isEmpty
                        ? const Center(
                            child: Text(
                              'No Reviews Available',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: provider.allReviews.length,
                            itemBuilder: (context, index) {
                              final review = provider.allReviews[index];
                              return Container(
                                margin: const EdgeInsets.all(10),
                                child: OtherUserReviewCard(
                                  isAdmin: true,
                                  productId: review.productId!,
                                  reviewId: review.reviewId!,
                                  userName: review.userName ?? 'Unknown',
                                  rating: review.userRating ?? '0',
                                  review: review.userReview ?? '',
                                ),
                              );
                            },
                          ),
              ),
              // : Column(
              //     children: [
              //       Container(
              //         margin: const EdgeInsets.all(10),
              //         child: const OtherUserReviewCard(
              //           isAdmin: true,
              //           productId: '',
              //           reviewId: '',
              //           userName: '',
              //           rating: '',
              //           review: '',
              //         ),
              //       ),
              //       Container(
              //         margin: const EdgeInsets.all(10),
              //         child: const OtherUserReviewCard(
              //           isAdmin: true,
              //           productId: '',
              //           reviewId: '',
              //           userName: '',
              //           rating: '',
              //           review: '',
              //         ),
              //       ),
              //       Container(
              //         margin: const EdgeInsets.all(10),
              //         child: const OtherUserReviewCard(
              //           isAdmin: true,
              //           productId: '',
              //           reviewId: '',
              //           userName: '',
              //           rating: '',
              //           review: '',
              //         ),
              //       ),
              //       Container(
              //         margin: const EdgeInsets.all(10),
              //         child: const OtherUserReviewCard(
              //           isAdmin: true,
              //           productId: '',
              //           reviewId: '',
              //           userName: '',
              //           rating: '',
              //           review: '',
              //         ),
              //       ),
              //       Container(
              //         margin: const EdgeInsets.all(10),
              //         child: const OtherUserReviewCard(
              //           isAdmin: true,
              //           productId: '',
              //           reviewId: '',
              //           userName: '',
              //           rating: '',
              //           review: '',
              //         ),
              //       ),
              //       Container(
              //         margin: const EdgeInsets.all(10),
              //         child: const OtherUserReviewCard(
              //           isAdmin: true,
              //           productId: '',
              //           reviewId: '',
              //           userName: '',
              //           rating: '',
              //           review: '',
              //         ),
              //       ),
              //     ],
              //   )),
            ],
          );
        },
      ),
    );
  }
}
