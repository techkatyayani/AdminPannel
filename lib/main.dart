import 'package:adminpannal/Screens/Category/controller/category_provider.dart';
import 'package:adminpannal/Screens/Crops/controller/crop_provider.dart';
import 'package:adminpannal/Screens/Dashboard/dashboard.dart';
import 'package:adminpannal/Screens/Krishi%20News/controller/krishi_news_provider.dart';
import 'package:adminpannal/config/themes/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Screens/Login/loginScreen.dart';
import 'firebase_options.dart';

void main() async {
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KrishiNewsProvider()),
        ChangeNotifierProvider(create: (_) => CropProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        title: 'Krishi Seva Kendra Admin',

        theme: AppTheme.basic,

        // home: const DashBoard(),

        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // Check if the user is logged in or not
            if (snapshot.connectionState == ConnectionState.active) {
              User? user = snapshot.data;
              if (user == null) {
                // If user is not logged in, show the login screen
                return const LoginScreen();
              } else {
                // If user is logged in, show the dashboard screen
                return const DashBoard();
              }
            } else {
              // Show a loading spinner while checking the authentication state
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
