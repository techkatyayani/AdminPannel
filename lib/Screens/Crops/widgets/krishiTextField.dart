import 'package:adminpannal/constants/app_constants.dart';
import 'package:flutter/material.dart';

class KrishiTextField extends StatefulWidget {
  final TextEditingController controller;
  final double width;
  final String hintText;
  final String? Function(String?)? validator;

  const KrishiTextField({
    super.key,
    required this.controller,
    required this.width,
    required this.hintText,
    this.validator,
  });

  @override
  State<KrishiTextField> createState() => _KrishiTextFieldState();
}

class _KrishiTextFieldState extends State<KrishiTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: krishiPrimaryColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: widget.validator,
      ),
    );
  }
}
