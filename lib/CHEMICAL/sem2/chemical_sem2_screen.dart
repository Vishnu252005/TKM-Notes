import 'package:flutter/material.dart';
import 'package:Nexia/CHEMICAL/sem2/ENGLISH/english%20-%20Copy.dart';
import 'package:Nexia/CHEMICAL/sem2/ENGLISH/english.dart';
import 'package:Nexia/CHEMICAL/sem2/IDEALAB/idealab%20-%20Copy.dart';
import 'package:Nexia/CHEMICAL/sem2/IDEALAB/idealab.dart';
import 'package:Nexia/CHEMICAL/sem2/MATHS/maths%20-%20Copy.dart';
import 'package:Nexia/CHEMICAL/sem2/MATHS/maths.dart';
import 'package:Nexia/CHEMICAL/sem2/PHYSICS/physics%20-%20Copy.dart';
import 'package:Nexia/CHEMICAL/sem2/PHYSICS/physics.dart';
import 'package:Nexia/CHEMICAL/sem2/PSP/psp%20-%20Copy.dart';
import 'package:Nexia/CHEMICAL/sem2/PSP/psp.dart';
import 'package:Nexia/CHEMICAL/sem2/UHV/uhv%20-%20Copy.dart';
import 'package:Nexia/CHEMICAL/sem2/UHV/uhv.dart';
import 'package:Nexia/widgets/profiledark.dart'; // Import the profile.dart file
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
class CHEMICALSem2Screen extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const CHEMICALSem2Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _CHEMICALSem2ScreenState createState() => _CHEMICALSem2ScreenState();
}

class _CHEMICALSem2ScreenState extends State<CHEMICALSem2Screen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Notes & Books', 'PYQs'];
  bool _isDarkMode = true;
  late Map<String, List<Map<String, dynamic>>> _subjects;

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
      'name': 'Differential Equations and Transforms',
      'description': 'Study of differential equations and various transforms...',
      'image': 'assets/s1.png',
      'page': () => maths(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester
      ),
    },
    {
      'name': 'Engineering Physics',
      'description': 'Exploration of fundamental concepts in physics...',
      'image': 'assets/s1.png',
      'page': () => physics(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester
      ),
    },
    {
      'name': 'Problem Solving and Programming',
      'description': 'Basics of programming and problem-solving techniques...',
      'image': 'assets/s1.png',
      'page': () => Psp(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester
      ),
    },
    {
      'name': 'Technical English for Engineers',
      'description': 'Improving technical English communication skills...',
      'image': 'assets/s1.png',
      'page': () => english(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester
      ),
    },
    {
      'name': 'IDEA Lab Workshop',
      'description': 'Hands-on workshop for innovation and design...',
      'image': 'assets/s1.png',
      'page': () => idea(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester
      ),
    },
    // {
    //   'name': 'Design Thinking',
    //   'description': 'Problem-solving approach using design thinking principles...',
    //   'image': 'assets/s1.png',
    //   'page': () => ComputerNetworksPage(
    //     fullName: widget.fullName,
    //     branch: widget.branch,
    //     year: widget.year,
    //     semester: widget.semester
    //   ),
    // },
    {
      'name': 'Universal Human Values-II',
      'description': 'Exploration of universal human values...',
      'image': 'assets/s1.png',
      'page': () => Uhv(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester
      ),
    },
  ],
  'PYQs': [
    {
      'name': 'Differential Equations and Transforms PYQs',
      'description': 'Previous Year Questions for Differential Equations and Transforms...',
      'image': 'assets/s2.png',
      'page': () => maths1(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester
      ),
    },
    {
      'name': 'Engineering Physics PYQs',
      'description': 'Previous Year Questions for Engineering Physics...',
      'image': 'assets/s2.png',
      'page': () => physics1(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester
      ),
    },
    {
      'name': 'Problem Solving and Programming PYQs',
      'description': 'Previous Year Questions for Problem Solving and Programming...',
      'image': 'assets/s2.png',
      'page': () => Psp1(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester
      ),
    },
    {
      'name': 'Technical English for Engineers PYQs',
      'description': 'Previous Year Questions for Technical English for Engineers...',
      'image': 'assets/s2.png',
      'page': () => english1(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester
      ),
    },
    {
      'name': 'IDEA Lab Workshop PYQs',
      'description': 'Previous Year Questions for IDEA Lab Workshop...',
      'image': 'assets/s2.png',
      'page': () => idea1(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester
      ),
    },
    // {
    //   'name': 'Design Thinking PYQs',
    //   'description': 'Previous Year Questions for Design Thinking...',
    //   'image': 'assets/s2.png',
    //   'page': () => ComputerNetworksPage(
    //     fullName: widget.fullName,
    //     branch: widget.branch,
    //     year: widget.year,
    //     semester: widget.semester
    //   ),
    // },
    {
      'name': 'Universal Human Values-II PYQs',
      'description': 'Previous Year Questions for Universal Human Values-II...',
      'image': 'assets/s2.png',
      'page': () => Uhv1(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester
      ),
    },
  ],
};}






  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isPortrait = screenSize.height > screenSize.width;

    return Scaffold(
      backgroundColor: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[50],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(isPortrait ? 24.0 : 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hey ${widget.fullName}',
                          style: TextStyle(
                              fontSize: isPortrait ? 24 : 20,
                              fontWeight: FontWeight.bold,
                              color: _isDarkMode ? Colors.white : Colors.blue[800]),
                        ),
                        Text(
                          'Select Subject',
                          style: TextStyle(fontSize: 16, color: _isDarkMode ? Colors.white70 : Colors.blue[600]),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
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
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: isPortrait ? 30 : 20,
                      child: Text(
                        widget.fullName[0].toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: isPortrait ? 30 : 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _isDarkMode ? Colors.black : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isDarkMode ? Colors.black12 : Colors.blue.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _isDarkMode ? const Color.fromARGB(755, 58, 58, 58) : Colors.blue[50],
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: List.generate(
                            _tabs.length,
                            (index) => Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedIndex = index),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: _selectedIndex == index
                                        ? (_isDarkMode ? Colors.black : Colors.white)
                                        : (_isDarkMode ? const Color.fromARGB(755, 58, 58, 58) : Colors.blue[50]),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: _selectedIndex == index && !_isDarkMode
                                        ? [
                                            BoxShadow(
                                              color: Colors.blue.withOpacity(0.3),
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
                                      color: _isDarkMode
                                          ? Colors.white
                                          : (_selectedIndex == index ? Colors.blue[800] : Colors.blue[600]),
                                      fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _subjects[_tabs[_selectedIndex]]!.length,
                        itemBuilder: (context, index) {
                          var subject = _subjects[_tabs[_selectedIndex]]![index];
                          return Card(
                            color: _isDarkMode ? const Color.fromARGB(755, 58, 58, 58) : Colors.white,
                            elevation: _isDarkMode ? 0 : 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: subject['image'] != null
                                  ? Image.asset(subject['image'], width: 50, height: 50)
                                  : null,
                              title: Text(
                                subject['name'],
                                style: TextStyle(
                                  color: _isDarkMode ? Colors.white : Colors.blue[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                subject['description'],
                                style: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.blue[600]),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => subject['page'](),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}