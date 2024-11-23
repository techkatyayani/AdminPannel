import 'package:adminpannal/Screens/Krishi%20News/controller/krishi_news_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../krishi_news_screen.dart';

class ImageUploadCard extends StatelessWidget {

  final KrishiNewsProvider provider;

  const ImageUploadCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => provider.pickFile(isVideo: false),
      child: kIsWeb
          ?
      provider.postImageBytes == null
          ?
      buildUploadIcon(context, false)
          :
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.memory(
          provider.postImageBytes!,
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.25,
        ),
      )
          :
      provider.postImage == null
          ?
      buildUploadIcon(context, false)
          :
      ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.file(
          provider.postImage!,
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.25,
        ),
      ),
    );
  }
}
