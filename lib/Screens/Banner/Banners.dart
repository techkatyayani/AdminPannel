import 'package:adminpannal/Screens/Banner/bannerProvider.dart';
import 'package:adminpannal/Screens/Banner/adminUiHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:adminpannal/constants/app_constants.dart';

class BannerScreen extends StatelessWidget {
  const BannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider(
      create: (context) => BannerProvider(),
      child: Consumer<BannerProvider>(
        builder: (context, bannerProvider, child) {
          return FutureBuilder<Map<String, dynamic>>(
            future: bannerProvider.userDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  bannerProvider.isLoading) {
                return Center(
                  child:
                      Lottie.asset("assets/images/loading.json", height: 140),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                Map<String, dynamic> userData = snapshot.data ?? {};
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      AdminUIHelper.buildSectionHeader(
                          context, 'English Slide Banners', width),
                      AdminUIHelper.buildImageScroller(
                        context,
                        userData,
                        [
                          '150 product.jpg',
                          'best selling.jpg',
                          'crop calender.jpg'
                        ],
                        (imageName) =>
                            () => bannerProvider.pickImageAndUpdate(imageName),
                      ),
                      const SizedBox(height: krishiSpacing),
                      AdminUIHelper.buildSectionHeader(
                          context, 'Hindi Slide Banners', width),
                      AdminUIHelper.buildImageScroller(
                        context,
                        userData,
                        [
                          '150 product hindi.jpg',
                          'best selling hindi.jpg',
                          'crop calender hindi.jpg'
                        ],
                        (imageName) =>
                            () => bannerProvider.pickImageAndUpdate(imageName),
                      ),
                      const SizedBox(height: krishiSpacing),
                      AdminUIHelper.buildBannerSection(
                        context,
                        'English Strip Banners',
                        bannerProvider.englishStripBanner,
                        userData,
                        width,
                        (imageName) =>
                            () => bannerProvider.pickImageAndUpdate(imageName),
                      ),
                      const SizedBox(height: krishiSpacing),
                      AdminUIHelper.buildBannerSection(
                        context,
                        'Hindi Strip Banners',
                        bannerProvider.hindiStripBanner,
                        userData,
                        width,
                        (imageName) =>
                            () => bannerProvider.pickImageAndUpdate(imageName),
                      ),
                      const SizedBox(height: krishiSpacing),
                      AdminUIHelper.buildImageSection(
                        context,
                        'Agri Advisor Banner',
                        ['agri advisor.jpg', 'agri advisor hindi.jpg'],
                        userData,
                        width,
                        (imageName) =>
                            () => bannerProvider.pickImageAndUpdate(imageName),
                      ),
                      const SizedBox(height: krishiSpacing),
                      AdminUIHelper.buildImageSection(
                        context,
                        'Soil Testing',
                        ['soil_testing_english', 'soil_testing_hindi'],
                        userData,
                        width,
                        (imageName) =>
                            () => bannerProvider.pickImageAndUpdate(imageName),
                      ),
                      const SizedBox(height: krishiSpacing),
                      AdminUIHelper.buildImageSection(
                        context,
                        'Water Testing',
                        ['water_testing_english', 'water_testing_hindi'],
                        userData,
                        width,
                        (imageName) =>
                            () => bannerProvider.pickImageAndUpdate(imageName),
                      ),
                      const SizedBox(height: krishiSpacing),
                      AdminUIHelper.buildImageSection(
                        context,
                        'Wallet Banner',
                        ['wallet_english', 'wallet_hindi'],
                        userData,
                        width,
                        (imageName) =>
                            () => bannerProvider.pickImageAndUpdate(imageName),
                      ),
                      const SizedBox(height: krishiSpacing),
                      AdminUIHelper.buildImageSection(
                        context,
                        'Refer & Earn Banner',
                        ['refer_english', 'refer_hindi'],
                        userData,
                        width,
                        (imageName) =>
                            () => bannerProvider.pickImageAndUpdate(imageName),
                      ),
                      AdminUIHelper.buildImageSection(
                        context,
                        'Track Order Banner',
                        ['track.jpg', 'trackHindi.jpg'],
                        userData,
                        width,
                        (imageName) =>
                            () => bannerProvider.pickImageAndUpdate(imageName),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

class ImageContainer extends StatefulWidget {
  final String imageUrl;
  final String imageName;
  final VoidCallback onTap;
  final bool isLarge;

  const ImageContainer({
    super.key,
    required this.imageUrl,
    required this.imageName,
    required this.onTap,
    this.isLarge = false,
  });

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
                  child: Image.network(
                    widget.imageUrl,
                    width: !widget.isLarge ? width * 0.2 : width * .4,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Visibility(
                visible: isHovered,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black54,
                  ),
                  child: const Center(
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
