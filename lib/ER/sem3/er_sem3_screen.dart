import 'package:flutter/material.dart';
import 'package:flutter_application_2/CIVIL/sem3/LSPE/lspe.dart';
import 'package:flutter_application_2/CSE/sem3/LSPE/lspe.dart';
import 'package:flutter_application_2/CSE/sem3/PDE/pde.dart';
import 'package:flutter_application_2/EC/sem3/NT/nt.dart';
import 'package:flutter_application_2/ER/sem3/CA/ca.dart';
import 'package:flutter_application_2/ER/sem3/LCD/lcd.dart';
import 'package:flutter_application_2/ER/sem3/SCP/scp.dart';
import 'package:flutter_application_2/ER/sem3/SD/sd-copy.dart';
import 'package:flutter_application_2/ER/sem3/SD/sd.dart';
import 'package:flutter_application_2/ER/sem3/units.dart';  // Import the correct file for units
import 'package:flutter_application_2/widgets/profile.dart'; // Import the profile.dart file

class ERSem3Screen extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const ERSem3Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _ERSem3ScreenState createState() => _ERSem3ScreenState();
}

class _ERSem3ScreenState extends State<ERSem3Screen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Notes & Books', 'PYQs'];

  late Map<String, List<Map<String, dynamic>>> _subjects;

  @override
  void initState() {
  super.initState();

  _subjects = {
    'Notes & Books': [
      {
        'name': 'Advanced Linear Algebra Complex Analysis and Partial Differential Equations',
        'description': 'Study of advanced linear algebra, complex analysis, and partial differential equations...',
        'image': 'assets/s1.png',
        'page': () => Pde(fullName: widget.fullName),
      },
      {
        'name': 'Scientific Computing Using Python',
        'description': 'Exploration of scientific computing using Python...',
        'image': 'assets/s1.png',
        'page': () => Scp(fullName: widget.fullName),
      },
      {
        'name': 'Logic Circuit Design',
        'description': 'Basics of logic circuit design...',
        'image': 'assets/s1.png',
        'page': () => Lcd(fullName: widget.fullName),
      },
      {
        'name': 'Semiconductor Devices',
        'description': 'Fundamentals of semiconductor devices...',
        'image': 'assets/s1.png',
        'page': () => Sd(fullName: widget.fullName),
      },
      {
        'name': 'Network Theory',
        'description': 'Introduction to network theory...',
        'image': 'assets/s1.png',
        'page': () => Nt(fullName: widget.fullName),
      },
      {
        'name': 'Life Skills and Professional Ethics',
        'description': 'Physical education and well-being through life skills and professional ethics...',
        'image': 'assets/s1.png',
        'page': () => Lspe(fullName: widget.fullName),
      },
      {
        'name': 'Computer Architecture',
        'description': 'Introduction to computer architecture principles...',
        'image': 'assets/s1.png',
        'page': () => Ca(fullName: widget.fullName),
      },
    ],
    'PYQs': [
      {
        'name': 'Advanced Linear Algebra Complex Analysis and Partial Differential Equations PYQs',
        'description': 'Previous Year Questions for Advanced Linear Algebra, Complex Analysis, and Partial Differential Equations...',
        'image': 'assets/s2.png',
        'page': () => Pde(fullName: widget.fullName),
      },
      {
        'name': 'Scientific Computing Using Python PYQs',
        'description': 'Previous Year Questions for Scientific Computing Using Python...',
        'image': 'assets/s2.png',
        'page': () => Scp(fullName: widget.fullName),
      },
      {
        'name': 'Logic Circuit Design PYQs',
        'description': 'Previous Year Questions for Logic Circuit Design...',
        'image': 'assets/s2.png',
        'page': () =>   Lcd(fullName: widget.fullName),
      },
      {
        'name': 'Semiconductor Devices PYQs',
        'description': 'Previous Year Questions for Semiconductor Devices...',
        'image': 'assets/s2.png',
        'page': () => Sd(fullName: widget.fullName),
      },
      {
        'name': 'Network Theory PYQs',
        'description': 'Previous Year Questions for Network Theory...',
        'image': 'assets/s2.png',
        'page': () => Nt(fullName: widget.fullName),
      },
      {
        'name': 'Life Skills and Professional Ethics PYQs',
        'description': 'Previous Year Questions for Life Skills and Professional Ethics...',
        'image': 'assets/s2.png',
        'page': () => Lspe(fullName: widget.fullName),
      },
      {
        'name': 'Computer Architecture PYQs',
        'description': 'Previous Year Questions for Computer Architecture...',
        'image': 'assets/s2.png',
        'page': () => Ca(fullName: widget.fullName),
      },
    ],

  };
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 33, 348),
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
                        style: TextStyle(fontSize: 36, color: Colors.white70),
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
            const SizedBox(height: 36),
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
                      padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 22),
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
                                  padding: const EdgeInsets.symmetric(vertical: 32),
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
                    const SizedBox(height: 3),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 36),
                        itemCount: _subjects[_tabs[_selectedIndex]]!.length,
                        itemBuilder: (context, index) {
                          var subject = _subjects[_tabs[_selectedIndex]]![index];
                          return Card(
                            color: const Color.fromARGB(255, 58, 58, 58),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
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
