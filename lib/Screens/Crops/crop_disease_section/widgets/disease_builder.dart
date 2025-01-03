import 'package:adminpannal/Screens/Crops/crop_disease_section/widgets/disease_card.dart';
import 'package:adminpannal/config/responsive/responsive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DiseaseBuilder extends StatelessWidget {
  final String cropId;
  final Size size;
  const DiseaseBuilder({
    super.key,
    required this.cropId,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('product')
          .doc(cropId)
          .collection('Disease')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
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
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveBuilder.isDesktop(context) ? 6 : 2,
              mainAxisSpacing: 10,
            ),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> diseaseData =
                  snapshot.data!.docs[index].data();
              return DiseaseCard(
                cropId: cropId,
                diseaseName: diseaseData['Name'],
                diseaseId: snapshot.data.docs[index].id,
                size: size,
                diseaseImage: diseaseData['Image'],
              );
            },
          );
        }
      },
    );
  }
}
