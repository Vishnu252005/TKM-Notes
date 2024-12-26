import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Added import for flutter_animate

class Waveform extends StatefulWidget {
  @override
  _WaveformState createState() => _WaveformState();
}

class _WaveformState extends State<Waveform> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return BouncingCircle(delay: index * 200)
            .animate(delay: Duration(milliseconds: index * 200)) // Added delay to each animation
            .scale(
              duration: Duration(milliseconds: 1000),
              begin: Offset(0.8, 0.8),
              end: Offset(1.2, 1.2),
              curve: Curves.easeInOut,
            )
            .then() // Chain the next animation
            .scale(
              duration: Duration(milliseconds: 1000),
              begin: Offset(1.2, 1.2),
              end: Offset(0.8, 0.8),
              curve: Curves.easeInOut,
            );
            // .repeatForever(); // Use repeatForever as per flutter_animate v4
      }),
    );
  }
}

class BouncingCircle extends StatefulWidget {
  final int delay;

  BouncingCircle({required this.delay});

  @override
  _BouncingCircleState createState() => _BouncingCircleState();
}

class _BouncingCircleState extends State<BouncingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final curvedAnimation = CurvedAnimation(
          parent: _controller,
          curve: Interval(
            widget.delay / 1000,
            1.0,
            curve: Curves.easeInOut,
          ),
        );

        return Transform.scale(
          scale: 1 + 0.3 * curvedAnimation.value, // Increased scale for more dynamic effect
          child: Transform.translate(
            offset: Offset(0, -150 * (0.5 * (1 - (curvedAnimation.value - 0.5).abs()))),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              width: 12, // Increased size for better visibility
              height: 12,
              decoration: const BoxDecoration(
                color: Colors.blueAccent, // Updated color for better contrast
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent,
                    blurRadius: 4,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
