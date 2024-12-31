import 'package:adminpannal/Screens/Crops/controller/crop_provider.dart';
import 'package:adminpannal/Screens/Crops/edit_crop_details.dart';
import 'package:adminpannal/Screens/Dashboard/dashboard.dart';
import 'package:adminpannal/Screens/Krishi%20News/controller/krishi_news_provider.dart';
import 'package:adminpannal/Screens/ksk_review/controller/ksk_review_controller.dart';
import 'package:adminpannal/Screens/prouct_catagory/controller/prouduct_catagory_controller.dart';
import 'package:adminpannal/config/themes/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        ChangeNotifierProvider(create: (_) => KskReviewController()),
        ChangeNotifierProvider(create: (_) => ProuductCatagoryController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Krishi Seva Kendra Admin',
        theme: AppTheme.basic,
        home: const DashBoard(),
      ),
    );
  }
}
