import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class OtherUserReviewCard extends StatelessWidget {
  final String userName;
  final String rating;
  final String review;
  final String productId;
  final String reviewId;
  final bool isAdmin;
  const OtherUserReviewCard(
      {super.key,
      required this.userName,
      required this.rating,
      required this.review,
      required this.productId,
      required this.reviewId,
      required this.isAdmin});

  @override
  Widget build(BuildContext context) {
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
              Container(
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Verified Buyer',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              RatingBar.builder(
                itemSize: 20,
                initialRating: double.tryParse(rating) ?? 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ignoreGestures: true,
                onRatingUpdate: (value) {},
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text(
              review,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(120, 40),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Approve',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  fixedSize: const Size(120, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Disapprove',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
          //  Container(
          //     height: 100,
          //     child: ListView(
          //       scrollDirection: Axis.horizontal,
          //       children: [
          //         Container(
          //           margin: const EdgeInsets.only(right: 10),
          //           color: const Color.fromARGB(255, 224, 222, 222),
          //           height: 100,
          //           width: 100,
          //           child: const Icon(
          //             Icons.image,
          //             color: Colors.white,
          //           ),
          //         ),
          //         Container(
          //           margin: const EdgeInsets.only(right: 10),
          //           color: const Color.fromARGB(255, 224, 222, 222),
          //           height: 100,
          //           width: 100,
          //           child: const Icon(
          //             Icons.image,
          //             color: Colors.white,
          //           ),
          //         ),
          //         Container(
          //           margin: const EdgeInsets.only(right: 10),
          //           color: const Color.fromARGB(255, 224, 222, 222),
          //           height: 100,
          //           width: 100,
          //           child: const Icon(
          //             Icons.image,
          //             color: Colors.white,
          //           ),
          //         ),
          //         Container(
          //           margin: const EdgeInsets.only(right: 10),
          //           color: const Color.fromARGB(255, 224, 222, 222),
          //           height: 100,
          //           width: 100,
          //           child: const Icon(
          //             Icons.image,
          //             color: Colors.white,
          //           ),
          //         ),
          //         Container(
          //           margin: const EdgeInsets.only(right: 10),
          //           color: const Color.fromARGB(255, 224, 222, 222),
          //           height: 100,
          //           width: 100,
          //           child: const Icon(
          //             Icons.image,
          //             color: Colors.white,
          //           ),
          //         ),
          //         Container(
          //           margin: const EdgeInsets.only(right: 10),
          //           color: const Color.fromARGB(255, 224, 222, 222),
          //           height: 100,
          //           width: 100,
          //           child: const Icon(
          //             Icons.image,
          //             color: Colors.white,
          //           ),
          //         ),
          //         Container(
          //           margin: const EdgeInsets.only(right: 10),
          //           color: const Color.fromARGB(255, 224, 222, 222),
          //           height: 100,
          //           width: 100,
          //           child: const Icon(
          //             Icons.image,
          //             color: Colors.white,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
        ],
      ),
    );
  }
}
