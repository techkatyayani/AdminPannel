import 'package:adminpannal/Screens/Soil&Water%20Testing/soilAndWaterTestingDetailsScreen.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class SoilAndWaterTesting extends StatefulWidget {
  const SoilAndWaterTesting({super.key});

  @override
  State<SoilAndWaterTesting> createState() => _SoilAndWaterTestingState();
}

class _SoilAndWaterTestingState extends State<SoilAndWaterTesting> {
  late Future<Map<String, String>> imageUrlsFuture;

  @override
  void initState() {
    super.initState();
    imageUrlsFuture = _fetchImageUrls();
  }

  void _refreshImageUrls() {
    setState(() {
      imageUrlsFuture = _fetchImageUrls();
    });
  }

  Future<Map<String, String>> _fetchImageUrls() async {
    try {
      final imageUrls = <String, String>{};
      final paths = [
        'soilTesting.png',
        'waterTesting.png',
        'soilTestingHindi.png',
        'waterTestingHindi.png'
      ];
      final futures = paths.map((path) =>
          FirebaseStorage.instance.ref().child(path).getDownloadURL());

      final urls = await Future.wait(futures);

      for (int i = 0; i < paths.length; i++) {
        imageUrls[paths[i]] = urls[i];
      }

      return imageUrls;
    } catch (e) {
      print('Error fetching image URLs: $e');
      return {};
    }
  }

  Widget _buildTestingCard({
    required String imagePath,
    required String title,
    required String collectionPath,
    required VoidCallback onTap,
    required Map<String, String> imageUrls,
  }) {
    final size = MediaQuery.of(context).size;
    final imageUrl = imageUrls[imagePath] ?? '';

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('DynamicSection')
          .doc(collectionPath)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.asset('assets/images/loading.json', height: 140),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text("An error occurred."));
        } else if (!snapshot.hasData || snapshot.data?.data() == null) {
          return const Center(child: Text("No data available."));
        }
        final fetchData = snapshot.data!.data() as Map<String, dynamic>?;

        return InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: boxColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: 130,
                      width: 130,
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Text(
                            "Price : ",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            "₹ ${fetchData!['amount']}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_circle_right_sharp, size: size.width * .03),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: imageUrlsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.asset('assets/images/loading.json', height: 140),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No data available."));
        }
        final imageUrls = snapshot.data!;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * .06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: krishiSpacing * 2),
                const Text(
                  "Soil & Water Testing",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: krishiSpacing * 2),
                _buildTestingCard(
                  imagePath: 'soilTesting.png',
                  title: "Soil Testing",
                  collectionPath: 'SoilTestingContent',
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          child: const SoilAndWaterTestingDetailsScreen(
                              title: 'SoilTestingContent',
                              titleHindi: 'SoilTestingContentHindi'),
                          type: PageTransitionType.fade),
                    );
                  },
                  imageUrls: imageUrls,
                ),
                const SizedBox(height: krishiSpacing),
                _buildTestingCard(
                  imagePath: 'waterTesting.png',
                  title: "Water Testing",
                  collectionPath: 'WaterTestingContent',
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          child: const SoilAndWaterTestingDetailsScreen(
                              title: 'WaterTestingContent',
                              titleHindi: 'WaterTestingContentHindi'),
                          type: PageTransitionType.fade),
                    );
                  },
                  imageUrls: imageUrls,
                ),
                const SizedBox(height: krishiSpacing),
                const Divider(),
                const SizedBox(height: krishiSpacing),
                const Text(
                  "Soil Testing Icons",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: krishiSpacing),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: boxColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildImageIcon(imageUrls['soilTesting.png']!, 200,
                          'soilTesting.png'),
                      SizedBox(width: MediaQuery.sizeOf(context).width * .1),
                      _buildImageIcon(imageUrls['soilTestingHindi.png']!, 200,
                          'soilTestingHindi.png'),
                    ],
                  ),
                ),
                const SizedBox(height: krishiSpacing),
                const Text(
                  "Water Testing Icons",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: krishiSpacing),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: boxColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildImageIcon(imageUrls['waterTesting.png']!, 200,
                          'waterTesting.png'),
                      SizedBox(width: MediaQuery.sizeOf(context).width * .1),
                      _buildImageIcon(imageUrls['waterTestingHindi.png']!, 200,
                          'waterTestingHindi.png'),
                    ],
                  ),
                ),
                const SizedBox(height: krishiSpacing * 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageIcon(String imageUrl, double size, String imageName) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: size,
            width: size,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Dialog(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Please wait...',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            );

            FilePickerResult? result =
                await FilePicker.platform.pickFiles(type: FileType.image);

            if (result != null) {
              PlatformFile file = result.files.first;
              final storageRef =
                  FirebaseStorage.instance.ref().child(imageName);

              try {
                await storageRef.putData(file.bytes!);

                String downloadURL = await storageRef.getDownloadURL();
                print("Uploaded file available at: $downloadURL");

                _refreshImageUrls();
              } catch (e) {
                print("Error uploading file: $e");
              }
            } else {
              print("No file selected.");
            }

            Navigator.pop(context);
          },
          child: const Text(
            "Update Icon",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
