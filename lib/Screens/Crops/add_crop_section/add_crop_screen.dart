import 'dart:typed_data';

import 'package:adminpannal/Screens/Crops/add_crop_section/widgets/crop_details_card.dart';
import 'package:adminpannal/Screens/Crops/add_crop_section/widgets/disease_details_card.dart';
import 'package:adminpannal/Screens/Crops/add_crop_section/widgets/state_details_card.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:adminpannal/common/custom_media_upload_card.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';

class AddCropScreen extends StatefulWidget {
  const AddCropScreen({super.key});

  @override
  State<AddCropScreen> createState() => _AddCropScreenState();
}

class _AddCropScreenState extends State<AddCropScreen> {

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leading: IconButton(
            onPressed: () {
              Utils.showConfirmBox(
                context: context,
                message: 'Are you sure to discard crop form..!! Your crop details will be lost.',
                onConfirm:  () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                onCancel: () {
                  Navigator.pop(context);
                },
                confirmText: 'Exit'
              );
            },
            icon: const Icon(
              Icons.arrow_back_sharp,
              color: Colors.white,
            )
          ),
          title: const Text(
            'Add Crop',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
          color: boxColor,
          child: PageView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: [
              CropDetailsCard(
                onNext: () {
                  pageController.jumpToPage(1);
                },
              ),
              DiseaseDetailsCard(
                onBack: () {
                  pageController.jumpToPage(0);
                },
                onNext: () {
                  pageController.jumpToPage(2);
                },
              ),
              StateDetailsCard(
                onBack: () {
                  pageController.jumpToPage(1);
                },
              )
            ],
          )
        ),
      ),
    );
  }
}

Widget customImageCard({
  required BuildContext context,
  required String title,
  String? mediaRatio,
  required VoidCallback onTap,
  required Uint8List? image,
  double? width,
  double? height,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),

      const SizedBox(height: 10),

      GestureDetector(
        onTap: onTap,
        child: Container(
          width: width,
          height: height ?? MediaQuery.of(context).size.height * 0.25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: Colors.white
            ),
          ),
          child: Center(
            child: image != null
                ?
            Image.memory(
              image,
              fit: BoxFit.fill,
              errorBuilder: (context, error, s) {
                return const Center(
                  child: Icon(
                    Icons.error,
                    color: Colors.white,
                  ),
                );
              },
            )
                :
            const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.upload,
                  color: Colors.white,
                  size: 40,
                ),

                Text(
                  "Upload Image",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      const SizedBox(height: 10),

      Text(
        mediaRatio ?? '',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color:  Colors.orangeAccent,
        ),
      )
    ],
  );
}