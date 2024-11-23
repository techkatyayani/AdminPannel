import 'package:flutter/material.dart';

class CustomPostTextField extends StatelessWidget {

  final TextEditingController controller;
  final String hintText;
  final bool? enabled;

  const CustomPostTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.enabled
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              hintText,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: TextFormField(
              enabled: enabled,
              controller: controller,
              cursorColor: Colors.black,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              validator: (string) {
                if (controller.text.trim().isEmpty) {
                  return '$hintText is required..!!';
                }
                return null;
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 5),
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                errorStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1.25,
                  ),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1.25,
                  ),
                ),
                disabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1.25,
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                focusedErrorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 1.25,
                  ),
                ),
                errorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 1.25,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
