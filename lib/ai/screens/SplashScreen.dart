import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.network(
            "https://lottie.host/your-upgraded-animation.json", // Updated Lottie animation URL
            fit: BoxFit.contain,
            width: 300,
            height: 300,
          ),
        ],
      ),
      nextScreen: HomePage(),
      duration: 4000,
      splashIconSize: 400,
      backgroundColor: Colors.blue.shade900, // Darker shade for better contrast
      centered: true,
    );
  }
}
