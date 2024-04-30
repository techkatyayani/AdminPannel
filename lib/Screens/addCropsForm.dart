import 'package:adminpannal/constants/app_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddCropsForm extends StatefulWidget {
  const AddCropsForm({super.key});

  @override
  State<AddCropsForm> createState() => _AddCropsFormState();
}

class _AddCropsFormState extends State<AddCropsForm> {
  late TextEditingController _nameController;
  late TextEditingController _imageUrlController;
  Uint8List? _selectedImageBytes;
  Uint8List? _selectedBannerImageBytes;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _imageUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _selectedImageBytes = result.files.single.bytes;
      });
    }
  }

  Future<void> _uploadImageToStorage(Uint8List imageBytes) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('images/${DateTime.now()}.jpg');
      await ref.putData(imageBytes);
      String imageUrl = await ref.getDownloadURL();
      print('Image uploaded successfully. Url: $imageUrl');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Crop Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            width: size.width * .3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Select Image'),
                  ),
                  const SizedBox(height: krishiSpacing),
                  _selectedImageBytes != null
                      ? Image.memory(_selectedImageBytes!)
                      : const SizedBox(height: 0),
                  const SizedBox(height: krishiSpacing),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Select Top Banner Image'),
                  ),
                  const SizedBox(height: krishiSpacing),
                  _selectedBannerImageBytes != null
                      ? Image.memory(_selectedBannerImageBytes!)
                      : const SizedBox(height: 0),
                  TextField(
                    onChanged: (value) {
                      // setState(() {
                      //   _cropName = value;
                      // });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter Crop Name',
                    ),
                  ),
                  const SizedBox(height: krishiSpacing),
                  ElevatedButton(
                    onPressed: () async {
                      if (_selectedBannerImageBytes != null) {
                        await _uploadImageToStorage(_selectedBannerImageBytes!);
                      } else {
                        print('Please select a banner image.');
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
