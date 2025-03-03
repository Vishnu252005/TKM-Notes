import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../core/index.dart';
import '../helpers/style_logic.dart';
import '../providers/calculations.dart';
import '../providers/history.dart';

class Button extends StatelessWidget {
  const Button(this.text, {Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final calc = Provider.of<Calculations>(context, listen: false);
    final history = Provider.of<History>(context, listen: false);
    
    Widget buttonContent = Container(
      margin: const EdgeInsets.all(3),
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: text == '=' ? colorScheme.gradient : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            calc.onButtonPressed(text);
            if (text == '=') {
              history.addHistoryItem(calc.input, calc.result);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: getButtonBgColor(text, context),
            ),
            child: Center(
              child: FittedBox(
                child: getOnButtonWidget(text, context),
              ),
            ),
          ),
        ),
      ),
    );

    // Add animations
    buttonContent = buttonContent
      .animate()
      .fadeIn(duration: const Duration(milliseconds: 200))
      .scale(duration: const Duration(milliseconds: 200));

    // Add shimmer effect for certain buttons
    if (text == '=' || text == 'C') {
      buttonContent = buttonContent
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .shimmer(
          duration: const Duration(seconds: 2),
          delay: const Duration(seconds: 3),
        );
    }

    return Expanded(child: buttonContent);
  }
}
