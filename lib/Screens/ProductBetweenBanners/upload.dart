import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  List<PlatformFile>? _pickedFiles;
  bool _isLoading = false;
  final TextEditingController _indexController = TextEditingController();
  final TextEditingController _collectionIdController = TextEditingController();

  Future<void> _pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        _pickedFiles = result.files;
      });
    }
  }

  Future<void> _uploadFiles() async {
    if (_pickedFiles == null ||
        _indexController.text.isEmpty ||
        _collectionIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please complete all fields and pick files')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String collectionId = _collectionIdController.text;
    String index = _indexController.text;

    try {
      for (int i = 0; i < _pickedFiles!.length; i++) {
        String fileName = _pickedFiles![i].name;
        String filePath = 'ProductBetweenBanners/$collectionId/$fileName';

        await FirebaseStorage.instance
            .ref(filePath)
            .putFile(File(_pickedFiles![i].path!));

        String downloadURL =
            await FirebaseStorage.instance.ref(filePath).getDownloadURL();

        await FirebaseFirestore.instance
            .collection('imagefromfirebase')
            .doc('ProductBetweenBanners')
            .collection('EnglishProductBetweenBanners')
            .doc(collectionId)
            .set({
          'index': index,
          'url': downloadURL,
          'storagePath': filePath,
        });
      }

      setState(() {
        _isLoading = false;
        _pickedFiles = null;
        _indexController.clear();
        _collectionIdController.clear();
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Upload successful')));
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Files'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickFiles,
              child: const Text('Pick Files'),
            ),
            _pickedFiles != null
                ? Column(
                    children:
                        _pickedFiles!.map((file) => Text(file.name)).toList(),
                  )
                : Container(),
            TextField(
              controller: _indexController,
              decoration: const InputDecoration(labelText: 'Index'),
            ),
            TextField(
              controller: _collectionIdController,
              decoration: const InputDecoration(labelText: 'Collection ID'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _uploadFiles,
                    child: const Text('Upload Files'),
                  ),
          ],
        ),
      ),
    );
  }
}
