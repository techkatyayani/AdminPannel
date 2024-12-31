import 'package:adminpannal/Screens/prouct_catagory/controller/prouduct_catagory_controller.dart';
import 'package:adminpannal/Screens/prouct_catagory/widgets/add_product_catagory_dialog.dart';
// import 'package:adminpannal/Screens/prouct_catagory/widgets/add_product_catagory_dialog.dart';
import 'package:adminpannal/Screens/prouct_catagory/widgets/product_catagory_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCatagoryScreen extends StatefulWidget {
  const ProductCatagoryScreen({super.key});

  @override
  State<ProductCatagoryScreen> createState() => _ProductCatagoryScreenState();
}

class _ProductCatagoryScreenState extends State<ProductCatagoryScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prouductCatagoryController =
          Provider.of<ProuductCatagoryController>(context, listen: false);
      prouductCatagoryController.fetchAllProductCategories();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provi = Provider.of<ProuductCatagoryController>(context);
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Products',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                InkWell(
                  onTap: () {
                    provi.fetchAllProductCategories();
                  },
                  child: const Icon(
                    Icons.replay,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Consumer<ProuductCatagoryController>(
            builder: (context, provider, child) {
              // log(provider.isLoading.toString());
              return provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        crossAxisCount: 6,
                      ),
                      itemCount: provider.productCategories.length + 1,
                      itemBuilder: (context, index) {
                        if (index == provider.productCategories.length) {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const AddProductCatagoryDialog();
                                },
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 102, 84, 143),
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
                          final product = provider.productCategories[index];
                          return ProductCatagoryCard(
                              productCatagoryModel: product);
                        }
                      },
                    );
            },
          ),
        ],
      ),
    );
  }
}
