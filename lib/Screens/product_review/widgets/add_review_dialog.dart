import 'dart:typed_data';

import 'package:adminpannal/Screens/Krishi%20News/widgets/custom_post_text_field.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_star_rating/simple_star_rating.dart';

import '../controller/ksk_review_controller.dart';

class AddReviewDialog extends StatefulWidget {

  final String productId;
  
  const AddReviewDialog({super.key, required this.productId});

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  
  final formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Dialog(
        backgroundColor: krishiFontColorPallets[0],
        child: Consumer<KskReviewController>(
          builder: (BuildContext context, KskReviewController provider, Widget? child) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.5,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              decoration: BoxDecoration(
                color: krishiFontColorPallets[0],
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    const Text(
                      'Add Review',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: krishiPrimaryColor,
                      ),
                    ),

                    const SizedBox(height: 20),

                    SimpleStarRating(
                      starCount: 5,
                      rating: provider.ratings,
                      size: 40,
                      spacing: 10,
                      isReadOnly: false,
                      onRated: (rate) {
                        provider.setRatings(rate ?? 3);
                      },
                    ),

                    const SizedBox(height: 20),

                    CustomPostTextField(
                      controller: provider.userNameController,
                      hintText: 'User Name',
                    ),

                    CustomPostTextField(
                      controller: provider.reviewController,
                      hintText: 'Review',
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Upload Photos (Max 3)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Image List Display
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        ...provider.reviewImages.asMap().entries.map((entry) {
                          int index = entry.key;
                          Uint8List image = entry.value;

                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(
                                  image,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    provider.removeReviewImage(index);
                                  },
                                  child: const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),

                        if (provider.reviewImages.length < 3)
                          GestureDetector(
                            onTap: () async {
                              await provider.pickFile();
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 40,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),



                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _customButton(
                          onPressed: () {
                            Navigator.pop(context);
                            provider.resetReviewDialog();
                          },
                          btnText: 'Cancel',
                          textColor: Colors.black,
                        ),

                        const SizedBox(width: 30),

                        _customButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {

                              Utils.showLoadingBox(context: context, title: 'Saving Review...');

                              await provider.saveReview(productId: widget.productId);

                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          },
                          btnText: 'Add',
                          textColor: krishiPrimaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _customButton({
    required VoidCallback onPressed,
    required String btnText,
    required Color textColor,
  }) {
    return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
        ),
        child: Text(
          btnText,
          style: TextStyle(
              fontSize: 18,
              color: textColor,
              fontWeight: textColor == Colors.black ? FontWeight.normal : FontWeight.bold
          ),
        )
    );
  }
}

showAddReviewDialog({
  required BuildContext context,
  required String productId,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AddReviewDialog(
        productId: productId
      );
    }
  );
}