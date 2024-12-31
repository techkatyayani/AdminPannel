import 'package:adminpannal/Screens/Banner/Banners.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StripBannerScreen extends StatefulWidget {
  final List<String> bannersList;
  final String screenName;
  const StripBannerScreen({
    super.key,
    required this.bannersList,
    required this.screenName,
  });

  @override
  State<StripBannerScreen> createState() => _StripBannerScreenState();
}

class _StripBannerScreenState extends State<StripBannerScreen> {
  bool isLoading = false;
  late Future<Map<String, dynamic>> stripBannerImage;

  @override
  void initState() {
    super.initState();
    stripBannerImage = getImage();
  }

  Future<void> updateImage() async {
    stripBannerImage = getImage();
    setState(() {});
  }

  Future<Map<String, dynamic>> getImage() async {
    final DocumentReference user1 = FirebaseFirestore.instance
        .collection('imagefromfirebase')
        .doc('Category');
    try {
      DocumentSnapshot userSnapshot = await user1.get();
      setState(() {});
      return userSnapshot.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error fetching image data: $e');
      return {};
    }
  }

  Future<void> _pickImageAndUpdate(String imageName) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        isLoading = true;
      });
      List<int> fileBytes = result.files.single.bytes!;
      await FirebaseStorage.instance
          .ref()
          .child('swipe banner')
          .child(imageName)
          .delete()
          .catchError((error) {
        if (kDebugMode) {
          print('Error deleting existing image: $error');
        }
      });
      String? imageUrl =
          await _uploadImage(imageBytes: fileBytes, imageName: imageName);

      if (imageUrl != null) {
        await updateImageUrlInFirestore(imageName, imageUrl);
        updateImage();
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String?> _uploadImage(
      {required List<int> imageBytes, required String imageName}) async {
    try {
      Reference ref =
          FirebaseStorage.instance.ref().child('swipe banner').child(imageName);
      Uint8List uint8List = Uint8List.fromList(imageBytes);
      UploadTask uploadTask = ref.putData(uint8List);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      return null;
    }
  }

  Future<void> updateImageUrlInFirestore(
      String imageName, String imageUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection('imagefromfirebase')
          .doc('Category')
          .set({imageName: imageUrl}, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print('Error updating image URL in Firestore: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.screenName),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: stripBannerImage,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset(
                  "assets/images/loading.json",
                  height: 140,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              Map<String, dynamic> userData = snapshot.data ?? {};
              if (isLoading) {
                return Center(
                  child: Lottie.asset(
                    "assets/images/loading.json",
                    height: 140,
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (final imageName in widget.bannersList)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: ImageContainer(
                              isLarge: true,
                              imageUrl: userData[imageName] ?? '',
                              imageName: imageName,
                              onTap: () => _pickImageAndUpdate(imageName),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
