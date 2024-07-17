import 'dart:typed_data';

import 'package:adminpannal/Screens/Banner/stripBanners.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:page_transition/page_transition.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({super.key});

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  final List<String> englishStripBanner = [
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

  final List<String> hindiStripBanner = [
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

  final List<String> productBetweenStripBanners = [
    'stripBanner1',
    'stripBanner2',
    'stripBanner3',
    'stripBanner4',
    'stripBanner5',
    'stripBanner6',
    'stripBanner7',
    'stripBanner8',
  ];
  final List<String> productBetweenStripBannersHindi = [
    'stripBannerHindi1',
    'stripBannerHindi2',
    'stripBannerHindi3',
    'stripBannerHindi4',
    'stripBannerHindi5',
    'stripBannerHindi6',
    'stripBannerHindi7',
    'stripBannerHindi8',
  ];

  late Future<Map<String, dynamic>> userDataFuture;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    userDataFuture = getImage();
  }

  Future<void> updateImage() async {
    setState(() {
      userDataFuture = getImage();
    });
  }

  Future<Map<String, dynamic>> getImage() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('imagefromfirebase')
          .doc('Category')
          .get();
      return doc.data() ?? {};
    } catch (e) {
      print('Error fetching image data: $e');
      return {};
    }
  }

  Future<void> _pickImageAndUpdate(String imageName) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() => isLoading = true);
      try {
        await FirebaseStorage.instance
            .ref()
            .child('swipe banner')
            .child(imageName)
            .delete();
      } catch (e) {
        print('Error deleting existing image: $e');
      }
      String? imageUrl =
          await _uploadImage(result.files.single.bytes!, imageName);
      if (imageUrl != null) {
        await FirebaseFirestore.instance
            .collection('imagefromfirebase')
            .doc('Category')
            .set({imageName: imageUrl}, SetOptions(merge: true));
        updateImage();
      }
      setState(() => isLoading = false);
    }
  }

  Future<String?> _uploadImage(List<int> imageBytes, String imageName) async {
    try {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('swipe banner')
          .child(imageName)
          .putData(Uint8List.fromList(imageBytes));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return FutureBuilder<Map<String, dynamic>>(
      future: userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || isLoading) {
          return Center(
              child: Lottie.asset("assets/images/loading.json", height: 140));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          Map<String, dynamic> userData = snapshot.data ?? {};
          return Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildSectionHeader('English Slide Banners', width),
                _buildImageScroller(userData, [
                  '150 product.jpg',
                  'best selling.jpg',
                  'crop calender.jpg'
                ]),
                const SizedBox(height: krishiSpacing),
                _buildSectionHeader('Hindi Slide Banners', width),
                _buildImageScroller(userData, [
                  '150 product hindi.jpg',
                  'best selling hindi.jpg',
                  'crop calender hindi.jpg'
                ]),
                const SizedBox(height: krishiSpacing),
                _buildBannerSection('English Strip Banners', englishStripBanner,
                    userData, width),
                const SizedBox(height: krishiSpacing),
                _buildBannerSection(
                    'Hindi Strip Banners', hindiStripBanner, userData, width),
                const SizedBox(height: krishiSpacing),
                _buildBannerSection('English Products Between Strip Banners',
                    productBetweenStripBanners, userData, width),
                _buildBannerSection('Hindi Products Between Strip Banners',
                    productBetweenStripBannersHindi, userData, width),
                const SizedBox(height: krishiSpacing),
                _buildImageSection(
                    'Agri Advisor Banner',
                    ['agri advisor.jpg', 'agri advisor hindi.jpg'],
                    userData,
                    width),
                const SizedBox(height: krishiSpacing),
                _buildImageSection('Wallet Banner',
                    ['wallet_english', 'wallet_hindi'], userData, width),
                const SizedBox(height: krishiSpacing),
                _buildImageSection('Refer & Earn Banner',
                    ['refer_english', 'refer_hindi'], userData, width),
                _buildImageSection(
                    'Track Order Banner', ['track.jpg'], userData, width),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildSectionHeader(String title, double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.01)),
        ),
      ],
    );
  }

  Widget _buildStripBannersHeader(
      String title, double width, List<String> bannersList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.01)),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    child: StripBannerScreen(
                        bannersList: bannersList, screenName: title),
                    type: PageTransitionType.fade));
          },
          child: const Text(
            "View All >",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget _buildBannerSection(String title, List<String> banners,
      Map<String, dynamic> userData, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStripBannersHeader(title, width, banners),
        SizedBox(
          height: MediaQuery.of(context).size.height * .1,
          child: Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: banners
                    .map((imageName) => ImageContainer(
                        imageUrl: userData[imageName] ?? '',
                        imageName: imageName,
                        onTap: () => _pickImageAndUpdate(imageName)))
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageScroller(
      Map<String, dynamic> userData, List<String> images) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .2,
      child: Scrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: images
                .map((imageName) => ImageContainer(
                    imageUrl: userData[imageName] ?? '',
                    imageName: imageName,
                    onTap: () => _pickImageAndUpdate(imageName)))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(String title, List<String> images,
      Map<String, dynamic> userData, double width) {
    return Column(
      children: [
        _buildSectionHeader(title, width),
        Row(
          children: images
              .map((imageName) => _buildImageColumn(
                  imageName, userData[imageName] ?? '', width))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildImageColumn(String imageName, String imageUrl, double width) {
    return Column(
      children: [
        ImageContainer(
            imageUrl: imageUrl,
            imageName: imageName,
            onTap: () => _pickImageAndUpdate(imageName)),
        const SizedBox(height: 6),
        Text(imageName.replaceAll('.jpg', '').replaceAll('_', ' '),
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class ImageContainer extends StatefulWidget {
  final String imageUrl;
  final String imageName;
  final VoidCallback onTap;

  const ImageContainer(
      {super.key,
      required this.imageUrl,
      required this.imageName,
      required this.onTap});

  @override
  _ImageContainerState createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(widget.imageUrl, width: width * 0.2),
                ),
              ),
            ),
            Positioned.fill(
              child: Visibility(
                visible: isHovered,
                child: Container(
                  color: Colors.black54,
                  child: const Center(
                    child: Text('Edit',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
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
