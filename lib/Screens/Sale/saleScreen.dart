import 'package:adminpannal/Screens/Sale/saleDetailsScreen.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: krishiSpacing * 6, vertical: krishiSpacing),
      child: Column(
        children: [
          const SizedBox(height: krishiSpacing),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('DynamicSection')
                .doc('HomeSection')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Lottie.asset('assets/images/loading.json', height: 140);
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('Document does not exist'));
              }
              final saleData = snapshot.data!;

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: const SaleDetailsScreen(),
                      type: PageTransitionType.fade,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: boxColor,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "KSK SALE",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: krishiSpacing),
                        Row(
                          children: [
                            const Text(
                              "Collection ID : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Text(
                              saleData!['CollectionId'],
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: krishiSpacing / 2),
                        Row(
                          children: [
                            const Text(
                              "Time : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Expanded(
                              child: Text(
                                "${saleData['Days']}Day ${saleData['hours']}Hour ${saleData['minutes']}minute",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: krishiSpacing / 2),
                        Row(
                          children: [
                            const Text(
                              "Offer ( OPEN / CLOSE ) :  ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Expanded(
                              child: Text(
                                saleData['isOffer'] ? "OPEN" : "CLOSE",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: krishiSpacing),
                        Row(
                          children: [
                            const Text(
                              "StripBanner English :  ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              width: size.width * .4,
                              child: CachedNetworkImage(
                                  imageUrl: saleData['TopstripBanner']),
                            ),
                          ],
                        ),
                        const SizedBox(height: krishiSpacing),
                        Row(
                          children: [
                            const Text(
                              "StripBanner Hindi :  ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              width: size.width * .4,
                              child: CachedNetworkImage(
                                  imageUrl: saleData['TopstripBannerHi']),
                            ),
                          ],
                        ),
                        const SizedBox(height: krishiSpacing),
                        Row(
                          children: [
                            const Text(
                              "Product Background Image :  ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              width: size.width * .2,
                              child: CachedNetworkImage(
                                  imageUrl: saleData['ProductBG']),
                            ),
                          ],
                        ),
                        const SizedBox(height: krishiSpacing),
                        Row(
                          children: [
                            const Text(
                              "Background Image :  ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              height: size.width * .1,
                              width: size.width * .1,
                              child: CachedNetworkImage(
                                  imageUrl: saleData['BgImage']),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
