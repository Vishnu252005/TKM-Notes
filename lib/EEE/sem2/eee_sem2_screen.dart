import 'package:flutter/material.dart';
import 'package:flutter_application_2/EEE/sem2/CHEMISTRY/chemistry%20-%20Copy.dart';
import 'package:flutter_application_2/EEE/sem2/CHEMISTRY/chemistry.dart';
import 'package:flutter_application_2/EEE/sem2/GRAPHICS/graphics%20-%20Copy.dart';
import 'package:flutter_application_2/EEE/sem2/GRAPHICS/graphics.dart';
import 'package:flutter_application_2/EEE/sem2/MANUFACT/manufact%20-%20Copy.dart';
import 'package:flutter_application_2/EEE/sem2/MANUFACT/manufact.dart';
import 'package:flutter_application_2/EEE/sem2/MATHS/maths%20-%20Copy.dart';
import 'package:flutter_application_2/EEE/sem2/MATHS/maths.dart';
import 'package:flutter_application_2/EEE/sem2/PSP/psp%20-%20Copy.dart';
import 'package:flutter_application_2/EEE/sem2/PSP/psp.dart';
import 'package:flutter_application_2/EEE/sem2/SPORTS/sports%20-%20Copy.dart';
import 'package:flutter_application_2/EEE/sem2/SPORTS/sports.dart';
import 'package:flutter_application_2/EEE/sem2/UHV/uhv%20-%20Copy.dart';
import 'package:flutter_application_2/EEE/sem2/UHV/uhv.dart'; // Import the correct file for units
import 'package:flutter_application_2/widgets/profiledark.dart'; // Import the profile.dart file
import 'package:shared_preferences/shared_preferences.dart';

class EEESem2Screen extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const EEESem2Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _EEESem2ScreenState createState() => _EEESem2ScreenState();
}

class _EEESem2ScreenState extends State<EEESem2Screen> {
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
        'name': 'Ordinary Differential Equations and Transforms',
        'description': 'Study of differential equations and various transforms...',
        'image': 'assets/s1.png',
        'page': () => Maths(fullName: widget.fullName,branch: widget.branch, year: widget.year, semester: widget.semester),
      },
      {
        'name': 'Engineering Chemistry',
        'description': 'Exploration of fundamental concepts in chemistry...',
        'image': 'assets/s1.png',
        'page': () => Chemistry(fullName: widget.fullName,branch: widget.branch, year: widget.year, semester: widget.semester),
      },
      {
        'name': 'Problem Solving and Programming',
        'description': 'Basics of programming and problem-solving techniques...',
        'image': 'assets/s1.png',
        'page': () => Psp(fullName: widget.fullName,branch: widget.branch, year: widget.year, semester: widget.semester),
      },
      {
        'name': 'Engineering Graphics',
        'description': 'Fundamentals of engineering drawing and graphics...',
        'image': 'assets/s1.png',
        'page': () => Graphics(fullName: widget.fullName,branch: widget.branch, year: widget.year, semester: widget.semester),
      },
      {
        'name': 'Manufacturing Practices',
        'description': 'Introduction to various manufacturing processes...',
        'image': 'assets/s1.png',
        'page': () => Manufact(fullName: widget.fullName,branch: widget.branch, year: widget.year, semester: widget.semester),
      },
      {
        'name': 'Sports and Yoga',
        'description': 'Physical education and well-being through sports and yoga...',
        'image': 'assets/s1.png',
        'page': () => Sports(fullName: widget.fullName,branch: widget.branch, year: widget.year, semester: widget.semester),
      },
      {
        'name': 'Universal Human Values-II',
        'description': 'Exploration of universal human values...',
        'image': 'assets/s1.png',
        'page': () => Uhv(fullName: widget.fullName,branch: widget.branch, year: widget.year, semester: widget.semester),
      },
    ],
    'PYQs': [
      {
        'name': 'Ordinary Differential Equations and Transforms PYQs',
        'description': 'Previous Year Questions for Ordinary Differential Equations and Transforms...',
        'image': 'assets/s2.png',
        'page': () => Maths1(fullName: widget.fullName,branch: widget.branch, year: widget.year, semester: widget.semester),
      },
      {
        'name': 'Engineering Chemistry PYQs',
        'description': 'Previous Year Questions for Engineering Chemistry...',
        'image': 'assets/s2.png',
        'page': () => Chemistry1(fullName: widget.fullName,branch: widget.branch, year: widget.year, semester: widget.semester),
      },
      {
        'name': 'Problem Solving and Programming PYQs',
        'description': 'Previous Year Questions for Problem Solving and Programming...',
        'image': 'assets/s2.png',
        'page': () => Psp1(fullName: widget.fullName,branch: widget.branch, year: widget.year, semester: widget.semester),
      },
      {
        'name': 'Engineering Graphics PYQs',
        'description': 'Previous Year Questions for Engineering Graphics...',
        'image': 'assets/s2.png',
        'page': () => Graphics1(fullName: widget.fullName,branch: widget.branch, year: widget.year, semester: widget.semester),
      },
      {
        'name': 'Manufacturing Practices PYQs',
        'description': 'Previous Year Questions for Manufacturing Practices...',
        'image': 'assets/s2.png',
        'page': () => Manufact1(fullName: widget.fullName,branch: widget.branch, year: widget.year, semester: widget.semester),
      },
      {
        'name': 'Sports and Yoga PYQs',
        'description': 'Previous Year Questions for Sports and Yoga...',
        'image': 'assets/s2.png',
        'page': () => Sports1(fullName: widget.fullName,branch: widget.branch, year: widget.year, semester: widget.semester),
      },
      {
        'name': 'Universal Human Values-II PYQs',
        'description': 'Previous Year Questions for Universal Human Values-II...',
        'image': 'assets/s2.png',
        'page': () => Uhv1(fullName: widget.fullName,branch: widget.branch, year: widget.year, semester: widget.semester),
      },
    ],
  };
}
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