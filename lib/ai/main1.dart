import 'package:flutter/material.dart';
import '/ai/SplashScreen.dart';
import '/ai/const.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import '/ai/HomePage.dart';

void main(){
  Gemini.init(apiKey: "AIzaSyDqPfAa1C8sn2hDKLFpMTeiavIHg2vf_C8");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

