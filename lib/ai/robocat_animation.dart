import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveAnimationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤖 Robocat Animation'), // Updated title with emoji
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: RiveAnimation.asset(
          'assets/animations/robocat.riv', // Path to your .riv file
          fit: BoxFit.contain,
          stateMachines: ['Facial Expressions'], // State machine name
          onInit: (artboard) {
            final controller = StateMachineController.fromArtboard(
              artboard,
              'Facial Expressions', // State machine
            );
            if (controller != null) {
              artboard.addController(controller);
              controller.findInput<bool>('Face to chat')?.value = true;
            }
          },
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: RiveAnimationPage(),
//   ));
// }
