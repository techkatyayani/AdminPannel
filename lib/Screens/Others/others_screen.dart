import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  FilePickerResult? _pickedFile;
  String? _imageUrl;
  final TextEditingController _imageNameController = TextEditingController();
  bool isLoading = false;

  Future<void> _pickImage() async {
    _pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    setState(() {});
  }

  Future<void> _uploadImage() async {
    setState(() {
      isLoading = true;
    });
    if (_pickedFile != null) {
      final imageName = _imageNameController.text.trim();
      if (imageName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please enter an image name"),
        ));
        return;
      }

      final fileBytes = _pickedFile!.files.single.bytes!;
      final fileName = _pickedFile!.files.single.name;

      try {
        final storageRef =
            FirebaseStorage.instance.ref().child('imagefromfirebase/$fileName');
        final uploadTask = storageRef.putData(fileBytes);
        final snapshot = await uploadTask;
        final imageUrl = await snapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('imagefromfirebase')
            .doc('Category')
            .set({
          imageName: imageUrl,
        }, SetOptions(merge: true));

        setState(() {
          _imageUrl = imageUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Image uploaded successfully"),
        ));
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        if (kDebugMode) {
          print(e);
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Failed to upload image"),
        ));
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please pick an image first"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _pickedFile != null
                    ? Container(
                        height: size.height * .2,
                        width: size.height * .5,
                        child: Image.memory(_pickedFile!.files.single.bytes!))
                    : Container(
                        height: size.height * .2,
                        width: size.height * .5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white)),
                        child: const Center(
                          child: Icon(EvaIcons.upload),
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: size.width * .2,
                child: TextField(
                  controller: _imageNameController,
                  decoration: const InputDecoration(labelText: "Image Name"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _uploadImage,
            child: isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text(
                    "Upload Image",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
          ),
          if (_imageUrl != null)
            Column(
              children: [
                const Text("Uploaded Image URL:"),
                SelectableText(_imageUrl!),
              ],
            ),
        ],
      ),
    );
  }
}
