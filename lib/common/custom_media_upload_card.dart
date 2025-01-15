import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';

class CustomMediaUploadCard extends StatelessWidget {

  final double? width;
  final double? height;

  final bool isVideo;

  const CustomMediaUploadCard({
    super.key,
    this.width,
    this.height,
    this.isVideo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      width: width ?? MediaQuery.of(context).size.width * 0.25,
      height: height ?? MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        color: krishiFontColorPallets[2],
        borderRadius: BorderRadius.circular(10),
        border: const Border.fromBorderSide(
          BorderSide(
            color: boxColor,
            width: 2,
          ),
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            color: boxColor,
            size: MediaQuery.of(context).size.height * 0.09,
          ),

          Text(
            'Upload ${isVideo ? 'Video' : 'Image'}',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.03,
              color: boxColor,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}
