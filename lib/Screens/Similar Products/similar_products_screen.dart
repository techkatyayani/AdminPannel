import 'dart:developer';

import 'package:adminpannal/Screens/Similar%20Products/controller/similar_products_provider.dart';
import 'package:adminpannal/Screens/Similar%20Products/similar_product_banner_screen.dart';
import 'package:adminpannal/Screens/Similar%20Products/similar_product_id_screen.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:adminpannal/common/custom_text_field.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SimilarProductsScreen extends StatefulWidget {
  const SimilarProductsScreen({super.key});

  @override
  State<SimilarProductsScreen> createState() => _SimilarProductsScreenState();
}

class _SimilarProductsScreenState extends State<SimilarProductsScreen> {

  late SimilarProductsProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<SimilarProductsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        const SizedBox(height: 25),

        StreamBuilder<Map<String, dynamic>>(
          stream: provider.fetchSimilarProductsBanner(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error fetching similar products data..!!\n${snapshot.error}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text(
                  'No similar products data available ..!!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }

            Map<String, dynamic> bannerImages = snapshot.data!;

            final imageUrl = bannerImages['banner_en'] ?? bannerImages['banner_hi'] ?? '';

            return Container(
              height: MediaQuery.of(context).size.height * 0.175,
              margin: const EdgeInsets.only(bottom: 10, right: 15, left: 15),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SimilarProductBannerScreen(
                      bannerImages: bannerImages,
                    ))
                  );
                },
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.fill,
                  width: double.maxFinite,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.error,
                      color: Colors.red[400],
                      size: 50,
                    );
                  }
                ),
              ),
            );

          }
        ),

        const SizedBox(height: 25),

        StreamBuilder<Map<String, Map<String, dynamic>>>(
          stream: provider.fetchSimilarProductsData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error fetching similar products data..!!\n${snapshot.error}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text(
                  'No similar products data available ..!!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }

            Map<String, Map<String, dynamic>> similarProductsData = snapshot.data!;

            final similarProductsDataEntries = similarProductsData.entries.toList();

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: similarProductsData.length,
              itemBuilder: (context, index) {

                final entry = similarProductsDataEntries[index];

                return GestureDetector(
                  onTap: () {
                    final productIds = List<String>.from(entry.value['products'] ?? []);

                    provider.initProductControllers(productIds);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => SimilarProductIdScreen(productId: entry.key)));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromRGBO(38, 40, 55, 1),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${index + 1}.',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(width: 20),

                        Text(
                          entry.key,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),
                        ),

                        const Spacer(),

                        const Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: Colors.white,
                        )
                      ]
                    ),
                  ),
                );
              }
            );

          }
        ),

        const SizedBox(height: 25),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: InkWell(
            onTap: showAddProductIdDialog,
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.fromBorderSide(BorderSide(
                      color: Colors.grey.shade200
                  ))
              ),
              alignment: Alignment.center,
              child: const Text(
                '+ Add More Ids',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  showAddProductIdDialog() {

    provider.initAddProductIdDialog();

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: formKey,
          child: Dialog(
            backgroundColor: boxColor,
            child: Consumer<SimilarProductsProvider>(
              builder: (context, provider, child) {
                return Container(
                  color: boxColor,
                  width: MediaQuery.of(context).size.width * 0.65,
                  height: MediaQuery.of(context).size.height * 0.8,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  child: Column(
                    children: [
                      const Text(
                          'Add New Product Id',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )
                      ),

                      const SizedBox(height: 20),

                      CustomTextField(
                        controller: provider.productIdController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        labelText: 'Product Id',
                      ),

                      const SizedBox(height: 20),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Similar Product Ids',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                          itemCount: provider.productControllers.length + 1,
                          itemBuilder: (context, index) {

                            if (index == provider.productControllers.length) {
                              return InkWell(
                                onTap: () {
                                  provider.addProductController();
                                },
                                child: Container(
                                  width: double.maxFinite,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.fromBorderSide(BorderSide(
                                          color: Colors.grey.shade200
                                      ))
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '+ Add More Ids',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              );
                            }

                            TextEditingController controller = provider.productControllers[index];

                            return Row(
                              children: [
                                Text(
                                    '${index+1}.',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )
                                ),

                                const SizedBox(width: 20),

                                Flexible(
                                  child: CustomTextField(
                                    controller: controller,
                                    hintText: 'Product Id',
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 20),

                                IconButton(
                                    onPressed: () {
                                      provider.removeProductController(index);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )
                                )
                              ],
                            );

                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 10);
                          },
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white
                                ),
                              )
                          ),

                          const SizedBox(width: 10),

                          ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {

                                  Utils.showLoadingBox(context: context, title: 'Saving Product Ids...');

                                  bool isSaved = await provider.saveSimilarProductsIds();

                                  Navigator.pop(context);

                                  if (isSaved) {
                                    Navigator.pop(context);
                                    Utils.showSnackBar(context: context, message: 'Product Ids saved successfully :)');
                                    setState(() {});
                                  }
                                } else {
                                  Utils.showSnackBar(context: context, message: 'Please enter product id..!!');
                                }

                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white
                                ),
                              )
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }
    );
  }
}
