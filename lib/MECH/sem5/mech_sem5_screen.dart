import 'package:flutter/material.dart';
import 'package:flutter_application_2/CHEMICAL/sem5/COI/coi.dart';
import 'package:flutter_application_2/MECH/sem5/IMEP/imep.dart';
import 'package:flutter_application_2/MECH/sem5/KDM/kdm.dart';
import 'package:flutter_application_2/MECH/sem5/MESD/mesd.dart';
import 'package:flutter_application_2/MECH/sem5/MRC/mrc.dart';
import 'package:flutter_application_2/MECH/sem5/OR/or.dart';
import 'package:flutter_application_2/MECH/sem5/POM/pom.dart';
import 'package:flutter_application_2/MECH/sem5/units.dart';  // Import the correct file for units
import 'package:flutter_application_2/widgets/profile.dart'; // Import the profile.dart file

class MECHSem5Screen extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const MECHSem5Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _MECHSem5ScreenState createState() => _MECHSem5ScreenState();
}

class _MECHSem5ScreenState extends State<MECHSem5Screen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Notes & Books', 'PYQs'];

  late Map<String, List<Map<String, dynamic>>> _subjects;

  @override
  void initState() {
  super.initState();

  _subjects = {
    'Notes & Books': [ 
{
        'name': 'Production & Operations Management',
        'description': 'Study of production and operations management principles...',
        'image': 'assets/s7.png',
        'page': () => Pom(fullName: widget.fullName),
      },
      {
        'name': 'Machine Element & System Design',
        'description': 'Design of machine elements and systems...',
        'image': 'assets/s7.png',
        'page': () => Mesd(fullName: widget.fullName),
      },
      {
        'name': 'Kinematics & Dynamics of Machines',
        'description': 'Study of kinematics and dynamics in mechanical systems...',
        'image': 'assets/s7.png',
        'page': () => Kdm(fullName: widget.fullName),
      },
      {
        'name': 'Mechatronics, Robotics & Control',
        'description': 'Integration of mechatronics, robotics, and control systems...',
        'image': 'assets/s7.png',
        'page': () => Mrc(fullName: widget.fullName),
      },
      {
        'name': 'Humanities – II Operations Research',
        'description': 'Operations research in humanities...',
        'image': 'assets/s7.png',
        'page': () => Or(fullName: widget.fullName),
      },
      {
        'name': 'Constitution of India',
        'description': 'Study of the Constitution of India...',
        'image': 'assets/s7.png',
        'page': () => Coi(fullName: widget.fullName),
      },
      {
        'name': 'Introduction to MEP',
        'description': 'Basics of Mechanical, Electrical, and Plumbing systems...',
        'image': 'assets/s7.png',
        'page': () => Imep(fullName: widget.fullName),
      },
    ],
    'PYQs': [
      {
        'name': 'Production & Operations Management PYQs',
        'description': 'Previous Year Questions for Production & Operations Management...',
        'image': 'assets/s2.png',
        'page': () => Pom(fullName: widget.fullName),
      },
      {
        'name': 'Machine Element & System Design PYQs',
        'description': 'Previous Year Questions for Machine Element & System Design...',
        'image': 'assets/s2.png',
        'page': () => Mesd(fullName: widget.fullName),
      },
      {
        'name': 'Kinematics & Dynamics of Machines PYQs',
        'description': 'Previous Year Questions for Kinematics & Dynamics of Machines...',
        'image': 'assets/s2.png',
        'page': () => Kdm(fullName: widget.fullName),
      },
      {
        'name': 'Mechatronics, Robotics & Control PYQs',
        'description': 'Previous Year Questions for Mechatronics, Robotics & Control...',
        'image': 'assets/s2.png',
        'page': () => Mrc(fullName: widget.fullName),
      },
      {
        'name': 'Humanities – II Operations Research PYQs',
        'description': 'Previous Year Questions for Humanities – II Operations Research...',
        'image': 'assets/s2.png',
        'page': () => Or(fullName: widget.fullName),
      },
      {
        'name': 'Constitution of India PYQs',
        'description': 'Previous Year Questions for Constitution of India...',
        'image': 'assets/s2.png',
        'page': () => Coi(fullName: widget.fullName),
      },
      {
        'name': 'Introduction to MEP PYQs',
        'description': 'Previous Year Questions for Introduction to MEP...',
        'image': 'assets/s2.png',
        'page': () => Imep(fullName: widget.fullName),
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
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
                      padding: const EdgeInsets.symmetric(horizontal: 56.0, vertical: 22),
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
                                  padding: const EdgeInsets.symmetric(vertical: 52),
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
                          var subject = _subjects[_tabs[_selectedIndex]]![index];
                          return Card(
                            color: const Color.fromARGB(255, 58, 58, 58),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(52)),
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
