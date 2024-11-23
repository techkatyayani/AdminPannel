import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';

class KrishiNewsVideos extends StatelessWidget {
  const KrishiNewsVideos({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Krishi News Video',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: krishiFontColorPallets[0],
        ),
      ),
    );
  }
}
