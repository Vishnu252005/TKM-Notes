import 'package:flutter/material.dart';
import 'package:flutter_application_2/CIVIL/sem5/AICE/aice.dart';
import 'package:flutter_application_2/CIVIL/sem5/DSI/ds1.dart';
import 'package:flutter_application_2/CIVIL/sem5/EE/ee.dart';
import 'package:flutter_application_2/CIVIL/sem5/FE/fe.dart';
import 'package:flutter_application_2/CIVIL/sem5/HWRE/hwre.dart';
import 'package:flutter_application_2/CIVIL/sem5/ME/me.dart';
import 'package:flutter_application_2/CIVIL/sem5/units.dart'; // Import the correct file for units
import 'package:flutter_application_2/EEE/sem5/CI/ci.dart';
import 'package:flutter_application_2/widgets/profile.dart'; // Import the profile.dart file

class CIVILSem5Screen extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const CIVILSem5Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _CIVILSem5ScreenState createState() => _CIVILSem5ScreenState();
}

class _CIVILSem5ScreenState extends State<CIVILSem5Screen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Notes & Books', 'PYQs'];

  late Map<String, List<Map<String, dynamic>>> _subjects;

  @override
  void initState() {
    super.initState();

    _subjects = {
      'Notes & Books': [
        {
          'name': 'Hydrology and Water Resources Engineering',
          'description':
              'Study of hydrology and water resources engineering...',
          'image': 'assets/s5.png',
          'page': () => hwre(fullName: widget.fullName),
        },
        {
          'name': 'Foundation Engineering',
          'description': 'PBC Foundation Engineering principles...',
          'image': 'assets/s5.png',
          'page': () => Fe(fullName: widget.fullName),
        },
        {
          'name': 'Environmental Engineering',
          'description': 'PCC Environmental Engineering concepts...',
          'image': 'assets/s5.png',
          'page': () => Ee(fullName: widget.fullName),
        },
        {
          'name': 'Design of Structures I',
          'description': 'PCC Design of Structures I principles...',
          'image': 'assets/s5.png',
          'page': () => Ds1(fullName: widget.fullName),
        },
        {
          'name': 'Management for Engineers',
          'description': 'HSMC Management principles for engineers...',
          'image': 'assets/s5.png',
          'page': () => Me(fullName: widget.fullName),
        },
        {
          'name': 'Constitution of India',
          'description': 'MC Constitution of India concepts...',
          'image': 'assets/s5.png',
          'page': () => Ci(fullName: widget.fullName),
        },
        {
          'name': 'Artificial Intelligence for Civil Engineers',
          'description':
              'PCC Artificial Intelligence applications in civil engineering...',
          'image': 'assets/s5.png',
          'page': () => Aice(fullName: widget.fullName),
        },
      ],
      'PYQs': [
        {
          'name': 'Hydrology and Water Resources Engineering PYQs',
          'description':
              'Previous Year Questions for Hydrology and Water Resources Engineering...',
          'image': 'assets/s2.png',
          'page': () => hwre(fullName: widget.fullName),
        },
        {
          'name': 'Foundation Engineering PYQs',
          'description':
              'Previous Year Questions for Foundation Engineering...',
          'image': 'assets/s2.png',
          'page': () => Fe(fullName: widget.fullName),
        },
        {
          'name': 'Environmental Engineering PYQs',
          'description':
              'Previous Year Questions for Environmental Engineering...',
          'image': 'assets/s2.png',
          'page': () => Ee(fullName: widget.fullName),
        },
        {
          'name': 'Design of Structures I PYQs',
          'description':
              'Previous Year Questions for Design of Structures I...',
          'image': 'assets/s2.png',
          'page': () => Ds1(fullName: widget.fullName),
        },
        {
          'name': 'Management for Engineers PYQs',
          'description':
              'Previous Year Questions for Management for Engineers...',
          'image': 'assets/s2.png',
          'page': () => Me(fullName: widget.fullName),
        },
        {
          'name': 'Constitution of India PYQs',
          'description': 'Previous Year Questions for Constitution of India...',
          'image': 'assets/s2.png',
          'page': () => Ci(fullName: widget.fullName),
        },
        {
          'name': 'Artificial Intelligence for Civil Engineers PYQs',
          'description':
              'Previous Year Questions for Artificial Intelligence for Civil Engineers...',
          'image': 'assets/s2.png',
          'page': () => Aice(fullName: widget.fullName),
        },
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 53, 548),
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
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const Text(
                        'Select Subject',
                        style: TextStyle(fontSize: 56, color: Colors.white70),
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
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 56),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 56.0, vertical: 22),
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
                                onTap: () =>
                                    setState(() => _selectedIndex = index),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 52),
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
                    const SizedBox(height: 5),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 56),
                        itemCount: _subjects[_tabs[_selectedIndex]]!.length,
                        itemBuilder: (context, index) {
                          var subject =
                              _subjects[_tabs[_selectedIndex]]![index];
                          return Card(
                            color: const Color.fromARGB(255, 58, 58, 58),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(52)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8),
                              leading: subject['image'] != null
                                  ? Image.asset(subject['image'],
                                      width: 80, height: 80)
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
