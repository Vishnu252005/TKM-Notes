import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter_animate/flutter_animate.dart';

class PDFGameWidget extends StatefulWidget {
  const PDFGameWidget({Key? key}) : super(key: key);

  @override
  State<PDFGameWidget> createState() => _PDFGameWidgetState();
}

class _PDFGameWidgetState extends State<PDFGameWidget> {
  double rocketX = 0.5;
  List<Map<String, dynamic>> rocks = [];
  List<Map<String, double>> bullets = [];
  List<Map<String, dynamic>> powerUps = []; // For life and shield power-ups
  double score = 0;
  static double highScore = 0;  // Changed to static variable
  int lives = 3;
  bool hasShield = false;
  Timer? shieldTimer;
  bool gameOver = false;
  Timer? gameTimer;

  // Add obstacle types
  final List<Map<String, dynamic>> obstacleTypes = [
    {
      'type': 'asteroid',
      'color': Colors.grey[700],
      'size': 40.0,
      'points': 10,
    },
    {
      'type': 'ufo',
      'color': Colors.green,
      'size': 45.0,
      'points': 20,
    },
    {
      'type': 'satellite',
      'color': Colors.blue,
      'size': 35.0,
      'points': 15,
    },
    {
      'type': 'comet',
      'color': Colors.orange,
      'size': 50.0,
      'points': 25,
    },
  ];

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void updateHighScore() {
    if (score > highScore) {
      setState(() {
        highScore = score;
      });
    }
  }

  void startGame() {
    if (!mounted) return;  // Add this check
    setState(() {
      rocketX = 0.5;
      rocks = [];
      bullets = [];
      powerUps = [];
      score = 0;
      lives = 3;
      hasShield = false;
      gameOver = false;
    });

    // Cancel existing timers
    gameTimer?.cancel();
    
    // Start new game loop
    gameTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (!gameOver) {
        updateGame();
      }
    });

    // Create rocks and power-ups
    Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (!gameOver) {
        setState(() {
          // Randomly select obstacle type
          final obstacleType = obstacleTypes[Random().nextInt(obstacleTypes.length)];
          rocks.add({
            'x': Random().nextDouble(),
            'y': 0.0,
            'type': obstacleType['type'],
            'rotation': 0.0,
            'points': obstacleType['points'],
          });

          // Randomly add power-up (10% chance)
          if (Random().nextDouble() < 0.1) {
            powerUps.add({
              'x': Random().nextDouble(),
              'y': 0.0,
              'type': Random().nextBool() ? 'life' : 'shield',
            });
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  void activateShield() {
    setState(() {
      hasShield = true;
    });
    shieldTimer?.cancel();
    shieldTimer = Timer(const Duration(seconds: 5), () {
      setState(() {
        hasShield = false;
      });
    });
  }

  void shoot() {
    setState(() {
      bullets.add({
        'x': rocketX,
        'y': 0.8,
      });
    });
  }

  void updateGame() {
    if (!mounted) return;  // Add this check
    setState(() {
      // Update bullets
      for (int i = bullets.length - 1; i >= 0; i--) {
        bullets[i]['y'] = bullets[i]['y']! - 0.05;

        if (bullets[i]['y']! < 0) {
          bullets.removeAt(i);
          continue;
        }

        // Check for collisions with rocks
        for (int j = rocks.length - 1; j >= 0; j--) {
          if ((bullets[i]['x']! - rocks[j]['x']!).abs() < 0.05 &&
              (bullets[i]['y']! - rocks[j]['y']!).abs() < 0.05) {
            score += rocks[j]['points'];
            rocks.removeAt(j);
            bullets.removeAt(i);
            break;
          }
        }
      }

      // Update rocks and power-ups
      for (int i = rocks.length - 1; i >= 0; i--) {
        rocks[i]['y'] += 0.02;

        // Check if rock hits rocket
        if ((rocks[i]['x']! - rocketX).abs() < 0.1 && rocks[i]['y']! > 0.8) {
          rocks.removeAt(i);
          if (!hasShield) {
            lives--;
            if (lives <= 0) {
              gameOver = true;
              updateHighScore();
              gameTimer?.cancel();
              return;
            }
          }
          continue;
        }

        if (rocks[i]['y']! > 1) {
          rocks.removeAt(i);
        }
      }

      // Check if widget is still mounted before setting state
      if (!mounted) return;
      
      // Update power-ups
      for (int i = powerUps.length - 1; i >= 0; i--) {
        powerUps[i]['y'] += 0.02;

        // Check if power-up is collected
        if ((powerUps[i]['x']! - rocketX).abs() < 0.1 && powerUps[i]['y']! > 0.8) {
          if (powerUps[i]['type'] == 'life' && lives < 5) {
            lives++;
          } else if (powerUps[i]['type'] == 'shield') {
            activateShield();
          }
          powerUps.removeAt(i);
          continue;
        }

        if (powerUps[i]['y']! > 1) {
          powerUps.removeAt(i);
        }
      }
    });
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    shieldTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (!gameOver) {
          setState(() {
            rocketX += details.delta.dx / MediaQuery.of(context).size.width;
            rocketX = rocketX.clamp(0.1, 0.9);
          });
        }
      },
      onTapDown: (details) {
        if (gameOver) {
          startGame();
        } else {
          // Calculate tap position relative to screen width
          final tapPositionX = details.localPosition.dx / MediaQuery.of(context).size.width;
          final tapPositionY = details.localPosition.dy / MediaQuery.of(context).size.height;
          
          // Only move rocket if tap is in bottom 30% of screen
          if (tapPositionY > 0.7) {
            setState(() {
              // Move rocket to tap position (with bounds)
              rocketX = tapPositionX.clamp(0.1, 0.9);
            });
          }
          
          // Shoot regardless of tap position
          shoot();
        }
      },
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            // Score and High Score
            Positioned(
              top: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Score: ${score.toInt()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ).animate()
                    .fadeIn()
                    .slideX(),
                  Text(
                    'High Score: ${highScore.toInt()}',
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                    ),
                  ).animate()
                    .fadeIn()
                    .slideX(),
                ],
              ),
            ),

            // Lives
            Positioned(
              top: 20,
              left: 20,
              child: Row(
                children: [
                  ...List.generate(5, (index) => buildLife(index < lives)),
                  if (hasShield)
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.shield,
                        color: Colors.blue,
                        size: 24,
                      ),
                    ),
                ],
              ),
            ),

            // Power-ups
            ...powerUps.map((powerUp) => Positioned(
                  left: MediaQuery.of(context).size.width * powerUp['x'] - 15,
                  top: MediaQuery.of(context).size.height * powerUp['y'] - 15,
                  child: Icon(
                    powerUp['type'] == 'life' ? Icons.favorite : Icons.shield,
                    color: powerUp['type'] == 'life' ? Colors.red : Colors.blue,
                    size: 30,
                  ).animate()
                    .fade()
                    .scale()
                    .shimmer(),
                )),

            // Bullets, rocks, and rocket (unchanged)
            ...bullets.map((bullet) => Positioned(
                  left: MediaQuery.of(context).size.width * bullet['x']! - 2,
                  top: MediaQuery.of(context).size.height * bullet['y']!,
                  child: Container(
                    width: 4,
                    height: 15,
                    decoration: const BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ).animate()
                    .fadeIn()
                    .scale(),
                )),

            ...rocks.map((rock) => Positioned(
                  left: MediaQuery.of(context).size.width * rock['x'] - 20,
                  top: MediaQuery.of(context).size.height * rock['y'] - 20,
                  child: buildObstacle(rock),
                )),

            // Rocket with effects
            Positioned(
              left: MediaQuery.of(context).size.width * rocketX - 30,
              bottom: 20,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Shield effect
                  if (hasShield)
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.blue.withOpacity(0.3),
                            Colors.blue.withOpacity(0.1),
                            Colors.blue.withOpacity(0.05),
                          ],
                        ),
                      ),
                    ),

                  // Engine flames
                  Positioned(
                    bottom: -20,
                    child: Container(
                      width: 30,
                      height: 40,
                      child: Stack(
                        children: [
                          // Main flame
                          CustomPaint(
                            size: Size(30, 40),
                            painter: RocketFlamePainter(
                              colors: [
                                Colors.white,
                                Colors.blue,
                                Colors.purple.withOpacity(0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          // Side flames
                          Positioned(
                            left: -10,
                            child: CustomPaint(
                              size: Size(15, 25),
                              painter: RocketFlamePainter(
                                colors: [
                                  Colors.white,
                                  Colors.blue.withOpacity(0.7),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: -10,
                            child: CustomPaint(
                              size: Size(15, 25),
                              painter: RocketFlamePainter(
                                colors: [
                                  Colors.white,
                                  Colors.blue.withOpacity(0.7),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Main rocket body
                  Container(
                    width: 60,
                    height: 80,
                    child: Stack(
                      children: [
                        // Main body with gradient
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.purple[800]!,
                                Colors.purple[600]!,
                                Colors.blue[600]!,
                                Colors.blue[400]!,
                              ],
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),

                        // Cockpit
                        Positioned(
                          top: 15,
                          left: 15,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  Colors.lightBlueAccent.withOpacity(0.9),
                                  Colors.blue.withOpacity(0.3),
                                ],
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.5),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Wings
                        Positioned(
                          bottom: 10,
                          left: -10,
                          child: Transform.rotate(
                            angle: -0.3,
                            child: Container(
                              width: 25,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.purple[800]!, Colors.blue[400]!],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: -10,
                          child: Transform.rotate(
                            angle: 0.3,
                            child: Container(
                              width: 25,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.purple[800]!, Colors.blue[400]!],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Decorative details
                        Positioned(
                          bottom: 30,
                          left: 10,
                          child: Container(
                            width: 40,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 40,
                          left: 15,
                          child: Container(
                            width: 30,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Game Over overlay
            if (gameOver)
              Container(
                color: Colors.black.withOpacity(0.8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Game Over!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate()
                        .fade()
                        .scale()
                        .then()
                        .shake(),
                      const SizedBox(height: 20),
                      Text(
                        'Score: ${score.toInt()}\nHigh Score: ${highScore.toInt()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              startGame();
                            },
                            icon: const Icon(Icons.replay),
                            label: const Text('Play Again'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context); // Return to PDF viewer
                            },
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text('Load PDF'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Tip: Collect shields and hearts for power-ups!',
                        style: const TextStyle(
                          color: Colors.yellow,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate()
                .fadeIn(),
          ],
        ),
      ),
    );
  }

  Widget buildLife(bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Icon(
        Icons.favorite,
        color: isActive ? Colors.red : Colors.grey,
        size: 20,
      ),
    );
  }

  // Add this method to build different obstacles
  Widget buildObstacle(Map<String, dynamic> obstacle) {
    switch (obstacle['type']) {
      case 'asteroid':
        return Transform.rotate(
          angle: obstacle['rotation'] ?? 0.0,
          child: CustomPaint(
            size: Size(40, 40),
            painter: AsteroidPainter(),
          ),
        );
      
      case 'ufo':
        return Container(
          width: 45,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: 35,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.lightGreenAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        );

      case 'satellite':
        return Transform.rotate(
          angle: obstacle['rotation'] ?? 0.0,
          child: Stack(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.blue[800],
                  shape: BoxShape.circle,
                ),
              ),
              Positioned(
                left: -15,
                top: 15,
                child: Container(
                  width: 65,
                  height: 5,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
        );

      case 'comet':
        return CustomPaint(
          size: Size(50, 50),
          painter: CometPainter(),
        );

      default:
        return Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
        );
    }
  }
}

// Custom painter for asteroid
class AsteroidPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[700]!
      ..style = PaintingStyle.fill;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (var i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      final variation = Random().nextDouble() * 5;
      final x = center.dx + cos(angle) * (radius + variation);
      final y = center.dy + sin(angle) * (radius + variation);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);

    // Add crater details
    paint.color = Colors.grey[600]!;
    canvas.drawCircle(
      Offset(center.dx - 5, center.dy - 5),
      5,
      paint,
    );
    canvas.drawCircle(
      Offset(center.dx + 8, center.dy + 8),
      4,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for comet
class CometPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.7, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.5,
      size.width * 0.1,
      size.height * 0.8,
    );
    
    // Comet tail gradient
    final gradient = RadialGradient(
      colors: [Colors.orange, Colors.orange.withOpacity(0)],
      stops: [0.3, 1.0],
    );
    
    paint.shader = gradient.createShader(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );
    
    canvas.drawPath(path, paint);

    // Comet head
    paint.shader = null;
    paint.color = Colors.orangeAccent;
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.3),
      10,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class RocketFlamePainter extends CustomPainter {
  final List<Color> colors;

  RocketFlamePainter({
    this.colors = const [
      Colors.white,
      Colors.blue,
      Colors.purple,
      Colors.transparent,
    ],
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);

    // Create animated-looking flame effect
    for (var i = 0; i < 12; i++) {
      final x = size.width / 2 + sin(i * 0.5) * (size.width / 3);
      final y = size.height * (0.2 + Random().nextDouble() * 0.8);
      path.lineTo(x, y);
    }

    path.close();

    // Create flame gradient
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: colors,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    paint.shader = gradient;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

