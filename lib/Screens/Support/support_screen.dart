import 'package:flutter/material.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100),
      child: Column(
        children: [
          SizedBox(height: 100, child: Image.asset('assets/images/logo.png')),
          const SizedBox(height: 20),
          const Text(
            "Contact to Katyayani Tech Team",
            style: TextStyle(fontSize: 20),
          ),
          const Text(
            "For any inquiries",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
