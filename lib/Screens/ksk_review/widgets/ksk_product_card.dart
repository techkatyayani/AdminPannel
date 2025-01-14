import 'dart:developer';

import 'package:adminpannal/Screens/ksk_review/model/product_model.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';

import '../product_review_screen.dart';

class KskProductCard extends StatelessWidget {

  final ProductModel productModel;

  const KskProductCard({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProductReviewScreen(
            productId: productModel.productId!,
          ),
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 102, 84, 143),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: productModel.productImage != null
                          ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(5),
                          topLeft: Radius.circular(5),
                        ),
                        child: Image.network(
                          productModel.productImage!,
                          fit: BoxFit.fill,
                          width: double.maxFinite,
                          errorBuilder: (context, error, stackTrace) {
                            log('Error showing image - $error, $stackTrace');
                            return const Icon(
                              Icons.error,
                              color: Colors.white,
                            );
                          },
                        ),
                      )
                          : const Icon(
                        Icons.image,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  alignment: Alignment.center,
                  child: Text(
                    productModel.productName ?? 'Unknown Product',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
