import 'package:adminpannal/Screens/HomeLayout/homelayout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class ProductCollectionScreen extends StatefulWidget {
  const ProductCollectionScreen({super.key});

  @override
  State<ProductCollectionScreen> createState() =>
      _ProductCollectionScreenState();
}

class _ProductCollectionScreenState extends State<ProductCollectionScreen> {
  List<DocumentSnapshot>? _docs; // Store the documents in a list

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                PageTransition(
                    child: const HomeScreenLayout(),
                    type: PageTransitionType.fade),
              ),
              child: const Text(
                "+ Add Collection",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("HomeLayout")
                .orderBy('id') // Order by id
                .snapshots(),
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

              _docs = snapshot.data!.docs; // Store the documents

              return ReorderableListView(
                shrinkWrap: true,
                dragStartBehavior: DragStartBehavior.start,
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
                      key: ValueKey(doc.id),
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
                              doc['id'],
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
                                  doc['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  doc['collectionId'],
                                ),
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
        ],
      ),
    );
  }

  Future<void> _updateDocumentIndices() async {
    final batch = FirebaseFirestore.instance.batch();
    for (int i = 0; i < _docs!.length; i++) {
      final doc = _docs![i];
      batch.update(doc.reference, {'id': (i + 1).toString()});
    }
    await batch.commit();
  }
}
