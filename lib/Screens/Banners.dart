import 'package:adminpannal/Screens/stripBanners.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({super.key});

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  List<String> englishStripBanner = [
    'new arrival.jpg',
    'farmersStrep',
    'organic product.jpg',
    'fertilizer.jpg',
    'insecticide.jpg',
    'herbicides.jpg',
    'plant_growth.jpg',
    'fungicide.jpg',
    'agri',
    'refer and earn.jpg',
    'Gst.jpg',
    'find your product.jpg'
  ];
  List<String> hindiStripBanner = [
    'new arrival hindi.jpg',
    'farmersStrep hindi',
    'organic product hindi.jpg',
    'fertilizer hindi.jpg',
    'insecticide hindi.jpg',
    'herbicides hindi.jpg',
    'plant_growth hindi.jpg',
    'fungicide hindi.jpg',
    'agri hindi',
    'refer and earn hindi.jpg',
    'Gst hindi.jpg',
    'find your product hindi.jpg'
  ];

  late Future<Map<String, dynamic>> userDataFuture;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    userDataFuture = getImage();
  }

  Future<void> updateImage() async {
    userDataFuture = getImage();
    setState(() {});
  }

  Future<Map<String, dynamic>> getImage() async {
    final DocumentReference user1 = FirebaseFirestore.instance
        .collection('imagefromfirebase')
        .doc('Category');
    try {
      DocumentSnapshot userSnapshot = await user1.get();
      setState(() {});
      return userSnapshot.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error fetching image data: $e');
      return {};
    }
  }

  Future<void> _pickImageAndUpdate(String imageName) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        isLoading = true;
      });
      List<int> fileBytes = result.files.single.bytes!;
      await FirebaseStorage.instance
          .ref()
          .child('swipe banner')
          .child(imageName)
          .delete()
          .catchError((error) {
        print('Error deleting existing image: $error');
      });
      String? imageUrl =
          await _uploadImage(imageBytes: fileBytes, imageName: imageName);

      if (imageUrl != null) {
        await updateImageUrlInFirestore(imageName, imageUrl);
        updateImage();
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<String?> _uploadImage(
      {required List<int> imageBytes, required String imageName}) async {
    try {
      Reference ref =
          FirebaseStorage.instance.ref().child('swipe banner').child(imageName);
      Uint8List uint8List = Uint8List.fromList(imageBytes);
      UploadTask uploadTask = ref.putData(uint8List);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> updateImageUrlInFirestore(
      String imageName, String imageUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection('imagefromfirebase')
          .doc('Category')
          .set({imageName: imageUrl}, SetOptions(merge: true));
    } catch (e) {
      print('Error updating image URL in Firestore: $e');
    }
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return FutureBuilder<Map<String, dynamic>>(
      future: userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.asset(
              "assets/images/loading.json",
              height: 140,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          Map<String, dynamic> userData = snapshot.data ?? {};
          if (isLoading) {
            return Center(
              child: Lottie.asset(
                "assets/images/loading.json",
                height: 140,
              ),
            );
          } else {
            return Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'English Slide Banners',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.01,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .2,
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ImageContainer(
                              imageUrl: userData['150 product.jpg'] ?? '',
                              imageName: '150 product.jpg',
                              onTap: () =>
                                  _pickImageAndUpdate('150 product.jpg'),
                            ),
                            ImageContainer(
                              imageUrl: userData['best selling.jpg'] ?? '',
                              imageName: 'best selling.jpg',
                              onTap: () =>
                                  _pickImageAndUpdate('best selling.jpg'),
                            ),
                            // ImageContainer(
                            //   imageUrl: userData['agri advisor.jpg'] ?? '',
                            //   imageName: 'agri advisor.jpg',
                            //   onTap: () =>
                            //       _pickImageAndUpdate('agri advisor.jpg'),
                            // ),
                            ImageContainer(
                              imageUrl: userData['crop calender.jpg'] ?? '',
                              imageName: 'crop calender.jpg',
                              onTap: () =>
                                  _pickImageAndUpdate('crop calender.jpg'),
                            ),
                            // ImageContainer(
                            //   imageUrl: userData['farmer favourite.jpg'] ?? '',
                            //   imageName: 'farmer favourite.jpg',
                            //   onTap: () =>
                            //       _pickImageAndUpdate('farmer favourite.jpg'),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: krishiSpacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Hindi Slide Banners',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.01,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .2,
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // ImageContainer(
                            //   imageUrl: userData['Demo.jpg'] ?? '',
                            //   imageName: 'Demo.jpg',
                            //   onTap: () => _pickImageAndUpdate('Demo.jpg'),
                            // ),
                            ImageContainer(
                              imageUrl: userData['150 product hindi.jpg'] ?? '',
                              imageName: '150 product hindi.jpg',
                              onTap: () =>
                                  _pickImageAndUpdate('150 product hindi.jpg'),
                            ),
                            ImageContainer(
                              imageUrl:
                                  userData['best selling hindi.jpg'] ?? '',
                              imageName: 'best selling hindi.jpg',
                              onTap: () =>
                                  _pickImageAndUpdate('best selling hindi.jpg'),
                            ),
                            ImageContainer(
                              imageUrl:
                                  userData['crop calender hindi.jpg'] ?? '',
                              imageName: 'crop calender hindi.jpg',
                              onTap: () => _pickImageAndUpdate(
                                  'crop calender hindi.jpg'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: krishiSpacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'English Strip Banners',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.01,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: StripBannerScreen(
                                bannersList: englishStripBanner,
                                screenName: "English Strip Banner",
                              ),
                              type: PageTransitionType.fade,
                            ),
                          );
                        },
                        child: Text(
                          "View All -->",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.01,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .1,
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (final imageName in englishStripBanner)
                              ImageContainer(
                                imageUrl: userData[imageName] ?? '',
                                imageName: imageName,
                                onTap: () => _pickImageAndUpdate(imageName),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: krishiSpacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Hindi Strip Banners',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.01,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                                child: StripBannerScreen(
                                  bannersList: hindiStripBanner,
                                  screenName: "Hindi Strip Banner",
                                ),
                                type: PageTransitionType.fade),
                          );
                        },
                        child: Text(
                          "View All -->",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.01,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .1,
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (final imageName in hindiStripBanner)
                              ImageContainer(
                                imageUrl: userData[imageName] ?? '',
                                imageName: imageName,
                                onTap: () => _pickImageAndUpdate(imageName),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Agri Advisor Banner',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.01,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          ImageContainer(
                            imageUrl: userData['agri advisor.jpg'] ?? '',
                            imageName: 'agri advisor.jpg',
                            onTap: () =>
                                _pickImageAndUpdate('agri advisor.jpg'),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Agri Advisor English",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ImageContainer(
                            imageUrl: userData['agri advisor hindi.jpg'] ?? '',
                            imageName: 'agri advisor hindi.jpg',
                            onTap: () =>
                                _pickImageAndUpdate('agri advisor hindi.jpg'),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Agri Advisor Hindi",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Wallet Banner',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.01,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          ImageContainer(
                            imageUrl: userData['wallet_english'] ?? '',
                            imageName: 'wallet_english',
                            onTap: () => _pickImageAndUpdate('wallet_english'),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Wallet Banner English",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ImageContainer(
                            imageUrl: userData['wallet_hindi'] ?? '',
                            imageName: 'wallet_hindi',
                            onTap: () => _pickImageAndUpdate('wallet_hindi'),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Wallet Banner Hindi",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Refer & Earn Banner',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.01,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          ImageContainer(
                            imageUrl: userData['refer_english'] ?? '',
                            imageName: 'refer_english',
                            onTap: () => _pickImageAndUpdate('refer_english'),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Refer Banner English",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ImageContainer(
                            imageUrl: userData['refer_hindi'] ?? '',
                            imageName: 'refer_hindi',
                            onTap: () => _pickImageAndUpdate('refer_hindi'),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Refer Banner Hindi",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        }
      },
    );
  }
}

class ImageContainer extends StatefulWidget {
  final String imageUrl;
  final String imageName;
  final VoidCallback onTap;

  const ImageContainer({
    super.key,
    required this.imageUrl,
    required this.imageName,
    required this.onTap,
  });

  @override
  _ImageContainerState createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(
                    widget.imageUrl,
                    width: width * 0.2,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Visibility(
                visible: isHovered,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
