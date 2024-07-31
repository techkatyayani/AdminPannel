import 'package:adminpannal/Screens/Login/loginScreen.dart';
import 'package:adminpannal/config/themes/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Krishi Seva Kendra Admin',
      theme: AppTheme.basic,
      home: const LoginScreen(),
      // home: StreamBuilder<User?>(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot) {
      //     // Check if the user is logged in or not
      //     if (snapshot.connectionState == ConnectionState.active) {
      //       User? user = snapshot.data;
      //       if (user == null) {
      //         // If user is not logged in, show the login screen
      //         return const LoginScreen();
      //       } else {
      //         // If user is logged in, show the dashboard screen
      //         return const DashBoard();
      //       }
      //     } else {
      //       // Show a loading spinner while checking the authentication state
      //       return const Scaffold(
      //         body: Center(
      //           child: CircularProgressIndicator(),
      //         ),
      //       );
      //     }
      //   },
      // ),
    );
  }
}
