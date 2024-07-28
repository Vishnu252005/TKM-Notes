import 'package:flutter/material.dart';
import 'package:flutter_application_2/EEE/sem5/AM/am.dart';
import 'package:flutter_application_2/EEE/sem5/CI/ci.dart';
import 'package:flutter_application_2/EEE/sem5/CSE/cse.dart';
import 'package:flutter_application_2/EEE/sem5/IEM/iem.dart';
import 'package:flutter_application_2/EEE/sem5/IML/iml.dart';
import 'package:flutter_application_2/EEE/sem5/IOT/iot.dart';
import 'package:flutter_application_2/EEE/sem5/PE/pe.dart';
import 'package:flutter_application_2/EEE/sem5/units.dart'; // Import the correct file for units
import 'package:flutter_application_2/widgets/profile.dart'; // Import the profile.dart file

class EEESem5Screen extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const EEESem5Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _EEESem5ScreenState createState() => _EEESem5ScreenState();
}

class _EEESem5ScreenState extends State<EEESem5Screen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Notes & Books', 'PYQs'];

  late Map<String, List<Map<String, dynamic>>> _subjects;

  @override
  void initState() {
    super.initState();

    _subjects = {
      'Notes & Books': [
        {
          'name': 'Control System Engineering',
          'description':
              'Study of control system principles and applications...',
          'image': 'assets/s1.png',
          'page': () => Cse(fullName: widget.fullName),
        },
        {
          'name': 'Embedded System Design and IoT',
          'description': 'Introduction to embedded systems and IoT...',
          'image': 'assets/s1.png',
          'page': () => Iot(fullName: widget.fullName),
        },
        {
          'name': 'Power Electronics',
          'description':
              'Study of electronic devices and circuits used in power electronics...',
          'image': 'assets/s1.png',
          'page': () => Pe(fullName: widget.fullName),
        },
        {
          'name': 'AC Machines',
          'description':
              'Comprehensive study of alternating current machines...',
          'image': 'assets/s1.png',
          'page': () => Am(fullName: widget.fullName),
        },
        {
          'name': 'Industrial Engineering and Management',
          'description':
              'Principles of industrial engineering and management...',
          'image': 'assets/s1.png',
          'page': () => Iem(fullName: widget.fullName),
        },
        {
          'name': 'Constitution of India',
          'description': 'Study of the Constitution of India...',
          'image': 'assets/s1.png',
          'page': () => Ci(fullName: widget.fullName),
        },
        {
          'name': 'Introduction to Machine Learning',
          'description':
              'Basics of machine learning concepts and applications...',
          'image': 'assets/s1.png',
          'page': () => Iml(fullName: widget.fullName),
        },
        // Add more subjects as needed
      ],
      'PYQs': [
        {
          'name': 'Control System Engineering PYQs',
          'description':
              'Previous Year Questions for Control System Engineering...',
          'image': 'assets/s2.png',
          'page': () => Cse(fullName: widget.fullName),
        },
        {
          'name': 'Embedded System Design and IoT PYQs',
          'description':
              'Previous Year Questions for Embedded System Design and IoT...',
          'image': 'assets/s2.png',
          'page': () => Iot(fullName: widget.fullName),
        },
        {
          'name': 'Power Electronics PYQs',
          'description': 'Previous Year Questions for Power Electronics...',
          'image': 'assets/s2.png',
          'page': () => Pe(fullName: widget.fullName),
        },
        {
          'name': 'AC Machines PYQs',
          'description': 'Previous Year Questions for AC Machines...',
          'image': 'assets/s2.png',
          'page': () => Am(fullName: widget.fullName),
        },
        {
          'name': 'Industrial Engineering and Management PYQs',
          'description':
              'Previous Year Questions for Industrial Engineering and Management...',
          'image': 'assets/s2.png',
          'page': () => Iem(fullName: widget.fullName),
        },
        {
          'name': 'Constitution of India PYQs',
          'description': 'Previous Year Questions for Constitution of India...',
          'image': 'assets/s2.png',
          'page': () => Ci(fullName: widget.fullName),
        },
        {
          'name': 'Introduction to Machine Learning PYQs',
          'description':
              'Previous Year Questions for Introduction to Machine Learning...',
          'image': 'assets/s2.png',
          'page': () => Iml(fullName: widget.fullName),
        },
        // Add more subjects as needed
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
