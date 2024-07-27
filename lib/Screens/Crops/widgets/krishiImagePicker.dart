import 'dart:typed_data';

import 'package:flutter/material.dart';

class KrishiImagePicker extends StatelessWidget {
  final VoidCallback onTap;
  final Uint8List? selectedImageBytes;
  final String title;

  const KrishiImagePicker({
    super.key,
    required this.onTap,
    required this.selectedImageBytes,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: size.width * .012),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: size.width * .1,
            width: size.width * .2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black),
            ),
            child: Center(
              child: selectedImageBytes != null
                  ? Image.memory(selectedImageBytes!)
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload),
                        SizedBox(height: 8),
                        Text("Upload Image"),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
