import 'dart:typed_data';

import 'package:adminpannal/common/custom_text_field.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddCropScreen extends StatefulWidget {
  const AddCropScreen({super.key});

  @override
  State<AddCropScreen> createState() => _AddCropScreenState();
}

class _AddCropScreenState extends State<AddCropScreen> {

  late TextEditingController cropNameController;

  Uint8List? _selectedCropImage;
  Uint8List? _selectedEnglishBannerImage;
  Uint8List? _selectedHindiBannerImage;

  @override
  void initState() {
    super.initState();
    cropNameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    cropNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          'Add Crop',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        color: boxColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Crop Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),

            const SizedBox(height: 15),

            const Divider(),

            const SizedBox(height: 15),

            CustomTextField(
              controller: cropNameController,
              labelText: 'Crop Name',
            ),

            const SizedBox(height: 40),

            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _customImageCard(
                    title: 'Crop Image',
                    onTap: () async {
                      Uint8List? image = await _pickImage();
                      setState(() {
                        _selectedCropImage = image;
                      });
                    },
                    image: _selectedCropImage,
                  ),

                  _customImageCard(
                    title: 'Crop English Banner Image',
                    onTap: () async {
                      Uint8List? image = await _pickImage();
                      setState(() {
                        _selectedEnglishBannerImage = image;
                      });
                    },
                    image: _selectedEnglishBannerImage,
                  ),

                  _customImageCard(
                    title: 'Crop Hindi Banner Image',
                    onTap: () async {
                      Uint8List? image = await _pickImage();
                      setState(() {
                        _selectedHindiBannerImage = image;
                      });
                    },
                    image: _selectedHindiBannerImage
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  label: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    ),
                  ),
                  iconAlignment: IconAlignment.end,
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<Uint8List?> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      Uint8List? image = result.files.single.bytes;
      return image;
    }

    return null;
  }

  Widget _customImageCard({
    required String title,
    required VoidCallback onTap,
    required Uint8List? image,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),

        const SizedBox(height: 10),

        GestureDetector(
          onTap: onTap,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white
              ),
            ),
            child: Center(
              child: image != null
                  ?
              Image.memory(
                image,
                fit: BoxFit.fill,
                errorBuilder: (context, error, s) {
                  return const Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.white,
                    ),
                  );
                },
              )
                  :
              const Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.upload,
                    color: Colors.white,
                    size: 40,
                  ),

                  Text(
                    "Upload Image",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
