import 'dart:typed_data';

import 'package:adminpannal/Screens/Crops/widgets/krishiImagePicker.dart';
import 'package:adminpannal/Screens/Crops/widgets/krishiTextField.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddBetweenBannersForm extends StatefulWidget {
  const AddBetweenBannersForm({super.key});

  @override
  State<AddBetweenBannersForm> createState() => _AddBetweenBannersFormState();
}

class _AddBetweenBannersFormState extends State<AddBetweenBannersForm> {
  final _formKey = GlobalKey<FormState>();
  final _collectionIdController = TextEditingController();
  final _collectionNameController = TextEditingController();
  bool isLoading = false;
  Uint8List? _image1Bytes;
  Uint8List? _image2Bytes;
  Uint8List? _image3Bytes;
  Uint8List? _image1HindiBytes;
  Uint8List? _image2HindiBytes;
  Uint8List? _image3HindiBytes;

  Future<void> _pickImage(int index, String title) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      if (title == 'en') {
        if (index == 1) {
          _image1Bytes = result.files.single.bytes;
        } else if (index == 2) {
          _image2Bytes = result.files.single.bytes;
        } else if (index == 3) {
          _image3Bytes = result.files.single.bytes;
        }
      } else if (title == 'hi') {
        if (index == 1) {
          _image1HindiBytes = result.files.single.bytes;
        } else if (index == 2) {
          _image2HindiBytes = result.files.single.bytes;
        } else if (index == 3) {
          _image3HindiBytes = result.files.single.bytes;
        }
      }
      setState(() {});
    }
  }

  Future<String> _uploadImage(Uint8List imageBytes, String imageName) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(
        'ProductBetweenBanners/${_collectionIdController.text}/$imageName');
    final uploadTask = imageRef.putData(imageBytes);
    final snapshot = await uploadTask;
    final imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future<void> _submitButton() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_image1Bytes == null ||
          _image2Bytes == null ||
          _image3Bytes == null ||
          _image1HindiBytes == null ||
          _image2HindiBytes == null ||
          _image3HindiBytes == null) {
        _showErrorDialog("Please select all required images.");
        return;
      }

      setState(() {
        isLoading = true;
      });

      try {
        // Upload images and get their URLs
        final image1Url = await _uploadImage(_image1Bytes!, 'image1');
        final image2Url = await _uploadImage(_image2Bytes!, 'image2');
        final image3Url = await _uploadImage(_image3Bytes!, 'image3');
        final image1HindiUrl =
            await _uploadImage(_image1HindiBytes!, 'hindiimage1');
        final image2HindiUrl =
            await _uploadImage(_image2HindiBytes!, 'hindiimage2');
        final image3HindiUrl =
            await _uploadImage(_image3HindiBytes!, 'hindiimage3');

        // Save URLs to Firestore
        await FirebaseFirestore.instance
            .collection('imagefromfirebase')
            .doc('ProductBetweenBanners')
            .collection('EnglishProductBetweenBanners')
            .doc(_collectionIdController.text)
            .set({
          'id': _collectionIdController.text,
          'title': _collectionNameController.text,
          'image1': image1Url,
          'image2': image2Url,
          'image3': image3Url,
        });
        await FirebaseFirestore.instance
            .collection('imagefromfirebase')
            .doc('ProductBetweenBanners')
            .collection('HindiProductBetweenBanners')
            .doc(_collectionIdController.text)
            .set({
          'id': _collectionIdController.text,
          'title': _collectionNameController.text,
          'image1': image1HindiUrl,
          'image2': image2HindiUrl,
          'image3': image3HindiUrl,
        });

        Navigator.pop(context);
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Banners Added Successfully")));
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Validation Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Banners By Collection"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: boxColor,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "Collection Name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                    const SizedBox(height: 6),
                    KrishiTextField(
                      controller: _collectionNameController,
                      width: size.width * .3,
                      hintText: 'Collection Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a collection name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "Collection ID",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                    const SizedBox(height: 6),
                    KrishiTextField(
                      controller: _collectionIdController,
                      width: size.width * .3,
                      hintText: 'Collection ID',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a collection ID';
                        }
                        return null;
                      },
                    ),
                    const Divider(height: krishiSpacing * 3),
                    const Text(
                      "English Banners",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    const SizedBox(height: krishiSpacing * 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: krishiSpacing * 2),
                        KrishiImagePicker(
                          onTap: () => _pickImage(1, 'en'),
                          selectedImageBytes: _image1Bytes,
                          title: 'Image1',
                        ),
                        const SizedBox(width: krishiSpacing * 2),
                        KrishiImagePicker(
                          onTap: () => _pickImage(2, 'en'),
                          selectedImageBytes: _image2Bytes,
                          title: 'Image2',
                        ),
                        const SizedBox(width: krishiSpacing * 2),
                        KrishiImagePicker(
                          onTap: () => _pickImage(3, 'en'),
                          selectedImageBytes: _image3Bytes,
                          title: 'Image3',
                        ),
                        const SizedBox(width: krishiSpacing * 2),
                      ],
                    ),
                    const Divider(height: krishiSpacing * 3),
                    const Text(
                      "Hindi Banners",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    const SizedBox(height: krishiSpacing * 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: krishiSpacing * 2),
                        KrishiImagePicker(
                          onTap: () => _pickImage(1, 'hi'),
                          selectedImageBytes: _image1HindiBytes,
                          title: 'Image1',
                        ),
                        const SizedBox(width: krishiSpacing * 2),
                        KrishiImagePicker(
                          onTap: () => _pickImage(2, 'hi'),
                          selectedImageBytes: _image2HindiBytes,
                          title: 'Image2',
                        ),
                        const SizedBox(width: krishiSpacing * 2),
                        KrishiImagePicker(
                          onTap: () => _pickImage(3, 'hi'),
                          selectedImageBytes: _image3HindiBytes,
                          title: 'Image3',
                        ),
                        const SizedBox(width: krishiSpacing * 2),
                      ],
                    ),
                    const SizedBox(height: krishiSpacing * 2),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(size.width * .2, size.height * .08)),
                      onPressed: _submitButton,
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              "Submit",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(height: krishiSpacing * 3),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
