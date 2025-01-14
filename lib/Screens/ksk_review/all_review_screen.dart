import 'package:adminpannal/Screens/ksk_review/controller/ksk_review_controller.dart';
import 'package:adminpannal/Screens/ksk_review/widgets/ksk_product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllReviewScreen extends StatefulWidget {
  const AllReviewScreen({super.key});

  @override
  State<AllReviewScreen> createState() => _AllReviewScreenState();
}

class _AllReviewScreenState extends State<AllReviewScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<KskReviewController>(context, listen: false)
          .fetchAllProducts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provi = Provider.of<KskReviewController>(context);
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Review Products',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                InkWell(
                  onTap: () {
                    provi.fetchAllProducts();
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

          Consumer<KskReviewController>(
            builder: (context, provider, child) {
              return provider.isLoadingProducts
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        crossAxisCount: 6,
                      ),
                      itemCount: provider.allProducts.length,
                      itemBuilder: (context, index) {
                        final product = provider.allProducts[index];
                        return KskProductCard(productModel: product);
                      },
                    );
            },
          ),
        ],
      ),
    );
  }
}
