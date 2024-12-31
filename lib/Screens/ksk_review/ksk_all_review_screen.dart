import 'package:adminpannal/Screens/ksk_review/controller/ksk_review_controller.dart';
import 'package:adminpannal/Screens/ksk_review/widgets/cutom_dropdown_button.dart';
import 'package:adminpannal/Screens/ksk_review/widgets/other_user_review_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KskAllReviewScreen extends StatefulWidget {
  final String productId;
  const KskAllReviewScreen({super.key, required this.productId});

  @override
  State<KskAllReviewScreen> createState() => _KskAllReviewScreenState();
}

class _KskAllReviewScreenState extends State<KskAllReviewScreen> {
  @override
  void initState() {
    super.initState();

    Provider.of<KskReviewController>(context, listen: false)
        .getAllReviewForUser(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    final provi = Provider.of<KskReviewController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products Reviews',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        actions: [
          CustomDropDownMenu(
            items: const [
              'All',
              'Approved',
              'Unapproved',
              'Top Rated',
              'Lowest Rated',
            ],
            onChanged: (value) {
              provi.filterReviews(value!);
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Consumer<KskReviewController>(
        builder: (context, provider, child) {
          return Container(
            child: provider.isLoadingReviews
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : provider.allFilteredReviews.isEmpty
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
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: provider.allFilteredReviews.length,
                        itemBuilder: (context, index) {
                          final review = provider.allFilteredReviews[index];
                          return Container(
                            margin: const EdgeInsets.all(10),
                            child: OtherUserReviewCard(
                              isApproved: review.isApproved ?? false,
                              productId: review.productId ?? '',
                              reviewId: review.reviewId ?? '',
                              userName: review.userName ?? 'Unknown',
                              rating: review.userRating ?? '0',
                              review: review.userReview ?? '',
                            ),
                          );
                        },
                      ),
          );
        },
      ),
    );
  }
}
