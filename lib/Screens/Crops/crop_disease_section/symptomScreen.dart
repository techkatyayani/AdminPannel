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
        title: Text(widget.diseaseName),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 4,
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: boxColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.height / 4,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 102, 84, 143),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: widget.diseaseImage.isNotEmpty
                      ? ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(5),
                            topLeft: Radius.circular(5),
                          ),
                          child: Image.network(
                            widget.diseaseImage,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.image,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.image,
                          color: Colors.white,
                        ),
                ),
                const SizedBox(width: 30),
                Column(
                  children: [
                    Text(
                      widget.diseaseName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: StreamBuilder(
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
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: Lottie.asset(
                        'assets/images/loading.json',
                        height: 140,
                      ),
                    );
                  } else if (snapshot.data == null) {
                    return const Center(
                      child: Text(
                        'No Data Available',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        var symptomDocId = snapshot.data.docs.first.id;
                        var symptomData = snapshot.data?.docs[index].data();
                        List<dynamic> englishSymptoms =
                            symptomData?['englishSymptoms'] ?? [];

                        List<dynamic> malayalamSymptoms =
                            symptomData?['malayalamSymptoms'] ?? [];

                        List<dynamic> tamilSymptoms =
                            symptomData?['tamilSymptoms'] ?? [];

                        List<dynamic> telunguSymptoms =
                            symptomData?['telunguSymptoms'] ?? [];
                        return Column(
                          children: [
                            SystemLanguageCard(
                              symptomId: symptomDocId,
                              cropId: widget.cropId,
                              diseaseId: widget.diseaseId,
                              symptomTitle: 'englishSymptoms',
                              symptom: englishSymptoms,
                              symptomLanguage: 'English',
                            ),
                            SystemLanguageCard(
                              symptomId: symptomDocId,
                              cropId: widget.cropId,
                              diseaseId: widget.diseaseId,
                              symptomTitle: 'malayalamSymptoms',
                              symptom: malayalamSymptoms,
                              symptomLanguage: 'Malayalam',
                            ),
                            SystemLanguageCard(
                              symptomId: symptomDocId,
                              cropId: widget.cropId,
                              diseaseId: widget.diseaseId,
                              symptomTitle: 'tamilSymptoms',
                              symptom: tamilSymptoms,
                              symptomLanguage: 'Tamil',
                            ),
                            SystemLanguageCard(
                              symptomId: symptomDocId,
                              cropId: widget.cropId,
                              diseaseId: widget.diseaseId,
                              symptomTitle: 'telunguSymptoms',
                              symptom: telunguSymptoms,
                              symptomLanguage: 'Telungu',
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
