import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../calcu.dart'; // Adjust the path as necessary
import '../conv.dart'; // Adjust the path as necessary
import '../graph.dart'; // Adjust the path as necessary
import 'resistance_calculator.dart'; // Import the new resistance calculator
import 'unit_converter.dart'; // Import the unit converter
import 'project_idea.dart'; // Import the ProjectIdeaScreen
import 'resume_generator.dart'; // Import the ResumeGenerator
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
// import 'resume/screen/on_boarding/on_boarding_page.dart';

class ToolsScreen extends StatefulWidget {
  @override
  _ToolsScreenState createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  bool _isDarkMode = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Update the tools list with better search terms
  final List<Map<String, dynamic>> _allTools = [
    {
      'title': 'Resistance\nCalculator',
      'searchTerms': 'resistance calculator ohm voltage current electric',
      'icon': Icons.calculate_outlined,
      'screen': ResistanceCalculator(),
    },
    {
      'title': 'Scientific\nCalculator',
      'searchTerms': 'scientific calculator math mathematics compute',
      'icon': Icons.calculate,
      'screen': ScientificCalculator(),
    },
    {
      'title': 'Unit\nConverter',
      'searchTerms': 'unit converter conversion measure measurement',
      'icon': Icons.swap_horiz,
      'screen': UnitConverter(),
    },
    {
      'title': 'Number\nSystem',
      'searchTerms': 'number system binary decimal hexadecimal octal',
      'icon': Icons.numbers,
      'screen': NumberConverter(),
    },
    {
      'title': 'Graph\nPlotter',
      'searchTerms': 'graph plot chart plotting visualization',
      'icon': Icons.show_chart,
      'screen': GraphPlotter(),
    },
    {
      'title': 'Project\nIdeas',
      'searchTerms': 'project ideas inspiration engineering projects',
      'icon': Icons.lightbulb_outline,
      'screen': ProjectIdeaScreen(),
    },
    {
      'title': 'Resume\nGenerator',
      'searchTerms': 'resume cv curriculum vitae generator builder',
      'icon': Icons.description_outlined,
      'screen': ResumeGenerator(),
    },
  ];

  // Improved filtering with search terms
  List<Map<String, dynamic>> get _filteredTools {
    if (_searchQuery.isEmpty) {
      return _allTools;
    }
    final query = _searchQuery.toLowerCase();
    return _allTools.where((tool) {
      final title = tool['title'].toString().toLowerCase();
      final searchTerms = tool['searchTerms'].toString().toLowerCase();
      return title.contains(query) || searchTerms.contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    // Add listener to search controller
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Update the search bar in _buildHeaderContent()
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search tools...',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.5),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white.withOpacity(0.7),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    ).animate()
      .fadeIn(delay: 400.ms)
      .slideX(begin: 0.2);
  }

  // Update the grid to show a message when no results are found
  Widget _buildToolsGrid() {
    if (_filteredTools.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: _isDarkMode 
                    ? Colors.white.withOpacity(0.5)
                    : Colors.blue.withOpacity(0.5),
              ),
              SizedBox(height: 16),
              Text(
                'No tools found',
                style: TextStyle(
                  fontSize: 18,
                  color: _isDarkMode 
                      ? Colors.white.withOpacity(0.5)
                      : Colors.blue.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final tool = _filteredTools[index];
            return _buildEnhancedToolCard(
              context,
              tool['title'],
              tool['icon'],
              tool['screen'],
              delay: index * 100,
            );
          },
          childCount: _filteredTools.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Color(0xFF1A1A2E) : Colors.blue[50],
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: DotPatternPainter(
                color: _isDarkMode 
                    ? Colors.white.withOpacity(0.03)
                    : Colors.blue.withOpacity(0.05),
              ),
            ),
          ),

          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              // Enhanced Glass Effect Header
              SliverAppBar(
                automaticallyImplyLeading: false,
                floating: true,
                pinned: true,
                expandedHeight: 320,
                backgroundColor: Colors.transparent,
                flexibleSpace: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: FlexibleSpaceBar(
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isDarkMode 
                                ? [Color(0xFF4C4DDC), Color(0xFF1A1A2E)]
                                : [Colors.blue[400]!, Colors.blue[100]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: _buildHeaderContent(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Enhanced Tool Grid
              _buildToolsGrid(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
                        child: Padding(
              padding: EdgeInsets.only(bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                              Icons.build_rounded,
                              color: Colors.white,
                              size: 16,
                                        ),
                                        SizedBox(width: 8),
                                  Text(
                                    'TOOLS',
                                    style: TextStyle(
                                color: Colors.white,
                                      fontSize: 14,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildThemeToggle(),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Engineering\nToolkit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Essential tools for engineering calculations',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildSearchBar(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedToolCard(
    BuildContext context,
    String title,
    IconData icon,
    Widget destination,
    {required int delay}
  ) {
    return Container(
      decoration: BoxDecoration(
        color: _isDarkMode ? Color(0xFF252542) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isDarkMode 
              ? Color(0xFF4C4DDC).withOpacity(0.2)
              : Colors.blue.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _isDarkMode 
                ? Colors.black.withOpacity(0.3)
                : Colors.blue.withOpacity(0.1),
            offset: Offset(4, 4),
            blurRadius: 15,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(_isDarkMode ? 0.1 : 1),
            offset: Offset(-4, -4),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isDarkMode 
                        ? Color(0xFF4C4DDC).withOpacity(0.1)
                        : Colors.blue[50],
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: _isDarkMode 
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 0,
                              offset: Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Icon(
                  icon,
                  size: 32,
                    color: _isDarkMode 
                        ? Color(0xFF4C4DDC)
                        : Colors.blue[700],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode 
                        ? Colors.white
                        : Colors.blue[800],
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate()
    .fade(duration: 800.ms, delay: delay.ms)
      .slideY(begin: 0.2, end: 0);
  }

  Widget _buildThemeToggle() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _isDarkMode 
            ? Colors.white.withOpacity(0.15)
            : Colors.blue.withOpacity(0.15),
      ),
      child: IconButton(
        icon: Icon(
          _isDarkMode ? Icons.light_mode : Icons.dark_mode,
          color: Colors.white,
        ),
        onPressed: () {
          setState(() {
            _isDarkMode = !_isDarkMode;
          });
        },
      ),
    );
  }
}

// Add the DotPatternPainter class if not already present
class DotPatternPainter extends CustomPainter {
  final Color color;
  
  DotPatternPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final double spacing = 20;
    final double radius = 1;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
} 