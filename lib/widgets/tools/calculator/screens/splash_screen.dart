import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/index.dart';
import '../animations/fade_transition.dart';
import 'home_screen.dart';
import 'providers/calculations.dart';
import 'providers/history.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1300)).then(
      (value) => Navigator.of(context).pushReplacement(
        CustomRoute(
          builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => Calculations()),
              ChangeNotifierProvider(create: (_) => History()),
            ],
            child: const HomeScreen(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            children: [
              Image.asset(isDarkMode ? AppIcon.logoDark : AppIcon.logoWhite,
                  height: 130, width: 130),
              const SizedBox(height: 15),
              Text(
                'Calculator',
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                'A Fully Functional Calculator App\nMade Using Flutter\nBy Pabitra Banerjee!',
                style: theme.textTheme.bodySmall!.copyWith(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
