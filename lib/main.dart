import 'package:eco_app_2/const.dart';
import 'package:eco_app_2/homepage.dart';
import 'package:eco_app_2/park.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  Gemini.init(apiKey: GEMINI_API_KEY);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: Homepage(),
        routes: {
          '/home': (context) =>Homepage(),
          '/park': (context) =>const ParkPage()
        },);
  }
}