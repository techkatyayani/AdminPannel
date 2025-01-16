import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final bool enabled;
  final bool hasOutlineBorder;
  final TextFieldTheme theme;

  final List<TextInputFormatter>? inputFormatters;

  final Widget? suffix;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.enabled = true,
    this.hasOutlineBorder = false,
    this.theme = TextFieldTheme.light,
    this.inputFormatters,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        validator: (string) {
          if (string == null || string == '') {
            return '${hintText ?? labelText ?? ''} is required..!!';
          }
          return null;
        },
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: theme == TextFieldTheme.light ? Colors.white : Colors.black,
        ),
        inputFormatters: inputFormatters,

        decoration: InputDecoration(

          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: theme == TextFieldTheme.light ? Colors.white70 : Colors.black87,
          ),

          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: theme == TextFieldTheme.light ? Colors.white70 : Colors.black87,
          ),

          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: suffix,
          ),
          suffixIconConstraints: const BoxConstraints(),

          border: outlineInputBorder(),
          enabledBorder: outlineInputBorder(),
          focusedBorder: outlineInputBorder(width: 2),
          errorBorder: outlineInputBorder(color: Colors.red),
          focusedErrorBorder: outlineInputBorder(width: 2, color: Colors.red),
        )
      ),
    );
  }

  UnderlineInputBorder underlineInputBorder({double? width, Color? color}) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: color ?? (theme == TextFieldTheme.light ? Colors.white : Colors.black),
        width: width ?? 1.25,
      ),
    );
  }

  OutlineInputBorder outlineInputBorder({double? width, Color? color}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color ?? (theme == TextFieldTheme.light ? Colors.white : Colors.black),
        width: width ?? 1.25,
      ),
    );
  }
}

enum TextFieldTheme {
  light,
  dark,
}
