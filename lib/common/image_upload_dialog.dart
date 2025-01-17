

import 'dart:typed_data';

import 'package:adminpannal/common/custom_media_upload_card.dart';
import 'package:flutter/material.dart';

class ImageUploadDialog extends StatelessWidget {

  final Uint8List? pickedImage;
  final String? imageUrl;
  final VoidCallback onTap;
  final VoidCallback onUpload;
  final VoidCallback onCancel;

  const ImageUploadDialog({
    super.key,
    required this.pickedImage,
    required this.imageUrl,
    required this.onTap,
    required this.onUpload,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Dialog(
      child: Container(
        width: size.width * 0.45,
        height: size.height * 0.55,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
        child: Column(
          children: [
            const Text(
              'Upload Image',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),

            const SizedBox(height: 20),

            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(10),
              child: pickedImage != null
                  ?
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  pickedImage!,
                  width: size.width * 0.15,
                  height: size.width * 0.15,
                  fit: BoxFit.fill,
                  errorBuilder: (_, e, s) {
                    return const Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              )
                  :
              imageUrl != null
                  ?
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl!,
                  width: size.width * 0.15,
                  height: size.width * 0.15,
                  fit: BoxFit.fill,
                  errorBuilder: (_, e, s) {
                    return const Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              )
                  :
              CustomMediaUploadCard(
                width: size.width * 0.15,
                height: size.height * 0.2,
              ),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    minimumSize: const Size(100, 45),
                  ),
                  onPressed: onCancel,
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    minimumSize: const Size(100, 45),
                  ),
                  onPressed: onUpload,
                  child: const Text(
                    'Upload',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}
