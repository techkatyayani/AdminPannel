import 'package:adminpannal/Screens/addCropsForm.dart';
import 'package:adminpannal/Screens/dashboard.dart';
import 'package:adminpannal/config/themes/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );

  await initializeFlutterFire();

  runApp(const MyApp());
}

Future<void> initializeFlutterFire() async {
  await Future.wait<void>([]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Katyayani Admin',
      theme: AppTheme.basic,
      home: const DashBoard(),
    );
  }
}
