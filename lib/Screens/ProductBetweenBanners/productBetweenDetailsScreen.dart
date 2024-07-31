import 'dart:typed_data';
import 'package:adminpannal/Screens/Banner/Banners.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProductBetweenBannerDetailsScreen extends StatefulWidget {
  final String collectionId;
  final String collectionName;

  const ProductBetweenBannerDetailsScreen(
      {super.key, required this.collectionId, required this.collectionName});

  @override
  State<ProductBetweenBannerDetailsScreen> createState() =>
      _ProductBetweenBannerDetailsScreenState();
}

class _ProductBetweenBannerDetailsScreenState
    extends State<ProductBetweenBannerDetailsScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.collectionName} (${widget.collectionId})"),
      ),
      body: Row(
        children: [
          Expanded(
              child: _buildBannerStream(
                  'EnglishProductBetweenBanners', 'English Banners', '')),
          Expanded(
              child: _buildBannerStream(
                  'HindiProductBetweenBanners', 'Hindi Banners', 'hindi')),
        ],
      ),
    );
  }

  Widget _buildBannerStream(String collectionName, String title, String lang) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('imagefromfirebase')
          .doc('ProductBetweenBanners')
          .collection(collectionName)
          .doc(widget.collectionId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.asset("assets/images/loading.json", height: 140),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.data() == null) {
          return const Center(child: Text('No data available'));
        } else {
          final bannerData = snapshot.data!.data()!;
          return SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                for (var i = 1; i <= 3; i++)
                  _buildImageColumn('image$i', bannerData['image$i'] ?? '',
                      collectionName, lang),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildImageColumn(
      String imageName, String imageUrl, String collectionName, String lang) {
    return Column(
      children: [
        ImageContainer(
          imageUrl: imageUrl,
          imageName: imageName,
          isLarge: true,
          onTap: () => _pickImageAndUpdate(imageName, collectionName, lang),
        ),
        const SizedBox(height: 6),
        Text(
          imageName.replaceAll('.jpg', '').replaceAll('_', ' '),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Future<void> _pickImageAndUpdate(
      String imageName, String collectionName, String lang) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() => isLoading = true);
      try {
        String? imageUrl = await _uploadImage(
            result.files.single.bytes!, imageName, collectionName, lang);
        if (imageUrl != null) {
          await FirebaseFirestore.instance
              .collection('imagefromfirebase')
              .doc('ProductBetweenBanners')
              .collection(collectionName)
              .doc(widget.collectionId)
              .set({imageName: imageUrl}, SetOptions(merge: true));
          updateImage();
        }
      } catch (e) {
        print('Error updating image: $e');
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  Future<String?> _uploadImage(List<int> imageBytes, String imageName,
      String collectionName, String lang) async {
    try {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('ProductBetweenBanners')
          .child(widget.collectionId)
          .child(lang + imageName)
          .putData(Uint8List.fromList(imageBytes));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  void updateImage() {
    setState(() {});
  }
}
