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
          slivers: [
            SliverAppBar.large(
              floating: true,
              pinned: true,
              expandedHeight: 160,
              backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 16, bottom: 16, right: 16),
                expandedTitleScale: 1.1,
                centerTitle: false,
                title: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      height: 44,
                      width: constraints.maxWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Engineering',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                              letterSpacing: 1.5,
                              height: 1.0,
                            ),
                          ).animate()
                            .fade(duration: 500.ms)
                            .slideX(begin: -0.2, end: 0),
                          SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.handyman_outlined,
                                size: 16,
                                color: _isDarkMode ? Colors.white70 : Colors.black87,
                              ).animate()
                                .fade(duration: 500.ms, delay: 200.ms)
                                .scale(
                                  begin: const Offset(0.5, 0.5),
                                  end: const Offset(1.0, 1.0),
                                ),
                              SizedBox(width: 4),
                              Text(
                                'Tools Hub',
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _isDarkMode ? Colors.white : Colors.black,
                                  height: 1.1,
                                ),
                              ).animate()
                                .fade(duration: 500.ms, delay: 100.ms)
                                .slideX(begin: -0.2, end: 0),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: _isDarkMode 
                        ? [
                            Colors.grey[900]!,
                            Colors.grey[850]!,
                          ]
                        : [
                            Colors.blue.withOpacity(0.1),
                            Colors.white,
                          ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -20,
                        top: 20,
                        child: Icon(
                          Icons.engineering,
                          size: 120,
                          color: (_isDarkMode ? Colors.white : Colors.black)
                              .withOpacity(0.05),
                        ).animate()
                          .fade(duration: 800.ms)
                          .scale(
                            begin: const Offset(0.5, 0.5),
                            end: const Offset(1.0, 1.0),
                          ),
                      ),
                      Positioned(
                        right: 16,
                        bottom: 70,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                size: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Essential Tools',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ).animate()
                          .fade(duration: 500.ms, delay: 300.ms)
                          .slideX(begin: 0.2, end: 0),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _isDarkMode = !_isDarkMode;
                    });
                  },
                ).animate()
                  .fade(duration: 500.ms)
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1.0, 1.0),
                  ),
                const SizedBox(width: 8),
              ],
            ),
            SliverPadding(
              padding: EdgeInsets.only(
                left: 16, 
                right: 16, 
                top: 8,
                bottom: 16
              ),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                delegate: SliverChildListDelegate([
                  _buildToolCard(
                    context,
                    'Resistance\nCalculator',
                    Icons.calculate_outlined,
                    ResistanceCalculator(),
                    Colors.blue,
                    delay: 0,
                    isDarkMode: _isDarkMode,
                  ),
                  _buildToolCard(
                    context,
                    'Scientific Calculator',
                    Icons.calculate,
                    ScientificCalculator(),
                    Colors.green,
                    delay: 100,
                    isDarkMode: _isDarkMode,
                  ),
                  _buildToolCard(
                    context,
                    'Unit Converter',
                    Icons.swap_horiz,
                    UnitConverter(),
                    Colors.orange,
                    delay: 200,
                    isDarkMode: _isDarkMode,
                  ),
                  _buildToolCard(
                    context,
                    'Number System',
                    Icons.numbers,
                    NumberConverter(),
                    Colors.purple,
                    delay: 300,
                    isDarkMode: _isDarkMode,
                  ),
                  _buildToolCard(
                    context,
                    'Graph Plotter',
                    Icons.show_chart,
                    GraphPlotter(),
                    Colors.red,
                    delay: 400,
                    isDarkMode: _isDarkMode,
                  ),
                  _buildToolCard(
                    context,
                    'Project Ideas',
                    Icons.lightbulb_outline,
                    ProjectIdeaScreen(),
                    Colors.amber,
                    delay: 500,
                    isDarkMode: _isDarkMode,
                  ),
                  _buildToolCard(
                    context,
                    'Resume Generator',
                    Icons.description_outlined,
                    ResumeGenerator(),
                    Colors.teal,
                    delay: 600,
                    isDarkMode: _isDarkMode,
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
    Color color,
    {required int delay, required bool isDarkMode}
  ) {
    return Card(
      elevation: 0,
      color: _isDarkMode ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(_isDarkMode ? 0.2 : 0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _isDarkMode ? Colors.white : Colors.black87,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    )
    .animate()
    .fade(duration: 400.ms, delay: delay.ms)
    .slideY(begin: 0.2, end: 0, duration: 400.ms, delay: delay.ms)
    .scale(
      begin: const Offset(0.8, 0.8),
      end: const Offset(1.0, 1.0),
      duration: 400.ms,
      delay: delay.ms
    );
  }
} 