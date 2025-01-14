import 'package:adminpannal/Screens/ksk_review/controller/ksk_review_controller.dart';
import 'package:adminpannal/Screens/ksk_review/model/product_review_model.dart';
import 'package:adminpannal/Screens/ksk_review/widgets/cutom_dropdown_button.dart';
import 'package:adminpannal/Screens/ksk_review/widgets/other_user_review_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import 'widgets/add_review_dialog.dart';

class ProductReviewScreen extends StatefulWidget {

  final String productId;

  const ProductReviewScreen({super.key, required this.productId});

  @override
  State<ProductReviewScreen> createState() => _ProductReviewScreenState();
}

class _ProductReviewScreenState extends State<ProductReviewScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<KskReviewController>(context, listen: false).getAllReviewForUser(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {

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
          Consumer<KskReviewController>(
            builder: (BuildContext context, KskReviewController provider, Widget? child) {
              return CustomDropDownMenu(
                items: const [
                  'All',
                  'Approved',
                  'Unapproved',
                  'Top Rated',
                  'Lowest Rated',
                  'Verified Users',
                  'Admins',
                ],
                onChanged: (value) {
                  provider.filterReviews(value!);
                },
              );
            },
          ),

          const SizedBox(width: 20),
        ],
      ),
      body: Consumer<KskReviewController>(
        builder: (context, provider, child) {
          return provider.isLoadingReviews
              ?
          const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              :
          provider.allFilteredReviews.isEmpty
                  ?
          const Center(
                      child: Text(
                        'No Reviews Available',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  :
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            itemCount: provider.allFilteredReviews.length,
            itemBuilder: (context, index) {
              ProductReviewModel review = provider.allFilteredReviews[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: OtherUserReviewCard(
                  review: review,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Consumer<KskReviewController>(
        builder: (BuildContext context, KskReviewController provider, Widget? child) {
          return InkWell(
              onTap: () {
                showAddReviewDialog(
                  context: context,
                  productId: widget.productId,
                );
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                    color: krishiPrimaryColor,
                    shape: BoxShape.circle
                ),
                child: Icon(
                  Icons.add,
                  size: 40,
                  color: krishiFontColorPallets[0],
                ),
              )
          );
        },
      ),
    );
  }
}
