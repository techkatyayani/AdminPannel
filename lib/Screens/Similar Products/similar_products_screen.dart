import 'package:adminpannal/Screens/Similar%20Products/controller/similar_products_provider.dart';
import 'package:adminpannal/Screens/Similar%20Products/similar_product_banner_screen.dart';
import 'package:flutter/material.dart';
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

                return Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromRGBO(38, 40, 55, 1),
                  ),
                  child: GestureDetector(
                    onTap: () {

                    },
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
      ],
    );
  }
}
