import 'package:flutter/material.dart';
import 'package:flutter_application_2/CHEMICAL/sem1/BEE/bee.dart';
import 'package:flutter_application_2/CHEMICAL/sem3/PBCA/pbca.dart';
import 'package:flutter_application_2/CIVIL/sem5/EE/ee.dart';
import 'package:flutter_application_2/EEE/sem3/BEM/bem.dart';
import 'package:flutter_application_2/EEE/sem5/IEM/iem.dart';
import 'package:flutter_application_2/MECH/sem3/AT/at.dart';
import 'package:flutter_application_2/MECH/sem3/EMA/ema.dart';
import 'package:flutter_application_2/MECH/sem3/FMHM/fmhm.dart';
import 'package:flutter_application_2/MECH/sem3/FMM/fmm.dart';
import 'package:flutter_application_2/MECH/sem3/MM/mm.dart';
import 'package:flutter_application_2/MECH/sem3/MMT/mmt.dart';
import 'package:flutter_application_2/MECH/sem3/SE/se.dart';
import 'package:flutter_application_2/MECH/sem3/units.dart'; // Import the correct file for units
import 'package:flutter_application_2/widgets/profile.dart'; // Import the profile.dart file

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

  late Map<String, List<Map<String, dynamic>>> _subjects;

  @override
  void initState() {
    super.initState();

    _subjects = {
      'Notes & Books': [
        {
          'name': 'Probability Distributions and Complex Analysis',
          'description':
              'Study of probability distributions and complex analysis including...',
          'image': 'assets/s1.png',
          'page': () => Pbca(fullName: widget.fullName),
        },
        {
          'name': 'Sustainable Engineering',
          'description':
              'Introduction to sustainable engineering practices and principles...',
          'image': 'assets/s1.png',
          'page': () => Se(fullName: widget.fullName),
        },
        {
          'name': 'Engineering Materials & Applications',
          'description':
              'Exploration of engineering materials and their applications...',
          'image': 'assets/s1.png',
          'page': () => Ema(fullName: widget.fullName),
        },
        {
          'name': 'Fluid Mechanics & Hydraulic Machines',
          'description':
              'Fundamentals of fluid mechanics and hydraulic machines...',
          'image': 'assets/s1.png',
          'page': () => Fmhm(fullName: widget.fullName),
        },
        {
          'name': 'Applied Thermodynamics',
          'description':
              'Study of applied thermodynamics and its applications...',
          'image': 'assets/s1.png',
          'page': () => At(fullName: widget.fullName),
        },
        {
          'name': 'Engineering Economics',
          'description':
              'Introduction to engineering economics and financial principles...',
          'image': 'assets/s1.png',
          'page': () => Ee(fullName: widget.fullName),
        },
        {
          'name': 'Basic Engineering Mechanics',
          'description': 'Fundamentals of engineering mechanics...',
          'image': 'assets/s1.png',
          'page': () => Bem(fullName: widget.fullName),
        },
        {
          'name': 'Fluid Mechanics & Machinery',
          'description': 'Basics of fluid mechanics and machinery...',
          'image': 'assets/s1.png',
          'page': () => Fmm(fullName: widget.fullName),
        },
        {
          'name': 'Mechanics of Materials',
          'description': 'Principles of Mechanics of Materials...',
          'image': 'assets/s1.png',
          'page': () => Mm(fullName: widget.fullName),
        },
        {
          'name': 'Material Science and Technology',
          'description': 'Study of material science and technology...',
          'image': 'assets/s1.png',
          'page': () => Mmt(fullName: widget.fullName),
        },
        {
          'name': 'Industrial Engineering and Management',
          'description':
              'Principles of industrial engineering and management...',
          'image': 'assets/s1.png',
          'page': () => Iem(fullName: widget.fullName),
        },
      ],
      'PYQs': [
        {
          'name': 'Probability Distributions and Complex Analysis PYQs',
          'description':
              'Previous Year Questions for Probability Distributions and Complex Analysis...',
          'image': 'assets/s2.png',
          'page': () => Pbca(fullName: widget.fullName),
        },
        {
          'name': 'Sustainable Engineering PYQs',
          'description':
              'Previous Year Questions for Sustainable Engineering...',
          'image': 'assets/s2.png',
          'page': () => Se(fullName: widget.fullName),
        },
        {
          'name': 'Engineering Materials & Applications PYQs',
          'description':
              'Previous Year Questions for Engineering Materials & Applications...',
          'image': 'assets/s2.png',
          'page': () => Ema(fullName: widget.fullName),
        },
        {
          'name': 'Fluid Mechanics & Hydraulic Machines PYQs',
          'description':
              'Previous Year Questions for Fluid Mechanics & Hydraulic Machines...',
          'image': 'assets/s2.png',
          'page': () => Fmhm(fullName: widget.fullName),
        },
        {
          'name': 'Applied Thermodynamics PYQs',
          'description':
              'Previous Year Questions for Applied Thermodynamics...',
          'image': 'assets/s2.png',
          'page': () => At(fullName: widget.fullName),
        },
        {
          'name': 'Engineering Economics PYQs',
          'description': 'Previous Year Questions for Engineering Economics...',
          'image': 'assets/s2.png',
          'page': () => Ee(fullName: widget.fullName),
        },
        {
          'name': 'Basic Engineering Mechanics PYQs',
          'description':
              'Previous Year Questions for Basic Engineering Mechanics...',
          'image': 'assets/s2.png',
          'page': () => bee(fullName: widget.fullName),
        },
        {
          'name': 'Fluid Mechanics & Machinery PYQs',
          'description':
              'Previous Year Questions for Fluid Mechanics & Machinery...',
          'image': 'assets/s2.png',
          'page': () => Fmm(fullName: widget.fullName),
        },
        {
          'name': 'Mechanics of Materials PYQs',
          'description':
              'Previous Year Questions for Mechanics of Materials...',
          'image': 'assets/s2.png',
          'page': () => Mm(fullName: widget.fullName),
        },
        {
          'name': 'Material Science and Technology PYQs',
          'description':
              'Previous Year Questions for Material Science and Technology...',
          'image': 'assets/s2.png',
          'page': () => Mmt(fullName: widget.fullName),
        },
        {
          'name': 'Industrial Engineering and Management PYQs',
          'description':
              'Previous Year Questions for Industrial Engineering and Management...',
          'image': 'assets/s2.png',
          'page': () => Iem(fullName: widget.fullName),
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
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36.0, vertical: 22),
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
                                      const EdgeInsets.symmetric(vertical: 32),
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
                          var subject =
                              _subjects[_tabs[_selectedIndex]]![index];
                          return Card(
                            color: const Color.fromARGB(255, 58, 58, 58),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32)),
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
