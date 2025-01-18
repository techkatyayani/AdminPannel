import 'dart:developer';

import 'package:adminpannal/Screens/prouct_catagory/controller/prouduct_catagory_controller.dart';
import 'package:adminpannal/Screens/prouct_catagory/model/product_catagory_model.dart';
import 'package:adminpannal/Screens/prouct_catagory/widgets/add_image_dialog.dart';
import 'package:adminpannal/Screens/prouct_catagory/widgets/update_catagory_discription_dialog.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class ProductCatagoryDetailsScreen extends StatefulWidget {
  final ProductCatagoryModel productCatagory;

  const ProductCatagoryDetailsScreen(
      {super.key, required this.productCatagory});

  @override
  State<ProductCatagoryDetailsScreen> createState() =>
      _ProductCatagoryDetailsScreenState();
}

class _ProductCatagoryDetailsScreenState extends State<ProductCatagoryDetailsScreen> {

  late ProuductCatagoryController provider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = Provider.of<ProuductCatagoryController>(context, listen: false);
      provider.getCollectionData(widget.productCatagory.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: Consumer<ProuductCatagoryController>(
        builder: (context, ProuductCatagoryController provider, child) {

          return provider.isLoadingCatagory
              ?
          const Center(child: CircularProgressIndicator())
              :
          provider.productCatagoryModel == null
              ?
          const Center(child: CircularProgressIndicator())
              :
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: boxColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.height * 0.15,
                          height: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 102, 84, 143),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.image,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(width: 20),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.productCatagoryModel!.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              "Collection ID: ${provider.productCatagoryModel!.collectionId}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              "Color Hex: ${provider.productCatagoryModel!.color.toHexString()}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  Positioned(
                    right: 30,
                    top: 30,
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return UpdateCatagoryDiscriptionDialog(
                              defaultCatagoryTitle:
                              provider.productCatagoryModel!.title,
                              defaultCatagoryId: provider
                                  .productCatagoryModel!.collectionId,
                              defaultCatagoryColorHex: provider
                                  .productCatagoryModel!.color
                                  .toHexString(),
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(25),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: provider.languages.map((language) {

                      String image = provider.getImageUrl(language, provider.productCatagoryModel!);

                      return Container(
                        width: 200,
                        height: 200,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 102, 84, 143),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Stack(
                          children: [

                            Column(
                              children: [
                                Flexible(
                                  child: ClipRRect(
                                    child: Image.network(
                                      image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Center(
                                          child: Icon(
                                            Icons.image,
                                            size: 50,
                                            color: Colors.white,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  color: boxColor,
                                  height: 40,
                                  child: Text(
                                    language,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),

                            Positioned(
                              right: 5,
                              top: 5,
                              child: IconButton(
                                onPressed: () {
                                  provider.deleteImageFromCategory(
                                    widget.productCatagory.id,
                                    language,
                                    image,
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );

                    }).toList(),
                  ),
                ),
              ),
            ],
          );
      }),
    );
  }
}
