import 'dart:developer';

import 'package:adminpannal/Screens/Crops/controller/crop_provider.dart';
import 'package:adminpannal/Screens/crop_stage/crop_stage_screen.dart';
import 'package:adminpannal/Utils/utils.dart';
import 'package:adminpannal/common/custom_media_upload_card.dart';
import 'package:adminpannal/common/custom_text_field.dart';
import 'package:adminpannal/config/responsive/responsive.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'cropCalenderScreen.dart';
import 'widgets/disease_card.dart';

class SubCropsScreen extends StatefulWidget {

  final String cropName;
  final String cropId;

  const SubCropsScreen({
    super.key,
    required this.cropName,
    required this.cropId,
  });

  @override
  State<SubCropsScreen> createState() => _SubCropsScreenState();
}

class _SubCropsScreenState extends State<SubCropsScreen> {

  late CropProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<CropProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cropName),
        scrolledUnderElevation: 0,
        actions: [
          ElevatedButton(
          onPressed: () {

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CropStageScreen(
                cropName: widget.cropName,
                cropId: widget.cropId,
              ))
            );
          },
          child: const Text(
            "Crop Stages",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

          const SizedBox(width: 15),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  child: CropCalanderScreen(
                      cropName: widget.cropName,
                      cropId: widget.cropId,
                      language: "English"),
                  type: PageTransitionType.fade,
                ),
              );
            },
            child: const Text(
              "Crop Calendar English",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(width: 15),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  child: CropCalanderScreen(
                      cropName: widget.cropName,
                      cropId: widget.cropId,
                      language: "Hindi"),
                  type: PageTransitionType.fade,
                ),
              );
            },
            child: const Text(
              "Crop Calendar Hindi",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('product')
                    .doc(widget.cropId)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Container();
                  } else {
                    return Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          ResponsiveBuilder.isDesktop(context)
                                              ? size.width * .12
                                              : size.width * .2,
                                      width: double.infinity,
                                      child: Image.network(
                                        snapshot.data['image2'],
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      "English Banner",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      _updateTopImage('image2');
                                    },
                                    child: Container(
                                      width:
                                          ResponsiveBuilder.isDesktop(context)
                                              ? size.width * .1
                                              : size.width * .15,
                                      height:
                                          ResponsiveBuilder.isDesktop(context)
                                              ? size.width * .03
                                              : size.width * .06,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        color: Colors.black.withOpacity(.8),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Edit",
                                          style: TextStyle(
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
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: ResponsiveBuilder.isDesktop(context)
                                        ? size.width * .12
                                        : size.width * .2,
                                    width: double.infinity,
                                    child: Image.network(
                                      snapshot.data['hindiimage2'] ??
                                          imagePlaceholder,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    "Hindi Banner",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    _updateTopImage('hindiimage2');
                                  },
                                  child: Container(
                                    width: ResponsiveBuilder.isDesktop(context)
                                        ? size.width * .1
                                        : size.width * .15,
                                    height: ResponsiveBuilder.isDesktop(context)
                                        ? size.width * .03
                                        : size.width * .06,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                      ),
                                      color: Colors.black.withOpacity(.8),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Edit",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [

                  Container(
                    width: 25,
                    height: 1.25,
                    color: Colors.white,
                  ),

                  const SizedBox(width: 10),

                  Text(
                    '${widget.cropName} Crop Diseases',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),

                  const SizedBox(width: 10),

                  Flexible(
                    child: Container(
                      height: 1.25,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('product')
                  .doc(widget.cropId)
                  .collection('Disease')
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Lottie.asset(
                      'assets/images/loading.json',
                      height: 140,
                    ),
                  );
                }
                else {
                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveBuilder.isDesktop(context) ? 6 : 2,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {

                      Map<String, dynamic> diseaseData = snapshot.data!.docs[index].data();

                      diseaseData['docId'] = snapshot.data!.docs[index].id;

                      return DiseaseCard(
                        cropId: widget.cropId,
                        diseaseData: diseaseData,
                        size: size,
                        provider: provider,
                      );
                    },
                  );
                }
              },
            ),

            // StreamBuilder(
            //   stream: FirebaseFirestore.instance
            //       .collection('product')
            //       .doc(widget.cropId)
            //       .collection('Disease')
            //       .snapshots(),
            //   builder: (BuildContext context, AsyncSnapshot snapshot) {
            //     if (snapshot.hasError) {
            //       return Text('Error: ${snapshot.error}');
            //     } else if (snapshot.connectionState ==
            //         ConnectionState.waiting) {
            //       return Center(
            //         child: Lottie.asset(
            //           'assets/images/loading.json',
            //           height: 140,
            //         ),
            //       );
            //     } else {
            //       return GridView.builder(
            //         physics: const NeverScrollableScrollPhysics(),
            //         shrinkWrap: true,
            //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //           crossAxisCount:
            //               ResponsiveBuilder.isDesktop(context) ? 6 : 2,
            //           mainAxisSpacing: 10,
            //         ),
            //         itemCount: snapshot.data.docs.length,
            //         itemBuilder: (BuildContext context, int index) {
            //           Map<String, dynamic> diseaseData =
            //               snapshot.data!.docs[index].data();
            //           return GestureDetector(
            //             onTap: () {
            //               Navigator.push(
            //                 context,
            //                 PageTransition(
            //                   child: SymptomsScreen(
            //                     cropId: widget.cropId,
            //                     diseaseName: diseaseData['Name'],
            //                     diseaseId: snapshot.data.docs[index].id,
            //                   ),
            //                   type: PageTransitionType.topToBottom,
            //                 ),
            //               );
            //             },
            //             child: Padding(
            //               padding: const EdgeInsets.all(12.0),
            //               child: Container(
            //                 decoration: BoxDecoration(
            //                   boxShadow: [
            //                     BoxShadow(
            //                       color: Colors.grey.withOpacity(0.1),
            //                       blurRadius: 3,
            //                       offset: const Offset(2, 2),
            //                     ),
            //                     BoxShadow(
            //                       color: Colors.grey.withOpacity(0.1),
            //                       blurRadius: 3,
            //                       offset: const Offset(-2, -2),
            //                     ),
            //                   ],
            //                   borderRadius: BorderRadius.circular(22),
            //                   color: Colors.white,
            //                 ),
            //                 child: Stack(
            //                   children: [
            //                     Column(
            //                       children: [
            //                         Container(
            //                           height:
            //                               ResponsiveBuilder.isDesktop(context)
            //                                   ? size.width * .1
            //                                   : size.width * .25,
            //                           width: MediaQuery.of(context).size.width,
            //                           margin: const EdgeInsets.all(10),
            //                           decoration: BoxDecoration(
            //                             borderRadius:
            //                                 BorderRadius.circular(22.0),
            //                           ),
            //                           child: ClipRRect(
            //                             borderRadius:
            //                                 BorderRadius.circular(22.0),
            //                             child: Image(
            //                               image: NetworkImage(
            //                                 diseaseData['Image'],
            //                               ),
            //                               fit: BoxFit.fill,
            //                             ),
            //                           ),
            //                         ),
            //                         const SizedBox(height: krishiSpacing),
            //                         Text(
            //                           diseaseData['Name'],
            //                           style: const TextStyle(
            //                               color: Colors.black,
            //                               fontSize: 16,
            //                               fontFamily: 'Poppins',
            //                               fontWeight: FontWeight.w600,
            //                               height: 0,
            //                               overflow: TextOverflow.ellipsis),
            //                         ),
            //                       ],
            //                     ),
            //                     Positioned(
            //                       top: 0,
            //                       right: 0,
            //                       child: GestureDetector(
            //                         onTap: () {
            //                           _showUpdateDialog(
            //                             snapshot.data!.docs[index].id,
            //                             snapshot.data!.docs[index]['Name'],
            //                             snapshot.data!.docs[index]['Image'],
            //                             snapshot.data!.docs[index]['id'],
            //                           );
            //                         },
            //                         child: Container(
            //                           width:
            //                               ResponsiveBuilder.isDesktop(context)
            //                                   ? size.width * .04
            //                                   : size.width * .15,
            //                           height:
            //                               ResponsiveBuilder.isDesktop(context)
            //                                   ? size.width * .02
            //                                   : size.width * .05,
            //                           decoration: BoxDecoration(
            //                             borderRadius: const BorderRadius.only(
            //                               topRight: Radius.circular(20),
            //                               bottomLeft: Radius.circular(10),
            //                             ),
            //                             color: Colors.black.withOpacity(.8),
            //                           ),
            //                           child: const Center(
            //                             child: Text("Edit"),
            //                           ),
            //                         ),
            //                       ),
            //                     )
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           );
            //         },
            //       );
            //     }
            //   },
            // ),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          showAddDiseaseDialog(context: context);
        },
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  showAddDiseaseDialog({
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
                            'Add Disease',
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
                                    ),

                                    CustomTextField(
                                      controller: provider.collectionIdController,
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
                                        title: 'Adding Disease Details...');

                                    bool status = await provider.addDisease(
                                      cropId: widget.cropId,
                                    );

                                    Navigator.pop(context);
                                    Navigator.pop(context);

                                    if (status) {
                                      Utils.showSnackBar(context: context,
                                          message: 'Disease Details Added Successfully :)');
                                    } else {
                                      Utils.showSnackBar(context: context,
                                          message: 'Failed to add disease details..!!');
                                    }
                                  }
                                },
                                child: const Text(
                                  'Add',
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

  Future<void> _updateTopImage(String imageName) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('product_images')
          .child('${widget.cropId}$imageName.jpg');
      Uint8List uint8List = result.files.single.bytes!;
      UploadTask uploadTask = ref.putData(uint8List);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('product')
          .doc(widget.cropId)
          .update({
        imageName: imageUrl,
      });
    }
  }
}
