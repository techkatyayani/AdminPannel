import 'package:adminpannal/Screens/Crops/controller/crop_provider.dart';

import 'package:adminpannal/Screens/Crops/crop_disease_section/symptomScreen.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:adminpannal/common/custom_media_upload_card.dart';
import 'package:adminpannal/common/custom_text_field.dart';
import 'package:adminpannal/config/responsive/responsive.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class DiseaseCard extends StatelessWidget {

  final String cropId;
  final Map<String, dynamic> diseaseData;
  final CropProvider provider;
  final Size size;

  const DiseaseCard({
    super.key,
    required this.cropId,
    required this.diseaseData,
    required this.provider,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {

    String diseaseName = diseaseData['Name'] ?? '';
    String diseaseImage = diseaseData['Image'] ?? '';
    String collectionId = diseaseData['id'] ?? '';

    String bengaliName = diseaseData['name_bn'] ?? '';
    String englishName = diseaseData['name_en'] ?? '';
    String hindiName = diseaseData['name_hi'] ?? '';
    String kannadaName = diseaseData['name_kn'] ?? '';
    String malayalamName = diseaseData['name_ml'] ?? '';
    String marathiName = diseaseData['name_mr'] ?? '';
    String oriyaName = diseaseData['name_or'] ?? '';
    String tamilName = diseaseData['name_ta'] ?? '';
    String teluguName = diseaseData['name_tl'] ?? '';


    return Consumer<CropProvider>(
        builder: (BuildContext context, CropProvider provider, child) {
          return GestureDetector(
            onTap: () {
              String diseaseName = diseaseData['Name'] ?? '';
              String diseaseImage = diseaseData['Image'] ?? '';
              String diseaseId = diseaseData['docId'] ?? '';

              Navigator.push(
                context,
                PageTransition(
                  child: SymptomsScreen(
                    cropId: cropId,
                    diseaseImage: diseaseImage,
                    diseaseName: diseaseName,
                    diseaseId: diseaseId,
                  ),
                  type: PageTransitionType.topToBottom,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 3,
                      offset: const Offset(2, 2),
                    ),
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 3,
                      offset: const Offset(-2, -2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(22),
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: ResponsiveBuilder.isDesktop(context)
                              ? size.width * .1
                              : size.width * .25,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22.0),
                            child: Image(
                              image: NetworkImage(
                                diseaseImage,
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),

                        const SizedBox(height: krishiSpacing),

                        Text(
                          diseaseName,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              height: 0,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),

                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          provider.initLanguageFields(
                            bengaliName: bengaliName,
                            englishName: englishName,
                            hindiName: hindiName,
                            kannadaName: kannadaName,
                            malayalamName: malayalamName,
                            marathiName: marathiName,
                            oriyaName: oriyaName,
                            tamilName: tamilName,
                            teluguName: teluguName
                          );

                          provider.initDiseaseDetailsDialog(
                              diseaseName: diseaseName,
                              collectionId: collectionId,
                              diseaseImage: diseaseImage
                          );

                          showEditDiseaseDetailsDialog(
                              context: context
                          );
                        },
                        child: Container(
                          width: ResponsiveBuilder.isDesktop(context)
                              ? size.width * .04
                              : size.width * .15,
                          height: ResponsiveBuilder.isDesktop(context)
                              ? size.width * .02
                              : size.width * .05,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(10),
                            ),
                            color: Colors.black.withOpacity(.8),
                          ),
                          child: const Center(
                            child: Text("Edit"),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  showEditDiseaseDetailsDialog({
    required BuildContext context,
  }) {
    final formKey = GlobalKey<FormState>();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Form(
            key: formKey,
            child: Dialog(
              child: Consumer<CropProvider>(
                builder: (BuildContext context, CropProvider provider,
                    Widget? child) {
                  return Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.75,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.9,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [

                          const Text(
                            'Edit Disease Details',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),

                          const SizedBox(height: 15),

                          Row(
                            children: [
                              Flexible(
                                child: Column(
                                  children: [
                                    CustomTextField(
                                      controller: provider
                                          .diseaseNameController,
                                      labelText: 'Disease Name',
                                      enabled: false,
                                    ),

                                    CustomTextField(
                                      controller: provider
                                          .collectionIdController,
                                      labelText: 'Collection Id',
                                    ),
                                  ],
                                ),
                              ),

                              InkWell(
                                  onTap: provider.pickDiseaseImage,
                                  child: provider.pickedDiseaseImage != null
                                      ?
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.memory(
                                      provider.pickedDiseaseImage!,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.25,
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.25,
                                    ),
                                  )
                                      :
                                  provider.diseaseImageUrl != null
                                      ?
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      provider.diseaseImageUrl!,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.25,
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.25,
                                    ),
                                  )
                                      :
                                  CustomMediaUploadCard(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.175,
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.175,
                                    mediaRatio: '',
                                  )
                              ),
                            ],
                          ),

                          const SizedBox(width: 25),

                          CustomTextField(
                            controller: provider.bengaliNameController,
                            labelText: 'Bengali Disease Name',
                          ),

                          const SizedBox(height: 10),

                          CustomTextField(
                            controller: provider.englishNameController,
                            labelText: 'English Disease Name',
                          ),

                          const SizedBox(height: 10),

                          CustomTextField(
                            controller: provider.hindiNameController,
                            labelText: 'Hindi Disease Name',
                          ),

                          const SizedBox(height: 10),

                          CustomTextField(
                            controller: provider.kannadaNameController,
                            labelText: 'Kannada Disease Name',
                          ),

                          const SizedBox(height: 10),

                          CustomTextField(
                            controller: provider.malayalamNameController,
                            labelText: 'Malayalam Disease Name',
                          ),

                          const SizedBox(height: 10),

                          CustomTextField(
                            controller: provider.marathiNameController,
                            labelText: 'Marathi Disease Name',
                          ),

                          const SizedBox(height: 10),

                          CustomTextField(
                            controller: provider.oriyaNameController,
                            labelText: 'Oriya Disease Name',
                          ),

                          const SizedBox(height: 10),

                          CustomTextField(
                            controller: provider.tamilNameController,
                            labelText: 'Tamil Disease Name',
                          ),

                          const SizedBox(height: 10),

                          CustomTextField(
                            controller: provider.teluguNameController,
                            labelText: 'Telugu Disease Name',
                          ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  minimumSize: const Size(100, 45),
                                ),
                                onPressed: () {
                                  provider.clearDiseaseDetailsDialog();
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 20),

                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                      255, 102, 84, 143),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  minimumSize: const Size(100, 45),
                                ),
                                onPressed: () async {
                                  if (provider.diseaseImageUrl == null &&
                                      provider.pickedDiseaseImage == null) {
                                    Utils.showSnackBar(context: context,
                                        message: 'Please select a disease image..!!');
                                    return;
                                  }

                                  if (formKey.currentState!.validate()) {
                                    Utils.showLoadingBox(context: context,
                                        title: 'Updating Disease Details...');

                                    String diseaseId = diseaseData['docId'] ?? '';

                                    bool status = await provider.updateDiseaseDetails(
                                        cropId: cropId,
                                        diseaseId: diseaseId
                                    );

                                    Navigator.pop(context);
                                    Navigator.pop(context);

                                    if (status) {
                                      Utils.showSnackBar(context: context,
                                          message: 'Disease Details Updated Successfully :)');
                                    } else {
                                      Utils.showSnackBar(context: context,
                                          message: 'Failed to update disease details..!!');
                                    }
                                  }
                                },
                                child: const Text(
                                  'Update',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
    );
  }
}
