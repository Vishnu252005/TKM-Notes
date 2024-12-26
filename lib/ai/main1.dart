import 'package:flutter/material.dart';
import '/ai/screens/SplashScreen.dart';
import '/ai/constants/const.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'screens/HomePage.dart';

void main(){
  Gemini.init(apiKey: "AIzaSyDqPfAa1C8sn2hDKLFpMTeiavIHg2vf_C8");
  runApp(GeminiChat());
}

class GeminiChat extends StatelessWidget {
  const GeminiChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

