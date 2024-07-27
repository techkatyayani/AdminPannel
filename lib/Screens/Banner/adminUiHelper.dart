import 'package:adminpannal/Screens/Banner/Banners.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:adminpannal/Screens/Banner/stripBanners.dart';

class AdminUIHelper {
  static Widget buildSectionHeader(
      BuildContext context, String title, double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: width * 0.01,
            ),
          ),
        ),
      ],
    );
  }

  static Widget buildStripBannersHeader(
    BuildContext context,
    String title,
    double width,
    List<String> bannersList,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            title,
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
                  bannersList: bannersList,
                  screenName: title,
                ),
                type: PageTransitionType.fade,
              ),
            );
          },
          child: const Text(
            "View All >",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  static Widget buildBannerSection(
    BuildContext context,
    String title,
    List<String> banners,
    Map<String, dynamic> userData,
    double width,
    VoidCallback Function(String) onUpdate,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildStripBannersHeader(context, title, width, banners),
        SizedBox(
          height: MediaQuery.of(context).size.height * .1,
          child: Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: banners.map((imageName) {
                  return ImageContainer(
                    imageUrl: userData[imageName] ?? '',
                    imageName: imageName,
                    onTap: onUpdate(imageName),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget buildImageScroller(
    BuildContext context,
    Map<String, dynamic> userData,
    List<String> images,
    VoidCallback Function(String) onUpdate,
  ) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .2,
      child: Scrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: images.map((imageName) {
              return ImageContainer(
                imageUrl: userData[imageName] ?? '',
                imageName: imageName,
                onTap: onUpdate(imageName),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  static Widget buildImageSection(
    BuildContext context,
    String title,
    List<String> images,
    Map<String, dynamic> userData,
    double width,
    VoidCallback Function(String) onUpdate,
  ) {
    return Column(
      children: [
        buildSectionHeader(context, title, width),
        Row(
          children: images.map((imageName) {
            return buildImageColumn(
              context,
              imageName,
              userData[imageName] ?? '',
              width,
              onUpdate(imageName),
            );
          }).toList(),
        ),
      ],
    );
  }

  static Widget buildImageColumn(
    BuildContext context,
    String imageName,
    String imageUrl,
    double width,
    VoidCallback onUpdate,
  ) {
    return Column(
      children: [
        ImageContainer(
          imageUrl: imageUrl,
          imageName: imageName,
          onTap: onUpdate,
        ),
        const SizedBox(height: 6),
        Text(
          imageName.replaceAll('.jpg', '').replaceAll('_', ' '),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
