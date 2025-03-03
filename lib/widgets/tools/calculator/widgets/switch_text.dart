import 'package:flutter/material.dart';
import '../core/index.dart';

class SwitchText extends StatelessWidget {
  const SwitchText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        isDark ? 'Dark Mode' : 'Light Mode',
        style: TextStyle(
          color: colorScheme.switchText,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}