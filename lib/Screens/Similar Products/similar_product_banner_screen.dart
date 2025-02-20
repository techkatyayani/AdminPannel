import 'package:adminpannal/Utils/app_language.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/similar_products_provider.dart';

class SimilarProductBannerScreen extends StatelessWidget {

  final Map<String, dynamic> bannerImages;

  const SimilarProductBannerScreen({super.key, required this.bannerImages});

  @override
  Widget build(BuildContext context) {

    final entries = AppLanguage.languageNameToCode.entries.toList();

    return Consumer<SimilarProductsProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
              scrolledUnderElevation: 0,
              title: const Text('Banner Images'),
              actions: [

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: const Center(
                    child: Text(
                      'Select Banner Image that appears on top of KSK app product page for products that does not have any similar products listed',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                const SizedBox(width: 30),

                ElevatedButton(
                    onPressed: () async {

                      Utils.showLoadingBox(context: context, title: 'Saving Images...');

                      bool isSaved = await provider.saveSimilarProductsBannerImages();

                      Navigator.pop(context);

                      if (isSaved) {
                        Navigator.pop(context);
                        Utils.showSnackBar(context: context, message: 'Banner Images updated successfully :)');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                ),

                const SizedBox(width: 20),
              ],
            ),
          body: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              itemCount: entries.length,
              itemBuilder: (context, index) {

                final entry = entries[index];

                final language = entry.key;
                final languageCode = entry.value;

                final imageUrl = bannerImages['banner_$languageCode'] ?? '';

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Text(
                        language,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),

                      const SizedBox(height: 10),

                      InkWell(
                        onTap: () async {
                          final image = await provider.pickImage();
                          if (image != null) {
                            provider.addPickedImage(language, image);
                          }
                        },
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.175,
                          width: double.maxFinite,
                          child: provider.pickedImages[language] == null
                              ?
                          Image.network(
                            imageUrl,
                            fit: BoxFit.fill,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1.5
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Tap to add banner image',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }
                          )
                              :
                          Image.memory(
                            provider.pickedImages[language]!,
                            fit: BoxFit.fill,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1.5
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Tap to add banner image',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            )
        );
      },
    );
  }


}
