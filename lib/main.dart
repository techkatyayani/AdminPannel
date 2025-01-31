import 'package:adminpannal/Screens/Category/controller/category_provider.dart';
import 'package:adminpannal/Screens/Crops/controller/crop_provider.dart';
import 'package:adminpannal/Screens/Crops/crop_disease_section/controller/disease_controller.dart';
import 'package:adminpannal/Screens/Dashboard/dashboard.dart';
import 'package:adminpannal/Screens/Krishi%20News/controller/krishi_news_provider.dart';
import 'package:adminpannal/Screens/Similar%20Products/controller/similar_products_provider.dart';
import 'package:adminpannal/Screens/crop_stage/controller/crop_stage_provider.dart';
import 'package:adminpannal/Screens/product_review/controller/ksk_review_controller.dart';
import 'package:adminpannal/Screens/prouct_catagory/controller/prouduct_catagory_controller.dart';
import 'package:adminpannal/Screens/state_crops/controller/state_crop_provider.dart';
import 'package:adminpannal/config/themes/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/Login/loginScreen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Widget nextScreen = const LoginScreen();

  @override
  void initState() {
    super.initState();
    getScreen();
  }

  Future<void> getScreen() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool? isLogin = pref.getBool('LOGIN');
    if (isLogin == null) {
      nextScreen = const LoginScreen();
    } else {
      if (isLogin) {
        nextScreen = const DashBoard();
      } else {
        nextScreen = const LoginScreen();
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KrishiNewsProvider()),
        ChangeNotifierProvider(create: (_) => CropProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => KskReviewController()),
        ChangeNotifierProvider(create: (_) => ProuductCatagoryController()),
        ChangeNotifierProvider(create: (_) => DiseaseController()),
        ChangeNotifierProvider(create: (_) => CropStageProvider()),
        ChangeNotifierProvider(create: (_) => StateCropProvider()),
        ChangeNotifierProvider(create: (_) => SimilarProductsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        title: 'Krishi Seva Kendra Admin',

        theme: AppTheme.basic,

        home: nextScreen,

        // home: const StateCropsScreen(),

        // home: const CropStageScreen(cropName: 'Onion', cropId: 'DnERTpTStF6tBRPFXhPA'),

        // home: const DashBoard(),

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
      ),
    );
  }
}

// admin@gmail.com
// admin#KO


// --web-renderer html

// flutter build web --web-renderer html --release