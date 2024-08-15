import 'package:flutter/material.dart';
import 'package:flutter_application_2/CIVIL/sem3/CED/ced.dart';
import 'package:flutter_application_2/CIVIL/sem3/EG/eg.dart';
import 'package:flutter_application_2/CIVIL/sem3/LSPE/lspe.dart';
import 'package:flutter_application_2/CIVIL/sem3/MS/ms.dart';
import 'package:flutter_application_2/CIVIL/sem3/MSE/mse.dart';
import 'package:flutter_application_2/CIVIL/sem3/PDCA/pdca.dart';
import 'package:flutter_application_2/CIVIL/sem3/SAG/sag.dart';
import 'package:flutter_application_2/widgets/profiledark.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CIVILSem3Screen extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const CIVILSem3Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _CIVILSem3ScreenState createState() => _CIVILSem3ScreenState();
}

class _CIVILSem3ScreenState extends State<CIVILSem3Screen> {
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
      'name': 'Prob. Distributions & Complex Analysis',
      'description': 'Study of probability distributions and complex analysis...',
      'image': 'assets/s1.png',
      'page': () => pdca(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Material Science & Engineering',
      'description': 'Exploration of material science and engineering concepts...',
      'image': 'assets/s1.png',
      'page': () => mse(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Mechanics of Solids',
      'description': 'Introduction to mechanics of solids...',
      'image': 'assets/s1.png',
      'page': () => ms(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Surveying & Geomatics',
      'description': 'Fundamentals of surveying and geomatics...',
      'image': 'assets/s1.png',
      'page': () => sag(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Engineering Geology',
      'description': 'Introduction to engineering geology principles...',
      'image': 'assets/s1.png',
      'page': () => eg(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Life Skills & Prof. Ethics',
      'description': 'Study of life skills and professional ethics...',
      'image': 'assets/s1.png',
      'page': () => lspe(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Civil Engineering Drawing',
      'description': 'Introduction to civil engineering drawing...',
      'image': 'assets/s1.png',
      'page': () => ced(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
  ],
  'PYQs': [
    {
      'name': 'Prob. Distributions & Complex Analysis PYQs',
      'description': 'Previous Year Questions for Probability Distributions and Complex Analysis...',
      'image': 'assets/s2.png',
      'page': () => pdca(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Material Science & Engineering PYQs',
      'description': 'Previous Year Questions for Material Science and Engineering...',
      'image': 'assets/s2.png',
      'page': () => mse(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Mechanics of Solids PYQs',
      'description': 'Previous Year Questions for Mechanics of Solids...',
      'image': 'assets/s2.png',
      'page': () => ms(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Surveying & Geomatics PYQs',
      'description': 'Previous Year Questions for Surveying and Geomatics...',
      'image': 'assets/s2.png',
      'page': () => sag(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Engineering Geology PYQs',
      'description': 'Previous Year Questions for Engineering Geology...',
      'image': 'assets/s2.png',
      'page': () => eg(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Life Skills & Prof. Ethics PYQs',
      'description': 'Previous Year Questions for Life Skills and Professional Ethics...',
      'image': 'assets/s2.png',
      'page': () => lspe(
        fullName: widget.fullName,
        branch: widget.branch,
        year: widget.year,
        semester: widget.semester,
      ),
    },
    {
      'name': 'Civil Engineering Drawing PYQs',
      'description': 'Previous Year Questions for Civil Engineering Drawing...',
      'image': 'assets/s2.png',
      'page': () => ced(
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