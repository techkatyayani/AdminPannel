import 'package:adminpannal/Screens/Krishi%20News/controller/krishi_news_provider.dart';
import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../krishi_news_screen.dart';

class VideoUploadCard extends StatelessWidget {

  final KrishiNewsProvider provider;

  const VideoUploadCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => provider.pickFile(isVideo: true),
      child: kIsWeb
          ?
      provider.postVideoBytes == null
          ?
      buildUploadIcon(context, true)
          :
     Padding(
       padding: const EdgeInsets.symmetric(vertical: 10),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Text(
             provider.selectedVideo ?? 'Unknown Video',
             style: const TextStyle(
               fontSize: 15,
               fontWeight: FontWeight.bold,
               color: boxColor
             ),
             maxLines: 1,
             overflow: TextOverflow.ellipsis,
           ),

           const SizedBox(width: 15),

           const Icon(
             Icons.file_upload_outlined,
             color: krishiPrimaryColor,
           )
         ],
       ),
     )
          :
      provider.postVideo == null
          ?
      buildUploadIcon(context, true)
          :
      const Text(
        'Video File Selected..!!',
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: boxColor
        ),
      )
    );
  }
}
