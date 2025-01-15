import 'package:adminpannal/Screens/Crops/crop_disease_section/widgets/system_language_card.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SymptomsScreen extends StatefulWidget {
  final String cropId;
  final String diseaseName;
  final String diseaseId;
  final String diseaseImage;
  const SymptomsScreen({
    super.key,
    required this.cropId,
    required this.diseaseName,
    required this.diseaseId,
    required this.diseaseImage,
  });

  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          '${widget.diseaseName} Symptoms',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('product')
            .doc(widget.cropId)
            .collection('Disease')
            .doc(widget.diseaseId)
            .collection('Symptoms')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          else if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return Center(
              child: Lottie.asset(
                'assets/images/loading.json',
                height: 140,
              ),
            );
          }
          else if (snapshot.data == null) {
            return const Center(
              child: Text(
                'No Data Available',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          else {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {

                var symptomDocId = snapshot.data.docs.first.id;

                var symptomData = snapshot.data?.docs[index].data();

                return Column(
                  children: languages.map((language) {

                    List<dynamic> symptom = symptomData?['${language.toLowerCase()}Symptoms'] ?? [];

                    return SystemLanguageCard(
                      symptomId: symptomDocId,
                      cropId: widget.cropId,
                      diseaseId: widget.diseaseId,
                      symptom: symptom,
                      symptomLanguage: language,
                    );
                  }).toList(),
                );
              },
            );
          }
        },
      ),
    );
  }

  List<String> languages = [
    'Bengali',
    'English',
    'Hindi',
    'Kannada',
    'Malayalam',
    'Marathi',
    'Odia',
    'Tamil',
    'Telugu',
  ];

}
