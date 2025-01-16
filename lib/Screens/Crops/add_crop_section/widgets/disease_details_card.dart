import 'package:adminpannal/Screens/Crops/controller/crop_provider.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:adminpannal/common/custom_text_field.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../add_crop_screen.dart';

class DiseaseDetailsCard extends StatelessWidget {

  final VoidCallback onBack;

  const DiseaseDetailsCard({super.key, required this.onBack});

  final String message = "Please add disease details. Symptoms based on language shall be added in disease details after the crop is created";

  @override
  Widget build(BuildContext context) {
    return Consumer<CropProvider>(
      builder: (BuildContext context, CropProvider provider, Widget? child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Disease Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),

            const SizedBox(height: 15),

            const Divider(),

            const SizedBox(height: 15),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                customImageCard(
                  context: context,
                  title: 'Disease Image',
                  onTap: () async {
                    Uint8List? image = await provider.pickImage();
                    provider.setSelectedDiseaseImage(image);
                  },
                  image: provider.selectedDiseaseImage,
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.width * 0.1,
                ),

                const SizedBox(width: 25),

                Expanded(
                  child: Column(
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              if (provider.newDiseaseNameController.text.isEmpty){
                                Utils.showSnackBar(context: context, message: 'Please Enter Disease Name..!!');
                                return;
                              }
                              else if (provider.newCropCollectionIdController.text.isEmpty){
                                Utils.showSnackBar(context: context, message: 'Please Enter Collection Id..!!');
                                return;
                              }
                              else if (provider.selectedDiseaseImage == null){
                                Utils.showSnackBar(context: context, message: 'Please Select Disease Image..!!');
                                return;
                              }

                              Map<String, dynamic> data = {
                                'name': provider.newDiseaseNameController.text.trim(),
                                'collectionId': provider.newCropCollectionIdController.text.trim(),
                                'image': provider.selectedDiseaseImage!,
                              };

                              provider.addDiseaseDetails(data);
                            },
                            child: const Text(
                              'Add',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      CustomTextField(
                        controller: provider.newDiseaseNameController,
                        labelText: 'Disease Name',
                      ),

                      const SizedBox(height: 10),
                  
                      CustomTextField(
                        controller: provider.newCropCollectionIdController,
                        labelText: 'Collection Id',
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),

                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            provider.diseaseDetails.isEmpty
                ?
            const Expanded(
              child: Center(
               child: Text(
                 'No Disease Details yet..!!',
                 style: TextStyle(
                   fontSize: 16,
                   fontWeight: FontWeight.w500,
                   color: Colors.white70,
                 ),
               ),
              ),
            )
                :
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: provider.diseaseDetails.length,
                itemBuilder: (context, index) {

                  Map<String, dynamic> details = provider.diseaseDetails[index];

                  return _diseaseDetailsCard(
                    context: context,
                    name: details['name'] ?? '',
                    image: details['image'] ?? '',
                    collectionId: details['collectionId'] ?? '',
                    onDelete: () {
                      provider.removeDiseaseDetails(index);
                    }
                  );
                }
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: onBack,
                  label: const Text(
                    'Back',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                    ),
                  ),
                  iconAlignment: IconAlignment.start,
                  icon: const Icon(
                    Icons.arrow_back_sharp,
                    color: Colors.white,
                  ),
                ),

                Flexible(
                  child: Text(
                    // 'Please add Disease Details. You can add disease details only, try to add respective disease symptoms after completing the crop creation process.',
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

                TextButton(
                  onPressed: () async {
                    if (provider.diseaseDetails.isEmpty) {
                      Utils.showSnackBar(context: context, message: 'Please Enter at least one Disease Details..!!');
                      return;
                    }

                    Utils.showLoadingBox(context: context, title: 'Saving Crop Details...');

                    bool status = await provider.addNewCrop();

                    Navigator.pop(context);

                    if (status) {
                      Utils.showSnackBar(context: context, message: 'New Crop Added Successfully :)');
                      Navigator.pop(context);
                    } else {
                      Utils.showSnackBar(context: context, message: 'Failed to Add New Crop..!!');
                    }


                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _diseaseDetailsCard({
    required BuildContext context,
    required String name,
    required String collectionId,
    required Uint8List? image,
    required VoidCallback onDelete,
  }) {
    return Card(
      color: canvasColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Disease Name : ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),

                      TextSpan(
                        text: name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      )
                    ]
                  )
                ),

                const SizedBox(height: 10),

                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Collection Id : ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),

                      TextSpan(
                        text: collectionId,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      )
                    ]
                  )
                ),
              ],
            ),

            const SizedBox(width: 35),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.width * 0.075,
              child: image != null
                  ?
              Image.memory(
                image,
                errorBuilder: (_, e, s) {
                  return const Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.white,
                    ),
                  );
                },
              )
                  :
              const Center(
                child: Icon(
                  Icons.photo,
                  color: Colors.white,
                ),
              ),
            ),

            const Spacer(),

            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              )
            ),
          ],
        ),
      ),
    );
  }
}
