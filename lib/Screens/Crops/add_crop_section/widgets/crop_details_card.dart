import 'dart:typed_data';

import 'package:adminpannal/Screens/Crops/controller/crop_provider.dart';
import 'package:adminpannal/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../add_crop_screen.dart';

class CropDetailsCard extends StatelessWidget {

  final VoidCallback onNext;

  const CropDetailsCard({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Consumer<CropProvider>(
      builder: (BuildContext context, CropProvider provider, Widget? child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Crop Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),

            const SizedBox(height: 15),

            const Divider(),

            const SizedBox(height: 15),

            CustomTextField(
              controller: provider.newCropNameController,
              labelText: 'Crop Name',
            ),

            const SizedBox(height: 5),

            CustomTextField(
              controller: provider.totalDurationOfNewCrop,
              labelText: 'Total Duration',
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              suffix: const Text(
                'in Days',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                padding: EdgeInsets.zero,
                // shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  customImageCard(
                    context: context,
                    title: 'Crop Image',
                    onTap: () async {
                      Uint8List? image = await provider.pickImage();
                      provider.setSelectedCropImage(image);
                    },
                    image: provider.selectedCropImage,
                  ),

                  customImageCard(
                    context: context,
                    title: 'Crop English Banner Image',
                    onTap: () async {
                      Uint8List? image = await provider.pickImage();
                      provider.setSelectedEnglishBannerImage(image);
                    },
                    image: provider.selectedEnglishBannerImage,
                  ),

                  customImageCard(
                      context: context,
                      title: 'Crop Hindi Banner Image',
                      onTap: () async {
                        Uint8List? image = await provider.pickImage();
                        provider.setSelectedHindiBannerImage(image);
                      },
                      image: provider.selectedHindiBannerImage
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onNext,
                  label: const Text(
                    'Next',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                    ),
                  ),
                  iconAlignment: IconAlignment.end,
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }
}
