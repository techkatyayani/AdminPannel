import 'package:adminpannal/Screens/Crops/controller/crop_provider.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:adminpannal/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../add_crop_screen.dart';

class CropDetailsCard extends StatelessWidget {

  final VoidCallback onNext;

  const CropDetailsCard({super.key, required this.onNext});

  final String message = "Enter basic crop details first. To add more details by language, complete the 'Add Crop' form, then edit as needed";

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
                    mediaRatio: 'Check on app at crop screen',
                    onTap: () async {
                      Uint8List? image = await provider.pickImage();
                      provider.setSelectedCropImage(image);
                    },
                    image: provider.selectedCropImage,
                  ),

                  customImageCard(
                    context: context,
                    title: 'Crop English Banner Image',
                    mediaRatio: 'Check on app at crop disease screen',
                    onTap: () async {
                      Uint8List? image = await provider.pickImage();
                      provider.setSelectedEnglishBannerImage(image);
                    },
                    image: provider.selectedEnglishBannerImage,
                  ),

                  customImageCard(
                      context: context,
                      title: 'Crop Hindi Banner Image',
                      mediaRatio: 'Check on app at crop disease screen',
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    // 'You can add only basic details of crop. To enter more details based on language please first fill add crop form then edit required details for respective crop.',
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                TextButton.icon(
                  onPressed: () {

                    if (provider.newCropNameController.text.isEmpty) {
                      Utils.showSnackBar(context: context, message: 'Please enter crop name..!!');
                      return;
                    }
                    else if (provider.totalDurationOfNewCrop.text.isEmpty) {
                      Utils.showSnackBar(context: context, message: 'Please enter total duration of crop..!!');
                      return;
                    } else if (provider.selectedCropImage == null) {
                      Utils.showSnackBar(context: context, message: 'Please select Crop Image..!!');
                      return;
                    } else if (provider.selectedEnglishBannerImage == null ||provider.selectedHindiBannerImage == null ) {
                      Utils.showSnackBar(context: context, message: 'Please select Crop Banner Images..!!');
                      return;
                    }

                    onNext.call();
                  },
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
