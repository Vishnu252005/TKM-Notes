import 'package:flutter/material.dart';
import 'package:Nexia/CSE/sem5/COI/coi.dart';
import 'package:Nexia/CSE/sem5/AIML/aiml.dart';
import 'package:Nexia/CSE/sem5/AWT/awt.dart';
import 'package:Nexia/CSE/sem5/DAA/daa.dart';
import 'package:Nexia/CSE/sem5/TW/tw.dart';
import 'package:Nexia/CSE/sem5/units.dart';  // Import the correct file for units
import 'package:Nexia/CSE/sem5/FA/fa.dart';
import 'package:Nexia/CSE/sem5/SE/se.dart';
import 'package:Nexia/widgets/profile.dart'; // Import the profile.dart file

class CSESem5Screen extends StatefulWidget {//M
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const CSESem5Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _CSESem5ScreenState createState() => _CSESem5ScreenState();
}

class _CSESem5ScreenState extends State<CSESem5Screen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Notes & Books', 'PYQs'];

  late Map<String, List<Map<String, dynamic>>> _subjects;

  @override
  void initState() {
    super.initState();

    _subjects = {
      'Notes & Books': [
  {
    'name': 'Design & Analysis of Algorithms',
    'description': 'Study of design and analysis of algorithms...',
    'image': 'assets/s1.png',
    'page': () => Daa(fullName: widget.fullName),
  },
  {
    'name': 'Software Engineering',
    'description': 'Exploration of software engineering principles and practices...',
    'image': 'assets/s1.png',
    'page': () => Se(fullName: widget.fullName),
  },
  {
    'name': 'Artificial Intelligence & Machine Learning',
    'description': 'Introduction to artificial intelligence and machine learning concepts...',
    'image': 'assets/s1.png',
    'page': () => Aiml(fullName: widget.fullName),
  },
  {
    'name': 'Advanced Web Technologies',
    'description': 'Study of advanced web technologies and their applications...',
    'image': 'assets/s1.png',
    'page': () => Awt(fullName: widget.fullName),
  },
  {
    'name': 'Finance and Accounting',
    'description': 'Introduction to finance and accounting principles...',
    'image': 'assets/s1.png',
    'page': () => Fa(fullName: widget.fullName),
  },
  {
    'name': 'Constitution of India',
    'description': 'Study of the Constitution of India and its significance...',
    'image': 'assets/s1.png',
    'page': () => Coi(fullName: widget.fullName),
  },
  {
    'name': 'Technical Writing',
    'description': 'Basics of technical writing for effective communication...',
    'image': 'assets/s1.png',
    'page': () => Tw(fullName: widget.fullName),
  },
],
'PYQs': [
  {
    'name': 'Design & Analysis of Algorithms PYQs',
    'description': 'Previous Year Questions for Design & Analysis of Algorithms...',
    'image': 'assets/s1.png',
    'page': () => Daa(fullName: widget.fullName),
  },
  {
    'name': 'Software Engineering PYQs',
    'description': 'Previous Year Questions for Software Engineering...',
    'image': 'assets/s1.png',
    'page': () => Se(fullName: widget.fullName),
  },
  {
    'name': 'Artificial Intelligence & Machine Learning PYQs',
    'description': 'Previous Year Questions for Artificial Intelligence & Machine Learning...',
    'image': 'assets/s1.png',
    'page': () => Aiml(fullName: widget.fullName),
  },
  {
    'name': 'Advanced Web Technologies PYQs',
    'description': 'Previous Year Questions for Advanced Web Technologies...',
    'image': 'assets/s1.png',
    'page': () => Awt(fullName: widget.fullName),
  },
  {
    'name': 'Finance and Accounting PYQs',
    'description': 'Previous Year Questions for Finance and Accounting...',
    'image': 'assets/s1.png',
    'page': () => Fa(fullName: widget.fullName),
  },
  {
    'name': 'Constitution of India PYQs',
    'description': 'Previous Year Questions for Constitution of India...',
    'image': 'assets/s1.png',
    'page': () => Coi(fullName: widget.fullName),
  },
  {
    'name': 'Technical Writing PYQs',
    'description': 'Previous Year Questions for Technical Writing...',
    'image': 'assets/s1.png',
    'page': () => Tw(fullName: widget.fullName),
  },
],

    };
  }

 @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isPortrait = screenSize.height > screenSize.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(755, 7, 17, 148),
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
                              color: Colors.white),
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
                      backgroundColor: Colors.red[600],
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
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
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
                          color: const Color.fromARGB(755, 58, 58, 58),
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
                                        ? Colors.black
                                        : const Color.fromARGB(755, 58, 58, 58),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Text(
                                    _tabs[index],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white),
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
                            color: const Color.fromARGB(755, 58, 58, 58),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8),
                              leading: subject['image'] != null
                                  ? Image.asset(subject['image'],
                                      width: 50, height: 50)
                                  : null,
                              title: Text(subject['name'],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(subject['description'],
                                  style:
                                      const TextStyle(color: Colors.white70)),
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