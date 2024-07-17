import 'dart:typed_data';

import 'package:adminpannal/Screens/Crops/cropCalendarForm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CropCalanderScreen extends StatefulWidget {
  final String cropName;
  final String cropId;
  final String language;

  const CropCalanderScreen({
    Key? key,
    required this.cropName,
    required this.cropId,
    required this.language,
  }) : super(key: key);

  @override
  State<CropCalanderScreen> createState() => _CropCalanderScreenState();
}

class _CropCalanderScreenState extends State<CropCalanderScreen> {
  Future<void> deleteImage(String docId) async {
    final collectionName =
        widget.language == 'English' ? 'CropCalendar' : 'HindiCropCalendar';

    await FirebaseFirestore.instance
        .collection("product")
        .doc(widget.cropId)
        .collection(collectionName)
        .doc(docId)
        .delete();
  }

  Future<void> updateImage(String docId) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;
      Uint8List imageBytes = file.bytes!;

      // Show Snackbar indicating uploading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Uploading image...')),
      );

      try {
        String imageUrl = await uploadImageToFirebase(imageBytes);

        final collectionName =
            widget.language == 'English' ? 'CropCalendar' : 'HindiCropCalendar';

        await FirebaseFirestore.instance
            .collection("product")
            .doc(widget.cropId)
            .collection(collectionName)
            .doc(docId)
            .update({'ImageUrl': imageUrl});

        // Show success Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully')),
        );
      } catch (e) {
        // Show error Snackbar if upload fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      }
    }
  }

  Future<String> uploadImageToFirebase(Uint8List imageBytes) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final folderRef = storageRef
          .child('cropcalendar/${widget.cropName}_${widget.language}');
      final imageRef =
          folderRef.child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload image data to Firebase Storage
      await imageRef.putData(
          imageBytes, SettableMetadata(contentType: 'image/jpeg'));

      // Get the download URL
      String imageUrl = await imageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
      rethrow;
    }
  }

  void showDeleteConfirmationDialog(
      BuildContext context, String imageUrl, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                imageUrl,
                height: 100,
              ),
              const SizedBox(height: 20),
              const Text('Are you sure you want to delete this image?'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteImage(docId);
                Navigator.of(context).pop();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.cropName} Crop Calendar ${widget.language}"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CropCalendarForm(
                          cropId: widget.cropId,
                          cropName: widget.cropName,
                          language: widget.language,
                        ),
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
        stream: widget.language == 'English'
            ? FirebaseFirestore.instance
                .collection("product")
                .doc(widget.cropId)
                .collection("CropCalendar")
                .snapshots()
            : FirebaseFirestore.instance
                .collection("product")
                .doc(widget.cropId)
                .collection("HindiCropCalendar")
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
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
                        MaterialPageRoute(
                          builder: (context) => CropCalendarForm(
                              cropId: widget.cropId,
                              cropName: widget.cropName,
                              language: widget.language),
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
                  mainAxisExtent: size.height * .55,
                ),
                itemCount: documents.length,
                itemBuilder: (BuildContext context, int index) {
                  final calenderData = documents[index];
                  bool isLastItem = index == documents.length - 1;
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
                                child: Image.network(
                                  calenderData['ImageUrl'],
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
                              updateImage(calenderData.id);
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
                        if (isLastItem)
                          Positioned(
                            left: 0,
                            top: 0,
                            child: GestureDetector(
                              onTap: () {
                                showDeleteConfirmationDialog(context,
                                    calenderData['ImageUrl'], calenderData.id);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.8),
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: Colors.white,
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
