import 'package:flutter/material.dart';
import 'package:Nexia/CIVIL/sem4/CT/ct.dart';
import 'package:Nexia/CIVIL/sem4/DMRI/dmri.dart';
import 'package:Nexia/CIVIL/sem4/ES/es.dart';
import 'package:Nexia/CIVIL/sem4/FM/fm.dart';
import 'package:Nexia/CIVIL/sem4/SA/sa.dart';
import 'package:Nexia/CIVIL/sem4/SM/sm.dart';
import 'package:Nexia/CIVIL/sem4/TE/te.dart';
import 'package:Nexia/widgets/profiledark.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class CIVILSem4Screen extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const CIVILSem4Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _CIVILSem4ScreenState createState() => _CIVILSem4ScreenState();
}

class _CIVILSem4ScreenState extends State<CIVILSem4Screen> {
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
      'name': 'Structural Analysis',
      'description': 'Study of calculus and linear algebra including...',
      'image': 'assets/s2.png',
      'page': () => Sa(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Soil Mechanics',
      'description': 'Exploration of fundamental concepts in soil mechanics...',
      'image': 'assets/s2.png',
      'page': () => Sm(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Fluid Mechanics',
      'description': 'Introduction to fluid mechanics principles...',
      'image': 'assets/s2.png',
      'page': () => Fm(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Transportation Engineering',
      'description': 'Fundamentals of transportation engineering...',
      'image': 'assets/s2.png',
      'page': () => Te(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Disaster Management & Resilient Infra.',
      'description': 'Study of disaster management and resilient infrastructure...',
      'image': 'assets/s2.png',
      'page': () => Dmri(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Environmental Sciences',
      'description': 'Study of environmental sciences and issues...',
      'image': 'assets/s2.png',
      'page': () => Es(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Construction Technology',
      'description': 'Introduction to construction technology principles...',
      'image': 'assets/s2.png',
      'page': () => Ct(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
  ],
  'PYQs': [
    {
      'name': 'Structural Analysis PYQs',
      'description': 'Previous Year Questions for Structural Analysis...',
      'image': 'assets/s2.png',
      'page': () => Sa(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Soil Mechanics PYQs',
      'description': 'Previous Year Questions for Soil Mechanics...',
      'image': 'assets/s2.png',
      'page': () => Sm(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Fluid Mechanics PYQs',
      'description': 'Previous Year Questions for Fluid Mechanics...',
      'image': 'assets/s2.png',
      'page': () => Fm(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Transportation Engineering PYQs',
      'description': 'Previous Year Questions for Transportation Engineering...',
      'image': 'assets/s2.png',
      'page': () => Te(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Disaster Management & Resilient Infra. PYQs',
      'description': 'Previous Year Questions for Disaster Management and Resilient Infrastructure...',
      'image': 'assets/s2.png',
      'page': () => Dmri(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Environmental Sciences PYQs',
      'description': 'Previous Year Questions for Environmental Sciences...',
      'image': 'assets/s2.png',
      'page': () => Es(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Construction Technology PYQs',
      'description': 'Previous Year Questions for Construction Technology...',
      'image': 'assets/s2.png',
      'page': () => Ct(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
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