import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/index.dart';
import 'providers/calculations.dart';
import 'providers/history.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';

class CalculatorWidget extends StatelessWidget {
  const CalculatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Calculations()),
        ChangeNotifierProvider(create: (_) => History()),
        ChangeNotifierProvider(create: (_) => ThemeProvider(ThemeMode.system)),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return Theme(
            data: themeProvider.themeMode == ThemeMode.dark 
                ? AppTheme.darkThemeData 
                : AppTheme.lightThemeData,
            child: const HomeScreen(),
          );
        },
      ),
    );
  }
}
