import 'package:adminpannal/Screens/ksk_review/controller/ksk_review_controller.dart';
import 'package:adminpannal/Screens/ksk_review/ksk_all_review_screen.dart';
import 'package:adminpannal/Screens/ksk_review/model/product_model.dart';
import 'package:adminpannal/Screens/prouct_catagory/controller/prouduct_catagory_controller.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KskProductCard extends StatelessWidget {
  final ProductModel productModel;
  const KskProductCard({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    return Consumer<KskReviewController>(builder: (context, provider, child) {
      return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => KskAllReviewScreen(
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
                      width: double.infinity,
                      child: productModel.productImage == null
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(5),
                                topLeft: Radius.circular(5),
                              ),
                              child: Image.network(
                                productModel.productImage!,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                  Icons.image,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.image,
                              color: Colors.white,
                            ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    // color: Colors.redAccent,
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      productModel.productName ?? 'Unkwnown',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 10,
                right: 10,
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
    });
  }
}
