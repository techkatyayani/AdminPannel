import 'dart:developer';

import 'package:adminpannal/Screens/prouct_catagory/controller/prouduct_catagory_controller.dart';
import 'package:adminpannal/Screens/prouct_catagory/model/product_catagory_model.dart';
import 'package:adminpannal/Screens/prouct_catagory/product_catagory_details_screen.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCatagoryCard extends StatelessWidget {

  final ProductCatagoryModel productCatagoryModel;

  const ProductCatagoryCard({super.key, required this.productCatagoryModel});

  @override
  Widget build(BuildContext context) {
    List<String> images = [];
    images.add(productCatagoryModel.imageEn);
    images.add(productCatagoryModel.imageHi);
    log(images.first);
    return Consumer<ProuductCatagoryController>(
        builder: (context, provider, child) {
      return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductCatagoryDetailsScreen(
              productCatagory: productCatagoryModel,
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
                      child: images.isNotEmpty
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(5),
                                topLeft: Radius.circular(5),
                              ),
                              child: Image.network(
                                images.first,
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
                    // color: Colors.redAccent,
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      productCatagoryModel.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  onPressed: () {
                    provider.deleteCategory(productCatagoryModel.collectionId);
                  },
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
