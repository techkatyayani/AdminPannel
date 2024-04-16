import 'dart:developer';

import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({super.key});

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  late Future<Map<String, dynamic>> userDataFuture;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    userDataFuture = getImage();
  }

  Future<Map<String, dynamic>> getImage() async {
    final DocumentReference user1 = FirebaseFirestore.instance
        .collection('imagefromfirebase')
        .doc('Category');
    try {
      DocumentSnapshot userSnapshot = await user1.get();
      return userSnapshot.data() as Map<String, dynamic>;
    } catch (e) {
      log(e.toString());
      return {};
    }
  }

  Future<void> _pickImageAndUpdate(String imageName) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    log(pickedFile.toString());
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      String imageUrl = await _uploadImage(imageFile, imageName);

      await updateImageUrlInFirestore(imageName, imageUrl);

      setState(() {
        userDataFuture = getImage();
      });
    }
  }

  Future<String> _uploadImage(File imageFile, String imageName) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images')
          .child(imageName);
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      log("Error uploading image: $e");
      return '';
    }
  }

  Future<void> updateImageUrlInFirestore(
      String imageName, String imageUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection('imagefromfirebase')
          .doc('Category')
          .update({imageName: imageUrl});
    } catch (e) {
      log("Error updating image URL in Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return FutureBuilder<Map<String, dynamic>>(
      future: userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.asset(
              "assets/images/loading.json",
              height: 100,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          Map<String, dynamic> userData = snapshot.data ?? {};
          return Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: width,
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Hindi Slide Banners',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.01,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () => _pickImageAndUpdate('Demo.jpg'),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.network(
                                userData['Demo.jpg'] ?? '',
                                width: width * 0.2,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              _pickImageAndUpdate('best selling hindi.jpg'),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.network(
                                userData['best selling hindi.jpg'] ?? '',
                                width: width * 0.2,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              _pickImageAndUpdate('agri advisor hindi.jpg'),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.network(
                                userData['agri advisor hindi.jpg'] ?? '',
                                width: width * 0.2,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              _pickImageAndUpdate('crop calender hindi.jpg'),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.network(
                                userData['crop calender hindi.jpg'] ?? '',
                                width: width * 0.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: krishiSpacing),
                  Container(
                    width: width,
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'English Slide Banners',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.01,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => _pickImageAndUpdate('Demo.jpg'),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.network(
                              userData['Demo.jpg'] ?? '',
                              width: width * 0.2,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            _pickImageAndUpdate('best selling hindi.jpg'),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.network(
                              userData['best selling hindi.jpg'] ?? '',
                              width: width * 0.2,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            _pickImageAndUpdate('agri advisor hindi.jpg'),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.network(
                              userData['agri advisor hindi.jpg'] ?? '',
                              width: width * 0.2,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            _pickImageAndUpdate('crop calender hindi.jpg'),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.network(
                              userData['crop calender hindi.jpg'] ?? '',
                              width: width * 0.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ));
        }
      },
    );
  }
}
