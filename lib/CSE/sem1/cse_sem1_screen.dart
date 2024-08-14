import 'package:flutter/material.dart';
import 'package:flutter_application_2/CSE/sem1/LSD/lsd%20-%20Copy.dart';
import 'package:flutter_application_2/CSE/sem1/ENGLISH/english%20-%20Copy.dart';
import 'package:flutter_application_2/CSE/sem1/FEE/fee%20-%20Copy.dart';
import 'package:flutter_application_2/CSE/sem1/FEE/fee.dart';
import 'package:flutter_application_2/CSE/sem1/IDEALAB/idealab%20-%20Copy.dart';
import 'package:flutter_application_2/CSE/sem1/MATHS/maths%20-%20Copy.dart';
import 'package:flutter_application_2/CSE/sem1/MATHS/maths.dart';  // Import the correct file for 
import 'package:flutter_application_2/CSE/sem1/LSD/lsd.dart';
import 'package:flutter_application_2/CSE/sem1/PHYSICS/physics%20-%20Copy.dart';
import 'package:flutter_application_2/CSE/sem1/PHYSICS/physics.dart';
import 'package:flutter_application_2/CSE/sem1/ENGLISH/english.dart';
import 'package:flutter_application_2/CSE/sem1/IDEALAB/idealab.dart';
import 'package:flutter_application_2/widgets/profile.dart'; // Import the profile.dart file

class CSESem1Screen extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const CSESem1Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _CSESem1ScreenState createState() => _CSESem1ScreenState();
}

class _CSESem1ScreenState extends State<CSESem1Screen> {
  int _selectedIndex = 0;
  bool isDarkMode = true;
  final List<String> _tabs = ['Notes & Books', 'PYQs'];

  late Map<String, List<Map<String, dynamic>>> _subjects;

  @override
  void initState() {
    super.initState();

    _subjects = {
    'Notes & Books': [
      {
        'name': 'Calculus and Linear Algebra',
        'description': 'Study of calculus and linear algebra including...',
        'image': 'assets/s1.png',
        'page': () =>  maths(fullName: widget.fullName,branch: widget.branch,
            year: widget.year,
            semester: widget.semester),
      },
      {
        'name': 'Engineering Physics',
        'description': 'Exploration of fundamental concepts in physics...',
        'image': 'assets/s1.png',
        'page': () =>  physics(fullName: widget.fullName,branch: widget.branch,
            year: widget.year,
            semester: widget.semester),
      },
      {
        'name': 'Fundamentals of Electronics Engineering',
        'description': 'Basics of electronics and electrical engineering...',
        'image': 'assets/s1.png',
        'page': () =>  fee(fullName: widget.fullName,branch: widget.branch,
            year: widget.year,
            semester: widget.semester),
      },
      {
        'name': 'Technical English for Engineers',
        'description': 'Improving technical communication skills...',
        'image': 'assets/s1.png',
        'page': () =>  english(fullName: widget.fullName,branch: widget.branch,
            year: widget.year,
            semester: widget.semester),
      },
      {
        'name': 'IDEA Lab Workshop',
        'description': 'Hands-on workshop focusing on innovative design...',
        'image': 'assets/s1.png',
        'page': () =>  idea(fullName: widget.fullName,branch: widget.branch,
            year: widget.year,
            semester: widget.semester),
      },
      // {
      //   'name': 'Design Thinking',
      //   'description': 'Process for creative problem-solving and innovation...',
      //   'image': 'assets/s1.png',
      //   'page': () =>  dt(fullName: widget.fullName),
      // },
      {
        'name': 'Basics of Electrical Engineering',
        'description': 'Introduction to electrical engineering principles...',
        'image': 'assets/s1.png',
        'page': () =>  LSD(fullName: widget.fullName,branch: widget.branch,
            year: widget.year,
            semester: widget.semester),
      },
      
    ],
    'PYQs': [
      {
        'name': 'Calculus and Linear Algebra PYQs',
        'description': 'Previous Year Questions for Calculus and Linear Algebra...',
        'image': 'assets/s2.png',
        'page': () =>  maths1(fullName: widget.fullName,branch: widget.branch,
            year: widget.year,
            semester: widget.semester),
      },
      {
        'name': 'Engineering Physics PYQs',
        'description': 'Previous Year Questions for Engineering Physics...',
        'image': 'assets/s2.png',
        'page': () =>  physics1(fullName: widget.fullName,branch: widget.branch,
            year: widget.year,
            semester: widget.semester),
      },
      {
        'name': 'Fundamentals of Electronics Engineering PYQs',
        'description': 'Previous Year Questions for Electronics Engineering...',
        'image': 'assets/s2.png',
        'page': () =>  fee1(fullName: widget.fullName,branch: widget.branch,
            year: widget.year,
            semester: widget.semester),
      },
      {
        'name': 'Technical English for Engineers PYQs',
        'description': 'Previous Year Questions for Technical English...',
        'image': 'assets/s2.png',
        'page': () =>  english1(fullName: widget.fullName,branch: widget.branch,
            year: widget.year,
            semester: widget.semester),
      },
      {
        'name': 'IDEA Lab Workshop PYQs',
        'description': 'Previous Year Questions for IDEA Lab Workshop...',
        'image': 'assets/s2.png',
        'page': () =>  idea1(fullName: widget.fullName,branch: widget.branch,
            year: widget.year,
            semester: widget.semester),
      },
      // {
      //   'name': 'Design Thinking PYQs',
      //   'description': 'Previous Year Questions for Design Thinking...',
      //   'image': 'assets/s2.png',
      //   'page': () =>  dt(fullName: widget.fullName),
      // },
      {
        'name': 'Basics of Electrical Engineering PYQs',
        'description': 'Previous Year Questions for Electrical Engineering...',
        'image': 'assets/s2.png',
        'page': () =>  LSD1(fullName: widget.fullName,branch: widget.branch,
            year: widget.year,
            semester: widget.semester),
      },
      
    ],
  };
}


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isPortrait = screenSize.height > screenSize.width;
    final themeData = Theme.of(context);

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color.fromARGB(255, 7, 17, 148) : Colors.white,
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
                              color: isDarkMode ? Colors.white : Colors.black),
                        ),
                        const Text(
                          'Select Subject',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
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
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor:
                          isDarkMode ? Colors.red[600] : Colors.blue[600],
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
                  IconButton(
                    icon: Icon(
                      isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        isDarkMode = !isDarkMode;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black : Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 24),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color.fromARGB(255, 58, 58, 58)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: List.generate(
                            _tabs.length,
                            (index) => Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedIndex = index),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: _selectedIndex == index
                                        ? (isDarkMode
                                            ? Colors.black
                                            : Colors.white)
                                        : (isDarkMode
                                            ? const Color.fromARGB(
                                                255, 58, 58, 58)
                                            : Colors.grey[300]),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Text(
                                    _tabs[index],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black),
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
                          var subject =
                              _subjects[_tabs[_selectedIndex]]![index];
                          return Card(
                            color: isDarkMode
                                ? const Color.fromARGB(255, 58, 58, 58)
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8),
                              leading: subject['image'] != null
                                  ? Image.asset(subject['image'],
                                      width: 50, height: 50)
                                  : null,
                              title: Text(subject['name'],
                                  style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(subject['description'],
                                  style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white70
                                          : Colors.black54)),
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
