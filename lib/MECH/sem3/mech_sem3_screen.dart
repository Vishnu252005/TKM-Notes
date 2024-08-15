import 'package:flutter/material.dart';
import 'package:flutter_application_2/MECH/sem3/BEE/bee.dart';
import 'package:flutter_application_2/MECH/sem3/PBCA/pbca.dart';
import 'package:flutter_application_2/MECH/sem3/EE/ee.dart';
import 'package:flutter_application_2/MECH/sem3/BEM/bem.dart';
import 'package:flutter_application_2/MECH/sem3/IEM/iem.dart';
import 'package:flutter_application_2/MECH/sem3/AT/at.dart';
import 'package:flutter_application_2/MECH/sem3/BEM/bem-copy.dart';
import 'package:flutter_application_2/MECH/sem3/EMA/ema.dart';
import 'package:flutter_application_2/MECH/sem3/FMHM/fmhm.dart';
import 'package:flutter_application_2/MECH/sem3/FMM/fmm.dart';
import 'package:flutter_application_2/MECH/sem3/MM/mm.dart';
import 'package:flutter_application_2/MECH/sem3/MMT/mmt.dart';
import 'package:flutter_application_2/MECH/sem3/SE/se.dart';
import 'package:flutter_application_2/widgets/profiledark.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MECHSem3Screen extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const MECHSem3Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _MECHSem3ScreenState createState() => _MECHSem3ScreenState();
}

class _MECHSem3ScreenState extends State<MECHSem3Screen> {
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
      'name': 'Probability Distributions and Complex Analysis',
      'description':
          'Study of probability distributions and complex analysis including...',
      'image': 'assets/s1.png',
      'page': () => Pbca(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Sustainable Engineering',
      'description':
          'Introduction to sustainable engineering practices and principles...',
      'image': 'assets/s1.png',
      'page': () => Se(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Engineering Materials & Applications',
      'description':
          'Exploration of engineering materials and their applications...',
      'image': 'assets/s1.png',
      'page': () => Ema(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Fluid Mechanics & Hydraulic Machines',
      'description':
          'Fundamentals of fluid mechanics and hydraulic machines...',
      'image': 'assets/s1.png',
      'page': () => Fmhm(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Applied Thermodynamics',
      'description':
          'Study of applied thermodynamics and its applications...',
      'image': 'assets/s1.png',
      'page': () => At(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Engineering Economics',
      'description':
          'Introduction to engineering economics and financial principles...',
      'image': 'assets/s1.png',
      'page': () => Ee(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Basic Engineering Mechanics',
      'description': 'Fundamentals of engineering mechanics...',
      'image': 'assets/s1.png',
      'page': () => Bem(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Fluid Mechanics & Machinery',
      'description': 'Basics of fluid mechanics and machinery...',
      'image': 'assets/s1.png',
      'page': () => Fmm(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Mechanics of Materials',
      'description': 'Principles of Mechanics of Materials...',
      'image': 'assets/s1.png',
      'page': () => Mm(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Material Science and Technology',
      'description': 'Study of material science and technology...',
      'image': 'assets/s1.png',
      'page': () => Mmt(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Industrial Engineering and Management',
      'description':
          'Principles of industrial engineering and management...',
      'image': 'assets/s1.png',
      'page': () => Iem(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
  ],
  'PYQs': [
    {
      'name': 'Probability Distributions and Complex Analysis PYQs',
      'description':
          'Previous Year Questions for Probability Distributions and Complex Analysis...',
      'image': 'assets/s2.png',
      'page': () => Pbca(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Sustainable Engineering PYQs',
      'description':
          'Previous Year Questions for Sustainable Engineering...',
      'image': 'assets/s2.png',
      'page': () => Se(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Engineering Materials & Applications PYQs',
      'description':
          'Previous Year Questions for Engineering Materials & Applications...',
      'image': 'assets/s2.png',
      'page': () => Ema(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Fluid Mechanics & Hydraulic Machines PYQs',
      'description':
          'Previous Year Questions for Fluid Mechanics & Hydraulic Machines...',
      'image': 'assets/s2.png',
      'page': () => Fmhm(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Applied Thermodynamics PYQs',
      'description': 'Previous Year Questions for Applied Thermodynamics...',
      'image': 'assets/s2.png',
      'page': () => At(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Engineering Economics PYQs',
      'description': 'Previous Year Questions for Engineering Economics...',
      'image': 'assets/s2.png',
      'page': () => Ee(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Basic Engineering Mechanics PYQs',
      'description': 'Previous Year Questions for Basic Engineering Mechanics...',
      'image': 'assets/s2.png',
      'page': () => Bem1(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Fluid Mechanics & Machinery PYQs',
      'description':
          'Previous Year Questions for Fluid Mechanics & Machinery...',
      'image': 'assets/s2.png',
      'page': () => Fmm(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Mechanics of Materials PYQs',
      'description': 'Previous Year Questions for Mechanics of Materials...',
      'image': 'assets/s2.png',
      'page': () => Mm(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Material Science and Technology PYQs',
      'description':
          'Previous Year Questions for Material Science and Technology...',
      'image': 'assets/s2.png',
      'page': () => Mmt(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Industrial Engineering and Management PYQs',
      'description':
          'Previous Year Questions for Industrial Engineering and Management...',
      'image': 'assets/s2.png',
      'page': () => Iem(
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