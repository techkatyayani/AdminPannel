import 'package:adminpannal/Screens/cropCalendarForm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class CropCalanderScreen extends StatefulWidget {
  final String cropName;
  final String cropId;
  const CropCalanderScreen(
      {super.key, required this.cropName, required this.cropId});

  @override
  State<CropCalanderScreen> createState() => _CropCalanderScreenState();
}

class _CropCalanderScreenState extends State<CropCalanderScreen> {
  // void updateImage() async {}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.cropName} Crop Calendar"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: CropCalendarForm(
                            cropId: widget.cropId, cropName: widget.cropName),
                        type: PageTransitionType.fade,
                      ),
                    );
                  },
                  child: const Text(
                    "+ Add Calendar Items",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("product")
            .doc(widget.cropId)
            .collection("CropCalendar")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset("assets/images/loading.json", height: 140),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "No Crop Calendar Available",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: CropCalendarForm(
                              cropId: widget.cropId, cropName: widget.cropName),
                          type: PageTransitionType.fade,
                        ),
                      );
                    },
                    child: const Text(
                      "+ Add Calendar Items",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
              documents.sort(
                  (a, b) => int.parse(a['Id']).compareTo(int.parse(b['Id'])));
              return GridView.builder(
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisExtent: MediaQuery.sizeOf(context).height * .55),
                itemCount: documents.length,
                itemBuilder: (BuildContext context, int index) {
                  final calenderData = documents[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: size.width * .2,
                                child: Image(
                                  image: NetworkImage(
                                    calenderData['ImageUrl'],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                calenderData['Id'],
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              // updateImage();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 10),
                              decoration: const BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                              child: const Text(
                                "Edit",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('No data'),
              );
            }
          }
        },
      ),
    );
  }
}
