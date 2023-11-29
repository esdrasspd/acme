import 'dart:io';

import 'package:encuesta/screens/add_survey_screen.dart';
import 'package:encuesta/screens/home_screen.dart';
import 'package:encuesta/screens/login_screen.dart';
import 'package:encuesta/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyCkqIhszyQF3NncoLD07trry94Cp-jc2ZQ',
            appId: '1:821916941556:android:d31eefa06a913ebee7f2a1',
            messagingSenderId: '821916941556',
            projectId: 'encuesta-5cbfa',
          ),
        )
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Encuesta',
      home: const SplashScreen(
        child: LoginScreen(),
      ),
      routes: {
        '/home': (context) => HomeScreen(),
        '/addSurvey': (context) => AddSurveyScreen(),
      },
    );
  }
}
