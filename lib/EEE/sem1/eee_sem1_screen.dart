import 'package:Nexia/ai/widgets/robocat_animation.dart';
import 'package:flutter/material.dart';
import 'package:Nexia/EEE/sem1/BEE/bee%20-%20Copy.dart';
import 'package:Nexia/EEE/sem1/BME/bme%20-%20Copy.dart';
import 'package:Nexia/EEE/sem1/ENGLISH/english%20-%20Copy.dart';
import 'package:Nexia/EEE/sem1/FEC/fec%20-%20Copy.dart';
import 'package:Nexia/EEE/sem1/FEC/fec.dart';
import 'package:Nexia/EEE/sem1/IDEALAB/idealab%20-%20Copy.dart';
import 'package:Nexia/EEE/sem1/MATHS/maths%20-%20Copy.dart';
import 'package:Nexia/EEE/sem1/MATHS/maths.dart';
import 'package:Nexia/EEE/sem1/BEE/bee.dart';
import 'package:Nexia/EEE/sem1/BME/bme.dart';
import 'package:Nexia/EEE/sem1/PHYSICS/physics%20-%20Copy.dart';
import 'package:Nexia/EEE/sem1/PHYSICS/physics.dart';
import 'package:Nexia/EEE/sem1/ENGLISH/english.dart';
import 'package:Nexia/EEE/sem1/IDEALAB/idealab.dart';
import 'package:Nexia/widgets/profiledark.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../../ai/screens/HomePage.dart';
import '../../ai/widgets/lottie_button.dart';
import 'package:Nexia/widgets/tools/ai/ai_screen.dart';
import 'package:Nexia/widgets/navbar/profile_screen.dart';
import 'package:Nexia/widgets/navbar/tools_screen.dart';
import 'package:Nexia/widgets/navbar/home_screen.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';

class EEESem1Screen extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const EEESem1Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _EEESem1ScreenState createState() => _EEESem1ScreenState();
}

class _EEESem1ScreenState extends State<EEESem1Screen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Notes & Books', 'PYQs'];
  bool _isDarkMode = true;
  late Map<String, List<Map<String, dynamic>>> _subjects;
  int _currentIndex = 0; // Track the current index of the bottom navigation bar
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _initializeSubjects();
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    });
  }

  void _initializeSubjects() {
    _subjects = {
      'Notes & Books': [
        {
          'name': 'Calculus and Linear Algebra',
          'description': 'Study of calculus and linear algebra including...',
          'image': 'assets/s1.png',
          'page': ({required String fullName, required String branch, required String year, required String semester, required String subjectName}) => 
              maths(
                fullName: fullName,
                branch: branch,
                year: year,
                semester: semester,
                subjectName: subjectName,
              ),
        },
        {
          'name': 'Engineering Physics',
          'description': 'Exploration of fundamental concepts in physics...',
          'image': 'assets/s1.png',
          'page': ({required String fullName, required String branch, required String year, required String semester, required String subjectName}) => 
              physics(
                fullName: fullName,
                branch: branch,
                year: year,
                semester: semester,
                subjectName: subjectName,
              ),
        },
        {
          'name': 'Fundamentals of Electronics Engineering',
          'description': 'Basics of electronics and electrical engineering...',
          'image': 'assets/s1.png',
          'page': ({required String fullName, required String branch, required String year, required String semester, required String subjectName}) => 
              fec(
                fullName: fullName,
                branch: branch,
                year: year,
                semester: semester,
                subjectName: subjectName,
              ),
        },
        {
          'name': 'Technical English for Engineers',
          'description': 'Improving technical communication skills...',
          'image': 'assets/s1.png',
          'page': ({required String fullName, required String branch, required String year, required String semester, required String subjectName}) => 
              english(
                fullName: fullName,
                branch: branch,
                year: year,
                semester: semester,
                subjectName: subjectName,
              ),
        },
        {
          'name': 'IDEA Lab',
          'description': 'Hands-on workshop focusing on innovative design...',
          'image': 'assets/s1.png',
          'page': ({required String fullName, required String branch, required String year, required String semester, required String subjectName}) => 
              idea(
                fullName: fullName,
                branch: branch,
                year: year,
                semester: semester,
                subjectName: subjectName,
              ),
        },
        {
          'name': 'Basics of Electrical Engineering',
          'description': 'Introduction to electrical engineering principles...',
          'image': 'assets/s1.png',
          'page': ({required String fullName, required String branch, required String year, required String semester, required String subjectName}) => 
              Bee(
                fullName: fullName,
                branch: branch,
                year: year,
                semester: semester,
                subjectName: subjectName,
              ),
        },
        {
          'name': 'Basic Mechanical Engineering',
          'description': 'Fundamental concepts in mechanical engineering...',
          'image': 'assets/s1.png',
          'page': ({required String fullName, required String branch, required String year, required String semester, required String subjectName}) => 
              bme(
                fullName: fullName,
                branch: branch,
                year: year,
                semester: semester,
                subjectName: subjectName,
              ),
        },
      ],
      'PYQs': [
        {
          'name': 'Calculus and Linear Algebra PYQs',
          'description': 'Previous Year Questions for Calculus and Linear Algebra...',
          'image': 'assets/s2.png',
          'page': ({required String fullName, required String branch, required String year, required String semester, required String subjectName}) => 
              maths1(
                fullName: fullName,
                branch: branch,
                year: year,
                semester: semester,
                subjectName: subjectName,
              ),
        },
        {
          'name': 'Engineering Physics PYQs',
          'description': 'Previous Year Questions for Engineering Physics...',
          'image': 'assets/s2.png',
          'page': ({required String fullName, required String branch, required String year, required String semester, required String subjectName}) => 
              physics1(
                fullName: fullName,
                branch: branch,
                year: year,
                semester: semester,
                subjectName: subjectName,
              ),
        },
        {
          'name': 'Fundamentals of Electronics Engineering PYQs',
          'description': 'Previous Year Questions for Electronics Engineering...',
          'image': 'assets/s2.png',
          'page': ({required String fullName, required String branch, required String year, required String semester, required String subjectName}) => 
              fec1(
                fullName: fullName,
                branch: branch,
                year: year,
                semester: semester,
                subjectName: subjectName,
              ),
        },
        {
          'name': 'Technical English for Engineers PYQs',
          'description': 'Previous Year Questions for Technical English...',
          'image': 'assets/s2.png',
          'page': ({required String fullName, required String branch, required String year, required String semester, required String subjectName}) => 
              english1(
                fullName: fullName,
                branch: branch,
                year: year,
                semester: semester,
                subjectName: subjectName,
              ),
        },
        {
          'name': 'IDEA Lab  PYQs',
          'description': 'Previous Year Questions for IDEA Lab Workshop...',
          'image': 'assets/s2.png',
          'page': ({required String fullName, required String branch, required String year, required String semester, required String subjectName}) => 
              idea1(
                fullName: fullName,
                branch: branch,
                year: year,
                semester: semester,
                subjectName: subjectName,
              ),
        },
        {
          'name': 'Basics of Electrical Engineering PYQs',
          'description': 'Previous Year Questions for Electrical Engineering...',
          'image': 'assets/s2.png',
          'page': ({required String fullName, required String branch, required String year, required String semester, required String subjectName}) => 
              Bee1(
                fullName: fullName,
                branch: branch,
                year: year,
                semester: semester,
                subjectName: subjectName,
              ),
        },
        {
          'name': 'Basic Mechanical Engineering PYQs',
          'description': 'Previous Year Questions for Mechanical Engineering...',
          'image': 'assets/s2.png',
          'page': ({required String fullName, required String branch, required String year, required String semester, required String subjectName}) => 
              bme1(
                fullName: fullName,
                branch: branch,
                year: year,
                semester: semester,
                subjectName: subjectName,
              ),
        },
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isPortrait = screenSize.height > screenSize.width;

    return Scaffold(
      backgroundColor: _isDarkMode ? Color(0xFF1A1A2E) : Color(0xFFF0F8FF),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Main content (current screen)
          SafeArea(
            child: Stack(
          children: [
                // Add a decorative background pattern
                Positioned.fill(
                  child: _isDarkMode
                      ? CustomPaint(
                          painter: DotPatternPainter(
                            color: Colors.white.withOpacity(0.03),
                          ),
                        )
                      : CustomPaint(
                          painter: DotPatternPainter(
                            color: Colors.blue.withOpacity(0.05),
                          ),
                        ),
                ),
                
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    // Enhanced Header with Glass Effect
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                  padding: EdgeInsets.all(isPortrait ? 24.0 : 16.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _isDarkMode 
                                  ? [
                                      Color(0xFF4C4DDC).withOpacity(0.9),
                                      Color(0xFF1A1A2E).withOpacity(0.9),
                                    ]
                                  : [
                                      Colors.blue[400]!.withOpacity(0.9),
                                      Colors.blue[100]!.withOpacity(0.9),
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Hey ',
                                              style: TextStyle(
                                                fontSize: isPortrait ? 28 : 24,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                            Text(
                                              widget.fullName,
                              style: TextStyle(
                                                fontSize: isPortrait ? 28 : 24,
                                  fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.school,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                '${widget.branch} - Sem ${widget.semester}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _buildProfileAvatar(isPortrait),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Enhanced Tab Selector with Neumorphic Effect
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isDarkMode ? Color(0xFF252542) : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: _isDarkMode 
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.2),
                              offset: Offset(4, 4),
                              blurRadius: 15,
                              spreadRadius: 1,
                            ),
                            BoxShadow(
                              color: _isDarkMode 
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.white,
                              offset: Offset(-4, -4),
                              blurRadius: 15,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: _buildTabSelector(),
                      ),
                    ),

                    // Enhanced Search Bar
                    _buildSearchBar(),

                    // Enhanced Subject List
                    Expanded(
                      child: _buildSubjectsList(),
                    ),
                  ],
                ),

                // AI Assistant button
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: _buildAIAssistantButton(),
                ),
              ],
            ),
          ),
          // Other screens
          AIScreen(),
          ToolsScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildProfileAvatar(bool isPortrait) {
    return GestureDetector(
      onTap: () => _navigateToProfile(),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
                        child: CircleAvatar(
          backgroundColor: Colors.transparent,
                          radius: isPortrait ? 30 : 20,
                          child: Text(
                            widget.fullName[0].toUpperCase(),
                            style: TextStyle(
              color: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[800],
                                fontSize: isPortrait ? 30 : 20,
              fontWeight: FontWeight.bold,
            ),
                          ),
                        ),
                      ),
    );
  }

  Widget _buildSubjectsList() {
    final filteredSubjects = _getFilteredSubjects();
    
    if (filteredSubjects.isEmpty) {
      return Center(
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
              'No subjects found',
              style: TextStyle(
                fontSize: 18,
                color: _isDarkMode 
                    ? Colors.white.withOpacity(0.5)
                    : Colors.blue.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredSubjects.length,
      itemBuilder: (context, index) {
        final subject = filteredSubjects[index];
        return _buildSubjectCard(subject);
      },
    );
  }

  Widget _buildSubjectCard(Map<String, dynamic> subject) {
    return Card(
      elevation: _isDarkMode ? 0 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: _isDarkMode 
              ? Color(0xFF4C4DDC).withOpacity(0.2)
              : Colors.blue.withOpacity(0.1),
          width: 1,
        ),
      ),
      color: _isDarkMode ? Color(0xFF1A1A2E) : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _navigateToSubject(subject),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildSubjectIcon(subject),
              SizedBox(width: 16),
              Expanded(
                child: _buildSubjectInfo(subject),
              ),
              _buildNavigationArrow(),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget _buildSubjectIcon(Map<String, dynamic> subject) {
    return Container(
      width: 60,
      height: 60,
                    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: _isDarkMode 
            ? Color(0xFF4C4DDC).withOpacity(0.1)
            : Colors.blue[50],
      ),
      child: Center(
        child: Image.asset(
          subject['image'],
          width: 40,
          height: 40,
        ),
      ),
    );
  }

  Widget _buildSubjectInfo(Map<String, dynamic> subject) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
        Text(
          subject['name'],
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.blue[800],
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: 4),
        Text(
          subject['description'],
          style: TextStyle(
            fontSize: 14,
            color: _isDarkMode ? Colors.white70 : Colors.blue[600],
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationArrow() {
    return Icon(
      Icons.arrow_forward_ios,
      color: _isDarkMode ? Colors.white70 : Colors.blue[400],
      size: 20,
    );
  }

  Widget _buildTabSelector() {
    return Row(
                              children: List.generate(
                                _tabs.length,
                                (index) => Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => _selectedIndex = index),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      decoration: BoxDecoration(
                                        color: _selectedIndex == index
                    ? (_isDarkMode ? Color(0xFF4C4DDC) : Colors.white)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                boxShadow: _selectedIndex == index
                                            ? [
                                                BoxShadow(
                          color: _isDarkMode 
                              ? Color(0xFF4C4DDC).withOpacity(0.3)
                              : Colors.blue.withOpacity(0.2),
                                                  blurRadius: 8,
                                                  spreadRadius: 2,
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Text(
                                        _tabs[index],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                  color: _selectedIndex == index
                      ? (_isDarkMode ? Colors.white : Colors.blue[800])
                      : (_isDarkMode ? Colors.white70 : Colors.blue[600]),
                  fontWeight: _selectedIndex == index 
                      ? FontWeight.bold 
                      : FontWeight.normal,
                  fontSize: 16,
                                  ),
                                ),
                              ),
                                    ),
                                  ),
                                ),
                              );
  }

  Widget _buildAIAssistantButton() {
    return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
                child: Container(
                  height: 170,  // Set your desired size
                  width: 170,   // Set your desired size
                  child: Lottie.network(
                    'https://lottie.host/696fc9e9-491f-42f8-8fd8-70aafe940939/iPo6o8AIgC.json',  // Path to your Lottie animation
                    width: 220,  // Set the width of the animation
                    height: 220, // Set the height of the animation
                    fit: BoxFit.cover,
                  ),
                ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: _isDarkMode ? Color(0xFF1A1A2E) : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: _isDarkMode 
                ? Colors.black.withOpacity(0.3)
                : Colors.blue.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 0,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
              unselectedItemColor: _isDarkMode ? Colors.white60 : Colors.grey[600],
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 12,
              ),
              items: [
                _buildNavBarItem(Icons.home_rounded, 'Home', 0),
                _buildNavBarItem(Icons.psychology_rounded, 'AI', 1),
                _buildNavBarItem(Icons.build_rounded, 'Tools', 2),
                _buildNavBarItem(Icons.person_rounded, 'Profile', 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavBarItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _currentIndex == index
              ? (_isDarkMode ? Color(0xFF4C4DDC).withOpacity(0.1) : Colors.blue.withOpacity(0.1))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 24,
        ),
      ),
      activeIcon: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _isDarkMode ? Color(0xFF4C4DDC).withOpacity(0.2) : Colors.blue.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: _isDarkMode 
                  ? Color(0xFF4C4DDC).withOpacity(0.3)
                  : Colors.blue.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 24,
          color: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
        ),
      ),
      label: label,
    );
  }

  void _navigateToSubject(Map<String, dynamic> subject) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => subject['page'](
          fullName: widget.fullName,
          branch: widget.branch,
          year: widget.year,
          semester: widget.semester,
          subjectName: subject['name'],
        ),
      ),
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          fullName: widget.fullName,
          branch: widget.branch,
          year: widget.year,
          semester: widget.semester,
          isDarkMode: _isDarkMode,
          onThemeChanged: (bool newTheme) {
            setState(() {
              _isDarkMode = newTheme;
            });
          },
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredSubjects() {
    if (_searchQuery.isEmpty) {
      return _subjects[_tabs[_selectedIndex]] ?? [];
    }
    final query = _searchQuery.toLowerCase();
    return (_subjects[_tabs[_selectedIndex]] ?? []).where((subject) {
      final name = subject['name'].toString().toLowerCase();
      final description = subject['description'].toString().toLowerCase();
      final searchString = '$name $description';
      return searchString.contains(query);
    }).toList();
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: _isDarkMode 
            ? Color(0xFF252542)
            : Colors.white,
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
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isDarkMode 
                    ? Color(0xFF4C4DDC).withOpacity(0.1)
                    : Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.search,
                color: _isDarkMode 
                    ? Color(0xFF4C4DDC)
                    : Colors.blue[700],
                size: 20,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.blue[900],
                fontSize: 16,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search subjects...',
                hintStyle: TextStyle(
                  color: _isDarkMode 
                      ? Colors.white.withOpacity(0.5)
                      : Colors.blue[900]?.withOpacity(0.5),
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 16,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isDarkMode 
                              ? Colors.red.withOpacity(0.1)
                              : Colors.red[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                            size: 18,
                          ),
                          color: _isDarkMode 
                              ? Colors.red[300]
                              : Colors.red[400],
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: const Duration(milliseconds: 600))
      .slideX(
        begin: 0.2,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class EEEHomeScreen extends StatefulWidget {
  @override
  _EEEHomeScreenState createState() => _EEEHomeScreenState();
}

class _EEEHomeScreenState extends State<EEEHomeScreen> {
  bool _isDarkMode = true;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('EEE Home')),
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.android),
            label: 'AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _getBody() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen();
      case 1:
        return AIScreen();
      case 2:
        return ToolsScreen();
      case 3:
        return ProfileScreen();
      default:
        return HomeScreen();
    }
  }
}

// Add a custom painter for the background pattern
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
