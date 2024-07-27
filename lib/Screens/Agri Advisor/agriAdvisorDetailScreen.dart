import 'package:flutter/material.dart';

class AgriAdvisorDetailScreen extends StatefulWidget {
  const AgriAdvisorDetailScreen({super.key});

  @override
  State<AgriAdvisorDetailScreen> createState() =>
      _AgriAdvisorDetailScreenState();
}

class _AgriAdvisorDetailScreenState extends State<AgriAdvisorDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agri Advisor Video Call"),
      ),
    );
  }
}
