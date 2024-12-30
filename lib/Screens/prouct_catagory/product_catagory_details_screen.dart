import 'package:adminpannal/Screens/prouct_catagory/controller/prouduct_catagory_controller.dart';
import 'package:adminpannal/Screens/prouct_catagory/model/product_catagory_model.dart';
import 'package:adminpannal/Screens/prouct_catagory/widgets/add_image_dialog.dart';
import 'package:adminpannal/Screens/prouct_catagory/widgets/add_product_catagory_dialog.dart';
// import 'package:adminpannal/Screens/prouct_catagory/widgets/product_catagory_card.dart';
import 'package:adminpannal/Screens/prouct_catagory/widgets/update_catagory_discription_dialog.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCatagoryDetailsScreen extends StatefulWidget {
  final ProductCatagoryModel productCatagory;
  const ProductCatagoryDetailsScreen(
      {super.key, required this.productCatagory});

  @override
  State<ProductCatagoryDetailsScreen> createState() =>
      _ProductCatagoryDetailsScreenState();
}

class _ProductCatagoryDetailsScreenState
    extends State<ProductCatagoryDetailsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prouductCatagoryController =
          Provider.of<ProuductCatagoryController>(context, listen: false);
      prouductCatagoryController
          .getCollectionData(widget.productCatagory.collectionID);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<ProuductCatagoryController>(context);
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
      body: pro.isLoadingCatagory
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Consumer<ProuductCatagoryController>(
                    builder: (context, providr, child) {
                  return Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 5,
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: boxColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: double.infinity,
                              width: 150,
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
                                  providr.productCatagoryModel!.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Collection ID: ${providr.productCatagoryModel!.collectionID}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Color Hex: ${providr.productCatagoryModel!.colorHex}",
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
                                      providr.productCatagoryModel!.title,
                                  defaultCatagoryId: providr
                                      .productCatagoryModel!.collectionID,
                                  defaultCatagoryColorHex:
                                      providr.productCatagoryModel!.colorHex,
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
                  );
                }),
                Container(
                  padding: const EdgeInsets.all(30),
                  child: Consumer<ProuductCatagoryController>(
                    builder: (context, provider, child) {
                      // List of maps containing images and their corresponding languages
                      final imagesAndLanguages = [
                        if (provider.productCatagoryModel!.imageEn.isNotEmpty)
                          {
                            'image': provider.productCatagoryModel!.imageEn,
                            'language': 'English'
                          },
                        if (provider.productCatagoryModel!.imageHi.isNotEmpty)
                          {
                            'image': provider.productCatagoryModel!.imageHi,
                            'language': 'Hindi'
                          },
                        if (provider.productCatagoryModel!.imageMal.isNotEmpty)
                          {
                            'image': provider.productCatagoryModel!.imageMal,
                            'language': 'Malayalam'
                          },
                        if (provider.productCatagoryModel!.imageTam.isNotEmpty)
                          {
                            'image': provider.productCatagoryModel!.imageTam,
                            'language': 'Tamil'
                          },
                      ];

                      return imagesAndLanguages.isEmpty
                          ? const Center(
                              child: Text(
                                'No Images Available',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                crossAxisCount: 8,
                              ),
                              itemCount: imagesAndLanguages.length +
                                  1, // +1 for the "add image" icon
                              itemBuilder: (context, index) {
                                if (index == imagesAndLanguages.length) {
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AddImageDialog(
                                            collectionId: widget
                                                .productCatagory.collectionID,
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 102, 84, 143),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                } else {
                                  final imageDetail = imagesAndLanguages[index];
                                  final image = imageDetail['image'];
                                  final language = imageDetail['language'];

                                  return Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 102, 84, 143),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    width: double.infinity,
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: [
                                            Expanded(
                                              child: image!.isNotEmpty
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topRight:
                                                            Radius.circular(5),
                                                        topLeft:
                                                            Radius.circular(5),
                                                      ),
                                                      child: Image.network(
                                                        image,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                                error,
                                                                stackTrace) =>
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
                                            const SizedBox(height: 5),
                                            Container(
                                              alignment: Alignment.center,
                                              width: double.infinity,
                                              color: boxColor,
                                              height: 40,
                                              child: Text(
                                                language ?? 'Unknown',
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
                                          right: 10,
                                          top: 10,
                                          child: IconButton(
                                            onPressed: () {
                                              provider.deleteImageFromCategory(
                                                widget.productCatagory
                                                    .collectionID,
                                                language!,
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
                                }
                              },
                            );
                    },
                  ),
                )
              ],
            ),
    );
  }
}
