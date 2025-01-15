import 'package:adminpannal/Screens/Crops/crop_disease_section/controller/disease_controller.dart';
import 'package:adminpannal/Screens/Crops/crop_disease_section/symptomScreen.dart';
import 'package:adminpannal/config/responsive/responsive.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class DiseaseCard extends StatelessWidget {
  final String cropId;
  final String diseaseName;
  final String diseaseId;
  final String diseaseImage;
  final Size size;
  const DiseaseCard({
    super.key,
    required this.cropId,
    required this.diseaseName,
    required this.diseaseId,
    required this.size,
    required this.diseaseImage,
  });

  navigateToSymptomsScreen(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(
        child: SymptomsScreen(
          diseaseImage: diseaseImage,
          cropId: cropId,
          diseaseName: diseaseName,
          diseaseId: diseaseId,
        ),
        type: PageTransitionType.topToBottom,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<DiseaseController>(builder: (context, provider, child) {
      return GestureDetector(
        onTap: () {
          navigateToSymptomsScreen(context);
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
                      width: MediaQuery.of(context).size.width,
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

                      navigateToSymptomsScreen(context);

                      // _showUpdateDialog(
                      //   snapshot.data!.docs[index].id,
                      //   snapshot.data!.docs[index]['Name'],
                      //   snapshot.data!.docs[index]['Image'],
                      //   snapshot.data!.docs[index]['id'],
                      // );

                      // provider.showUpdateDialog(
                      //     documentId,
                      //     currentName,
                      //     currentImageUrl,
                      //     currentId,
                      //     cropId,
                      //     imageBytes,
                      //     context);
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
    });
  }
}
