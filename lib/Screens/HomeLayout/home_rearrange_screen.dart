import 'package:adminpannal/Screens/HomeLayout/homelayout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class HomeRearrangeScreen extends StatefulWidget {
  const HomeRearrangeScreen({super.key});

  @override
  State<HomeRearrangeScreen> createState() => _HomeRearrangeScreenState();
}

class _HomeRearrangeScreenState extends State<HomeRearrangeScreen> {
  List<DocumentSnapshot<Map<String, dynamic>>> _docs = [];

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

          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("HomeLayout")
                .orderBy('index')
                .snapshots(),

            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Lottie.asset(
                  "assets/images/loading.json",
                  height: 140,
                );
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text("No data found");
              }

              _docs = snapshot.data!.docs;

              return ReorderableListView(
                shrinkWrap: true,
                dragStartBehavior: DragStartBehavior.start,
                onReorder: (int oldIndex, int newIndex) async {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }

                  bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm"),
                        content: const Text("Are you sure you want to change the position of this item?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text("Yes"),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm == true) {
                    final item = _docs.removeAt(oldIndex);
                    _docs.insert(newIndex, item);

                    setState(() {}); // Refresh UI
                    await _updateDocumentIndices();
                  }
                },

                children: List.generate(
                  _docs.length,
                      (index) {
                    final DocumentSnapshot<Map<String, dynamic>> data = _docs[index];

                    Map<String, dynamic>? doc = data.data();
                    if (doc == null) return const SizedBox();

                    return Padding(
                      key: ValueKey(data.id),
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
                              '${doc['index'] ?? '-'}',
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
                                  doc['name'] ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  doc['collectionId'] ?? '',
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
    for (int i = 0; i < _docs.length; i++) {
      final doc = _docs[i];
      batch.update(doc.reference, {'index': i + 1}); // Store index as an integer
    }
    await batch.commit();
  }
}
