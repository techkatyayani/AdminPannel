import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CropDisposition extends StatefulWidget {
  const CropDisposition({super.key});

  @override
  State<CropDisposition> createState() => _CropDispositionState();
}

class _CropDispositionState extends State<CropDisposition> {
  List<DocumentSnapshot>? _docs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change crop's position"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("product").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Lottie.asset(
                  "assets/images/loading.json",
                  height: 140,
                );
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              _docs = snapshot.data!.docs;

              _docs!.sort((a, b) =>
                  int.parse(a['index']).compareTo(int.parse(b['index'])));

              return ReorderableListView(
                shrinkWrap: true,
                dragStartBehavior: DragStartBehavior.start,
                autoScrollerVelocityScalar: 20,
                onReorder: (int oldIndex, int newIndex) async {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final DocumentSnapshot item = _docs!.removeAt(oldIndex);
                  _docs!.insert(newIndex, item);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm"),
                        content: const Text(
                            "Are you sure you want to change the position of this item?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await _updateDocumentIndices();
                            },
                            child: const Text("Yes"),
                          ),
                        ],
                      );
                    },
                  );
                },
                children: List.generate(
                  _docs!.length,
                  (index) {
                    final DocumentSnapshot doc = _docs![index];
                    return Padding(
                      key: ValueKey(doc['index']),
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color.fromRGBO(38, 40, 55, 1),
                        ),
                        child: Row(
                          children: [
                            Text(
                              doc['index'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doc['Name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                // Text(
                                //   doc['collectionId'],
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _updateDocumentIndices() async {
    final batch = FirebaseFirestore.instance.batch();
    for (int i = 0; i < _docs!.length; i++) {
      final doc = _docs![i];
      batch.update(doc.reference, {'index': (i + 1).toString()});
    }
    await batch.commit();
  }
}
