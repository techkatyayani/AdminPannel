import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SymptomsScreen extends StatefulWidget {
  final String cropId;
  final String diseaseName;
  final String diseaseId;
  const SymptomsScreen({
    super.key,
    required this.cropId,
    required this.diseaseName,
    required this.diseaseId,
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
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset(
                'assets/images/loading.json',
                height: 140,
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      // for (int i = 1; i <= 2; i++)
                      //   Text(
                      //     "s$i" + snapshot.data.docs[index]['s$i'],
                      //   ),
                    ],
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
