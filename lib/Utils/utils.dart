import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

class Utils {

  static showLoadingBox({
    required BuildContext context,
    required String title,
  }) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: 75,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: boxColor,
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        color: boxColor
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
    );
  }

  static showSnackBar({
    required BuildContext context,
    required String message,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: krishiFontColorPallets[0],
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: boxColor,
          ),
        )
      )
    );
  }
}