import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';

class KrishiNewsImages extends StatelessWidget {
  const KrishiNewsImages({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Krishi News Images',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: krishiFontColorPallets[0],
        ),
      ),
    );
  }
}
