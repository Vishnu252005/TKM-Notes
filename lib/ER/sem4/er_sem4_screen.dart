import 'package:flutter/material.dart';
import 'package:flutter_application_2/CIVIL/sem4/ES/es.dart';
import 'package:flutter_application_2/EEE/sem4/SS/ss.dart';
import 'package:flutter_application_2/EEE/sem5/IEM/iem.dart';
import 'package:flutter_application_2/ER/sem4/AC/ac.dart';
import 'package:flutter_application_2/ER/sem4/MI/mi.dart';
import 'package:flutter_application_2/ER/sem4/PRD/prd.dart';
import 'package:flutter_application_2/ER/sem4/units.dart';  // Import the correct file for units
import 'package:flutter_application_2/MECH/sem3/MM/mm.dart';
import 'package:flutter_application_2/widgets/profile.dart'; // Import the profile.dart file

class ERSem4Screen extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const ERSem4Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _ERSem4ScreenState createState() => _ERSem4ScreenState();
}

class _ERSem4ScreenState extends State<ERSem4Screen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Notes & Books', 'PYQs'];

  late Map<String, List<Map<String, dynamic>>> _subjects;

  @override
  void initState() {
  super.initState();

  _subjects = {
    'Notes & Books': [
       {
        'name': 'Probability and Random Processes',
        'description': 'Study of probability theory and random processes...',
        'image': 'assets/s3.png',
        'page': () => Prd(fullName: widget.fullName),
      },
      {
        'name': 'Signals and Systems',
        'description': 'Exploration of signals and systems concepts...',
        'image': 'assets/s3.png',
        'page': () => Ss(fullName: widget.fullName),
      },
      {
        'name': 'Analog Circuits',
        'description': 'Basics of analog circuit design...',
        'image': 'assets/s3.png',
        'page': () => Ac(fullName: widget.fullName),
      },
      {
        'name': 'Microprocessors and Microcontrollers',
        'description': 'Fundamentals of microprocessors and microcontrollers...',
        'image': 'assets/s3.png',
        'page': () => Mm(fullName: widget.fullName),
      },
      {
        'name': 'Industrial Economics & Management',
        'description': 'Introduction to industrial economics and management...',
        'image': 'assets/s3.png',
        'page': () => Iem(fullName: widget.fullName),
      },
      {
        'name': 'Environmental Sciences',
        'description': 'Study of environmental science principles...',
        'image': 'assets/s3.png',
        'page': () => Es(fullName: widget.fullName),
      },
      {
        'name': 'Machine Intelligence: Methods and Applications',
        'description': 'Exploration of machine intelligence methods and applications...',
        'image': 'assets/s3.png',
        'page': () => Mi(fullName: widget.fullName),
      },
    ],
    'PYQs': [
      {
        'name': 'Probability and Random Processes PYQs',
        'description': 'Previous Year Questions for Probability and Random Processes...',
        'image': 'assets/s2.png',
        'page': () => Prd(fullName: widget.fullName),
      },
      {
        'name': 'Signals and Systems PYQs',
        'description': 'Previous Year Questions for Signals and Systems...',
        'image': 'assets/s2.png',
        'page': () => Ss(fullName: widget.fullName),
      },
      {
        'name': 'Analog Circuits PYQs',
        'description': 'Previous Year Questions for Analog Circuits...',
        'image': 'assets/s2.png',
        'page': () =>   Ac(fullName: widget.fullName),
      },
      {
        'name': 'Microprocessors and Microcontrollers PYQs',
        'description': 'Previous Year Questions for Microprocessors and Microcontrollers...',
        'image': 'assets/s2.png',
        'page': () =>   Mm(fullName: widget.fullName),
      },
      {
        'name': 'Industrial Economics & Management PYQs',
        'description': 'Previous Year Questions for Industrial Economics & Management...',
        'image': 'assets/s2.png',
        'page': () =>    Iem(fullName: widget.fullName),
      },
      {
        'name': 'Environmental Sciences PYQs',
        'description': 'Previous Year Questions for Environmental Sciences...',
        'image': 'assets/s2.png',
        'page': () =>    Es(fullName: widget.fullName),
      },
      {
        'name': 'Machine Intelligence: Methods and Applications PYQs',
        'description': 'Previous Year Questions for Machine Intelligence: Methods and Applications...',
        'image': 'assets/s2.png',
        'page': () =>   Mi(fullName: widget.fullName),
      },
    ],
  };
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 43, 448),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hey ${widget.fullName}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const Text(
                        'Select Subject',
                        style: TextStyle(fontSize: 46, color: Colors.white70),
                      ),
                    ],
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
                      radius: 30,
                      child: Text(
                        widget.fullName[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 46),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 46.0, vertical: 22),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 58, 58, 58),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: List.generate(
                            _tabs.length,
                            (index) => Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedIndex = index),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 42),
                                  decoration: BoxDecoration(
                                    color: _selectedIndex == index
                                        ? Colors.black
                                        : const Color.fromARGB(255, 58, 58, 58),
                                    borderRadius: BorderRadius.circular(25),
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
                    const SizedBox(height: 4),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 46),
                        itemCount: _subjects[_tabs[_selectedIndex]]!.length,
                        itemBuilder: (context, index) {
                          var subject = _subjects[_tabs[_selectedIndex]]![index];
                          return Card(
                            color: const Color.fromARGB(255, 58, 58, 58),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(42)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8),
                              leading: subject['image'] != null
                                  ? Image.asset(subject['image'], width: 80, height: 80)
                                  : null,
                              title: Text(subject['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              subtitle: Text(subject['description'], style: const TextStyle(color: Colors.white70)),
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
