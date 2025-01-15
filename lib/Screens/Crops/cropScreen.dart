import 'package:adminpannal/Screens/Crops/addCropsForm.dart';
import 'package:adminpannal/Screens/Crops/add_crop_section/add_crop_screen.dart';
import 'package:adminpannal/Screens/Crops/controller/crop_provider.dart';
import 'package:adminpannal/Screens/Crops/cropDisposition.dart';
import 'package:adminpannal/Screens/Crops/subCropsScreen.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:adminpannal/common/custom_media_upload_card.dart';
import 'package:adminpannal/common/custom_text_field.dart';
import 'package:adminpannal/config/responsive/responsive.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class CropScreen extends StatefulWidget {
  const CropScreen({super.key});

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {

  late CropProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<CropProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Column(
      children: [

        const SizedBox(height: krishiSpacing),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: const CropDisposition(),
                        type: PageTransitionType.fade,
                      ),
                    );
                  },
                  child: const Text(
                    "Change Position",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        // child: const AddCropsForm(),
                        child: const AddCropScreen(),
                        type: PageTransitionType.fade,
                      ),
                    );
                  },
                  child: const Text(
                    "Add Crops",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('product').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset(
                  'assets/images/loading.json',
                  height: 140,
                ),
              );
            } else {

              List<DocumentSnapshot<Map<String, dynamic>>> docs = snapshot.data!.docs;

              docs.sort((a, b) => int.parse(a['index']).compareTo(int.parse(b['index'])));

              return Padding(
                padding: const EdgeInsets.only(
                    top: krishiSpacing,
                    left: krishiSpacing,
                    right: krishiSpacing,
                    bottom: krishiSpacing),
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                    ResponsiveBuilder.isDesktop(context) ? 5 : 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    mainAxisExtent: ResponsiveBuilder.isDesktop(context)
                        ? size.width * .12
                        : size.width * .25,
                  ),
                  shrinkWrap: true,
                  itemCount: docs.length,
                  itemBuilder: (BuildContext context, int index) {

                    if (docs[index].data() == null) {
                      return const SizedBox();
                    }

                    Map<String, dynamic> cropData = docs[index].data()!;

                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                  child: SubCropsScreen(
                                    cropName: cropData['Name'],
                                    cropId: docs[index].id,
                                  ),
                                  type: PageTransitionType.topToBottom
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: ResponsiveBuilder.isDesktop(context)
                                      ? size.width * .08
                                      : size.width * .2,
                                  child: Image.network(
                                    cropData['Image'],
                                  ),
                                ),
                                Text(
                                  cropData['Name'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {

                              String bengaliName = cropData['name_bn'] ?? '';
                              String englishName = cropData['name_en'] ?? '';
                              String hindiName = cropData['name_hi'] ?? '';
                              String kannadaName = cropData['name_kn'] ?? '';
                              String malayalamName = cropData['name_ml'] ?? '';
                              String marathiName = cropData['name_mr'] ?? '';
                              String oriyaName = cropData['name_or'] ?? '';
                              String tamilName = cropData['name_ta'] ?? '';
                              String teluguName = cropData['name_tl'] ?? '';

                              provider.initLanguageFields(
                                bengaliName: bengaliName,
                                englishName: englishName,
                                hindiName: hindiName,
                                kannadaName: kannadaName,
                                malayalamName: malayalamName,
                                marathiName: marathiName,
                                oriyaName: oriyaName,
                                tamilName: tamilName,
                                teluguName: teluguName,
                              );

                              provider.initCropDetailsDialog(
                                cropName: cropData['Name'] ?? '',
                                cropImage: cropData['Image'] ?? '',
                              );

                              showEditCropDetailsDialog(
                                cropId: docs[index].id
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
                                color: Colors.black.withOpacity(.5),
                              ),
                              child: const Center(
                                child: Text("Edit"),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }

  showEditCropDetailsDialog({
    required String cropId,
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
                            'Edit Crop Details',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),

                          const SizedBox(height: 15),

                          InkWell(
                              onTap: provider.pickCropImage,
                              child: provider.pickedCropImage != null
                                  ?
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(
                                  provider.pickedCropImage!,
                                  width: double.maxFinite,
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.25,
                                ),
                              )
                                  :
                              provider.cropImageUrl != null
                                  ?
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  provider.cropImageUrl!,
                                  width: double.maxFinite,
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
                              )
                          ),

                          const SizedBox(width: 25),

                          CustomTextField(
                            controller: provider.cropNameController,
                            labelText: 'Crop Name',
                            enabled: false,
                          ),

                          const SizedBox(height: 10),

                          CustomTextField(
                            controller: provider.bengaliNameController,
                            labelText: 'Bengali Crop Name',
                          ),

                          const SizedBox(height: 10),

                          CustomTextField(
                            controller: provider.englishNameController,
                            labelText: 'English Crop Name',
                          ),

                          const SizedBox(height: 10),

                          CustomTextField(
                            controller: provider.hindiNameController,
                            labelText: 'Hindi Crop Name',
                          ),

                          const SizedBox(height: 10),

                          CustomTextField(
                            controller: provider.kannadaNameController,
                            labelText: 'Kannada Crop Name',
                          ),

                          const SizedBox(height: 10),

                          CustomTextField(
                            controller: provider.malayalamNameController,
                            labelText: 'Malayalam Crop Name',
                          ),

                          const SizedBox(height: 10),

                          CustomTextField(
                            controller: provider.marathiNameController,
                            labelText: 'Marathi Crop Name',
                          ),

                          const SizedBox(height: 10),

                          CustomTextField(
                            controller: provider.oriyaNameController,
                            labelText: 'Oriya Crop Name',
                          ),

                          const SizedBox(height: 10),

                          CustomTextField(
                            controller: provider.tamilNameController,
                            labelText: 'Tamil Crop Name',
                          ),

                          const SizedBox(height: 10),

                          CustomTextField(
                            controller: provider.teluguNameController,
                            labelText: 'Telugu Crop Name',
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
                                  provider.clearCropDetailsDialog();
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
                                  if (provider.cropImageUrl == null &&
                                      provider.pickedCropImage == null) {
                                    Utils.showSnackBar(context: context,
                                        message: 'Please select a crop image..!!');
                                    return;
                                  }

                                  if (formKey.currentState!.validate()) {
                                    Utils.showLoadingBox(context: context,
                                        title: 'Updating Crop Details...');

                                    bool status = await provider
                                        .updateCropDetails(
                                        cropId: cropId
                                    );

                                    Navigator.pop(context);
                                    Navigator.pop(context);

                                    if (status) {
                                      Utils.showSnackBar(context: context,
                                          message: 'Crop Details Updated Successfully :)');
                                    } else {
                                      Utils.showSnackBar(context: context,
                                          message: 'Failed to update crop details..!!');
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
