import 'package:adminpannal/Screens/Banner/adminUiHelper.dart';
import 'package:adminpannal/Screens/Banner/bannerProvider.dart';
import 'package:adminpannal/Screens/ProductBetweenBanners/addBetweenBanners.dart';
import 'package:adminpannal/Screens/ProductBetweenBanners/productBetweenDetailsScreen.dart';
import 'package:adminpannal/Screens/ProductBetweenBanners/upload.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ProductBetweenBanners extends StatefulWidget {
  const ProductBetweenBanners({super.key});

  @override
  State<ProductBetweenBanners> createState() => ProductBetweenBannersState();
}

class ProductBetweenBannersState extends State<ProductBetweenBanners> {
  // void _sendToFirebase() async {
  //   String id = '449900118312';
  //   await FirebaseFirestore.instance
  //       .collection('imagefromfirebase')
  //       .doc('ProductBetweenBanners')
  //       .collection('HindiProductBetweenBanners')
  //       .doc(id)
  //       .set({
  //     'id': id,
  //     'image1':
  //         'https://firebasestorage.googleapis.com/v0/b/krishisevakendra-8430a.appspot.com/o/Strip%20banner%20new%2Fnew%20arrivals.jpg?alt=media&token=998cc57e-e97d-4ee5-a1d9-e4d49bb7c50e',
  //     'image2':
  //         'https://firebasestorage.googleapis.com/v0/b/krishisevakendra-8430a.appspot.com/o/Strip%20banner%20new%2Fherbicides.jpg?alt=media&token=3b9e83e1-6c48-4783-af54-bb02a9a1bc5c',
  //     'image3':
  //         'https://firebasestorage.googleapis.com/v0/b/krishisevakendra-8430a.appspot.com/o/Strip%20banner%20new%2Fnew%20arrivals.jpg?alt=media&token=998cc57e-e97d-4ee5-a1d9-e4d49bb7c50e'
  //   });
  // }
  // void _sendToFirebase() async {
  //   String id = '457815327016';
  //   String title = "Special Kits";
  //   await FirebaseFirestore.instance
  //       .collection('imagefromfirebase')
  //       .doc('ProductBetweenBanners')
  //       .collection('EnglishProductBetweenBanners')
  //       .doc(id)
  //       .update({'title': title});
  //   await FirebaseFirestore.instance
  //       .collection('imagefromfirebase')
  //       .doc('ProductBetweenBanners')
  //       .collection('HindiProductBetweenBanners')
  //       .doc(id)
  //       .update({'title': title});
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          ChangeNotifierProvider(
            create: (context) => BannerProvider(),
            child: Consumer<BannerProvider>(
              builder: (context, bannerProvider, child) {
                return FutureBuilder<Map<String, dynamic>>(
                  future: bannerProvider.userDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        bannerProvider.isLoading) {
                      return Center(
                        child: Lottie.asset("assets/images/loading.json",
                            height: 140),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      Map<String, dynamic> userData = snapshot.data ?? {};
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            AdminUIHelper.buildImageSection(
                              context,
                              'Default English Products Between Strip Banners',
                              bannerProvider.productBetweenStripBanners,
                              userData,
                              width,
                              (imageName) => () =>
                                  bannerProvider.pickImageAndUpdate(imageName),
                            ),
                            AdminUIHelper.buildImageSection(
                              context,
                              'Default Hindi Products Between Strip Banners',
                              bannerProvider.productBetweenStripBannersHindi,
                              userData,
                              width,
                              (imageName) => () =>
                                  bannerProvider.pickImageAndUpdate(imageName),
                            ),
                            const SizedBox(height: krishiSpacing),
                          ],
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30, top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Product Between Banners',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      // onPressed: _sendToFirebase,
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: const AddBetweenBannersForm(),
                                type: PageTransitionType.fade));
                      },
                      child: const Text(
                        "Add Banners By Collection",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('imagefromfirebase')
                    .doc('ProductBetweenBanners')
                    .collection('EnglishProductBetweenBanners')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Lottie.asset("assets/images/loading.json",
                          height: 140),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final bannerData = snapshot.data!.docs;
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductBetweenBannerDetailsScreen(
                                    collectionName: bannerData[index]['title'],
                                    collectionId: bannerData[index].id,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 40),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: const Color.fromRGBO(38, 40, 55, 1),
                                ),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          bannerData[index]['title'] ?? '',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          bannerData[index].id,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    const SizedBox(width: 30),
                                    const Icon(Icons.edit_note_rounded),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 30)
        ],
      ),
    );
  }
}
