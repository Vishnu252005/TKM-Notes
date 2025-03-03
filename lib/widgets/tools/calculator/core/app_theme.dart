import 'package:flutter/material.dart';
import 'app_color.dart';

class AppTheme {
  static const fontFamily = 'inter';

  static ThemeData lightThemeData = themeData(lightColorScheme);
  static ThemeData darkThemeData = themeData(darkColorScheme);

  static ThemeData themeData(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      brightness: colorScheme.brightness,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.bg,
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 48,
          color: colorScheme.onSurface,
        ),
        displayMedium: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 38,
          color: colorScheme.onSurface,
        ),
        displaySmall: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 32,
          color: colorScheme.onSurface,
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: colorScheme.onSurface,
        ),
        headlineSmall: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          color: colorScheme.onSurface,
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 18,
          color: colorScheme.onSurface,
        ),
        bodyLarge: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: colorScheme.onSurface,
        ),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: colorScheme.onSurface,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colorScheme.buttonBg,
          foregroundColor: colorScheme.buttonText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: AppColor.primaryLight,
    primary: AppColor.primaryLight,
    secondary: AppColor.secondaryLight,
    background: AppColor.backgroundLight,
    surface: AppColor.surfaceLight,
    brightness: Brightness.light,
  );

  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: AppColor.primaryDark,
    primary: AppColor.primaryDark,
    secondary: AppColor.secondaryDark,
    background: AppColor.backgroundDark,
    surface: AppColor.surfaceDark,
    brightness: Brightness.dark,
  );
}
