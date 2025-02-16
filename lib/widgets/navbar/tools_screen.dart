import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../calcu.dart'; // Adjust the path as necessary
import '../conv.dart'; // Adjust the path as necessary
import '../graph.dart'; // Adjust the path as necessary
import 'resistance_calculator.dart'; // Import the new resistance calculator
import 'unit_converter.dart'; // Import the unit converter
import 'project_idea.dart'; // Import the ProjectIdeaScreen
import 'resume_generator.dart'; // Import the ResumeGenerator
// import 'resume/screen/on_boarding/on_boarding_page.dart';

class ToolsScreen extends StatefulWidget {
  @override
  _ToolsScreenState createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              expandedHeight: 260,
              backgroundColor: Color(0xFF0A192F),
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF0A192F),
                        Color(0xFF1E3A8A),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Decorative overlay
                      Positioned.fill(
                        child: ShaderMask(
                          blendMode: BlendMode.softLight,
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Color(0xFF60A5FA).withOpacity(0.1),
                              ],
                            ).createShader(bounds);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Color(0xFF60A5FA).withOpacity(0.05),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Content
                      SafeArea(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xFF60A5FA).withOpacity(0.3),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.engineering,
                                          color: Color(0xFF60A5FA),
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'ENGINEERING',
                                          style: TextStyle(
                                            color: Color(0xFF60A5FA),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ).animate()
                                    .fade(duration: 800.ms)
                                    .slideX(begin: -0.2, end: 0),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xFF60A5FA).withOpacity(0.3),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        _isDarkMode 
                                          ? Icons.light_mode_rounded
                                          : Icons.dark_mode_rounded,
                                        color: Color(0xFF60A5FA),
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isDarkMode = !_isDarkMode;
                                        });
                                      },
                                      tooltip: _isDarkMode 
                                          ? 'Switch to Light Mode' 
                                          : 'Switch to Dark Mode',
                                    ),
                                  ).animate()
                                    .fade(duration: 800.ms)
                                    .scale(
                                      begin: const Offset(0.8, 0.8),
                                      end: const Offset(1.0, 1.0),
                                    ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TOOLS',
                                    style: TextStyle(
                                      color: Color(0xFF60A5FA),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 4,
                                    ),
                                  ).animate()
                                    .fade(duration: 800.ms, delay: 200.ms)
                                    .slideY(begin: 0.2, end: 0),
                                  SizedBox(height: 4),
                                  Text(
                                    'ENGINEERING\nARSENAL',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      height: 1.1,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1,
                                    ),
                                  ).animate()
                                    .fade(duration: 800.ms, delay: 400.ms)
                                    .slideY(begin: 0.2, end: 0),
                                  SizedBox(height: 12),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF60A5FA).withOpacity(0.1),
                                      border: Border.all(
                                        color: Color(0xFF60A5FA).withOpacity(0.3),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'ESSENTIAL TOOLKIT',
                                      style: TextStyle(
                                        color: Color(0xFF60A5FA),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
                delegate: SliverChildListDelegate([
                  _buildToolCard(
                    context,
                    'Resistance\nCalculator',
                    Icons.calculate_outlined,
                    ResistanceCalculator(),
                    gradient: [Color(0xFF4158D0), Color(0xFFC850C0)],
                    delay: 0,
                  ),
                  _buildToolCard(
                    context,
                    'Scientific\nCalculator',
                    Icons.calculate,
                    ScientificCalculator(),
                    gradient: [Color(0xFF00B4DB), Color(0xFF0083B0)],
                    delay: 100,
                  ),
                  _buildToolCard(
                    context,
                    'Unit\nConverter',
                    Icons.swap_horiz,
                    UnitConverter(),
                    gradient: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
                    delay: 200,
                  ),
                  _buildToolCard(
                    context,
                    'Number\nSystem',
                    Icons.numbers,
                    NumberConverter(),
                    gradient: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                    delay: 300,
                  ),
                  _buildToolCard(
                    context,
                    'Graph\nPlotter',
                    Icons.show_chart,
                    GraphPlotter(),
                    gradient: [Color(0xFF11998E), Color(0xFF38EF7D)],
                    delay: 400,
                  ),
                  _buildToolCard(
                    context,
                    'Project\nIdeas',
                    Icons.lightbulb_outline,
                    ProjectIdeaScreen(),
                    gradient: [Color(0xFFF7971E), Color(0xFFFFD200)],
                    delay: 500,
                  ),
                  _buildToolCard(
                    context,
                    'Resume\nGenerator',
                    Icons.description_outlined,
                    ResumeGenerator(),
                    gradient: [Color(0xFF06BEB6), Color(0xFF48B1BF)],
                    delay: 600,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context,
    String title,
    IconData icon,
    Widget destination,
    {required List<Color> gradient, required int delay}
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFF1E3A8A),
        border: Border.all(
          color: Color(0xFF60A5FA).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E3A8A),
                  Color(0xFF0A192F),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: Color(0xFF60A5FA),
                ),
                SizedBox(height: 16),
                Text(
                  title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 1,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
    .animate()
    .fade(duration: 800.ms, delay: delay.ms)
    .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: delay.ms)
    .scale(
      begin: const Offset(0.95, 0.95),
      end: const Offset(1.0, 1.0),
      duration: 600.ms,
      delay: delay.ms,
    );
  }
} 