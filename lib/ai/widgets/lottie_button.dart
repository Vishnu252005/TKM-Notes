import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieButton extends StatelessWidget {
  final double size;

  const LottieButton({Key? key, this.size = 80.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.network(
      'https://lottie.host/your-upgraded-animation.json',  // Updated Lottie animation URL
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }
}
