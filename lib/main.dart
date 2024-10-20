import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'constants/app_colors.dart';
import 'firebase_options.dart';
import 'home_page/vc_memo_list.dart';
import 'onbording_screens/introduction_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Ern u',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.kPrimary,),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home:   const OnBoardingScreen(),
      // home:   const VCMemList(),
    );
  }
}


