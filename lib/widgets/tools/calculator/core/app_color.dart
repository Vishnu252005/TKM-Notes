import 'package:flutter/material.dart';

// Main Colors (Primary and Secondary)
class AppColor {
  const AppColor._();

  // Light Theme Colors
  static const primaryLight = Color(0xff6f4ced);
  static const secondaryLight = Color(0xff937CE6);
  static const backgroundLight = Color(0xffEBE5FF);
  static const surfaceLight = Color(0xffFEFEFF);

  // Enhanced Dark Theme Colors
  static const primaryDark = Color(0xff9333EA);    // Rich purple
  static const secondaryDark = Color(0xff6366F1);  // Vibrant indigo
  static const backgroundDark = Color(0xff0B1121); // Deep navy
  static const surfaceDark = Color(0xff1E1B2C);    // Dark purple-gray

  // Enhanced Dark Gradient
  static const darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff6366F1),  // Indigo
      Color(0xff9333EA),  // Purple
      Color(0xffDB2777),  // Pink
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // Light Gradient
  static const lightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff8B5CF6),
      Color(0xff3B82F6),
      Color(0xff10B981),
    ],
  );
}

// Enhanced Color Customization
extension CustomColorScheme on ColorScheme {
  Gradient get gradient => brightness == Brightness.light 
      ? AppColor.lightGradient 
      : AppColor.darkGradient;

  // Enhanced Dark Mode Colors
  Color get gridBg => brightness == Brightness.light
      ? const Color(0xffC9BAFF)
      : const Color(0xff1E1B2C).withOpacity(0.95); // Dark purple-gray

  Color get buttonBg => brightness == Brightness.light 
      ? grey7 
      : const Color(0xff262338).withOpacity(0.95); // Slightly lighter dark purple

  Color get topButtonBg => brightness == Brightness.light 
      ? grey6 
      : const Color(0xff1A1625).withOpacity(0.98); // Darker purple

  Color get bg => brightness == Brightness.light
      ? AppColor.backgroundLight
      : AppColor.backgroundDark;

  Color get cursor => brightness == Brightness.light 
      ? primary 
      : const Color(0xff9333EA); // Rich purple

  Color get historyBorder => brightness == Brightness.light 
      ? secondary 
      : const Color(0xff6366F1); // Vibrant indigo

  Color get historyIcon => brightness == Brightness.light 
      ? grey7 
      : const Color(0xff9333EA); // Rich purple

  Color get historyBg => brightness == Brightness.light 
      ? primary 
      : const Color(0xff1A1625); // Dark purple background

  Color get resultText => brightness == Brightness.light 
      ? primary 
      : const Color(0xff9333EA); // Rich purple

  Color get buttonText => brightness == Brightness.light 
      ? grey2 
      : const Color(0xffE2E8F0).withOpacity(0.95); // Slightly off-white

  Color get opText => brightness == Brightness.light 
      ? grey4 
      : const Color(0xff94A3B8).withOpacity(0.9); // Muted slate

  Color get switchText => brightness == Brightness.light 
      ? grey5 
      : const Color(0xff94A3B8).withOpacity(0.8); // More muted slate

  // Enhanced Glass Effect
  Color get glassBackground => brightness == Brightness.light
      ? Colors.white.withOpacity(0.15)
      : const Color(0xff1A1625).withOpacity(0.45); // Dark purple with transparency

  Color get glassBorder => brightness == Brightness.light
      ? Colors.white.withOpacity(0.25)
      : Colors.white.withOpacity(0.08); // Subtle white border

  // Grays for Dark Mode
  Color get grey1 => brightness == Brightness.light
      ? const Color(0xff171C22)
      : const Color(0xffF1F5F9).withOpacity(0.9); // Slate-100

  Color get grey2 => brightness == Brightness.light
      ? const Color(0xff212A35)
      : const Color(0xffE2E8F0).withOpacity(0.9); // Slate-200

  Color get grey3 => brightness == Brightness.light
      ? const Color(0xff2E3A48)
      : const Color(0xffCBD5E1).withOpacity(0.9); // Slate-300

  Color get grey4 => brightness == Brightness.light
      ? const Color(0xff5A6876)
      : const Color(0xff94A3B8).withOpacity(0.9); // Slate-400

  Color get grey5 => brightness == Brightness.light
      ? const Color(0xff828A93)
      : const Color(0xff64748B).withOpacity(0.9); // Slate-500

  Color get grey6 => brightness == Brightness.light
      ? const Color(0xffEAEBED)
      : const Color(0xff1E1B2C).withOpacity(0.95); // Dark purple-gray

  Color get grey7 => brightness == Brightness.light
      ? const Color(0xffFEFEFF)
      : const Color(0xff0B1121).withOpacity(0.98); // Deep navy
}
