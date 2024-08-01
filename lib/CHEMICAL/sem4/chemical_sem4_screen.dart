import 'package:flutter/material.dart';
import 'package:flutter_application_2/CHEMICAL/sem4/CET/cet.dart';
import 'package:flutter_application_2/CHEMICAL/sem4/EAS/eas.dart';
import 'package:flutter_application_2/CHEMICAL/sem4/ES/es.dart';
import 'package:flutter_application_2/CHEMICAL/sem4/FPM/fpm.dart';
import 'package:flutter_application_2/CHEMICAL/sem4/HTO/hto.dart';
import 'package:flutter_application_2/CHEMICAL/sem4/NMCE/nmce.dart';
import 'package:flutter_application_2/CHEMICAL/sem4/PIF/pif.dart';
import 'package:flutter_application_2/CHEMICAL/sem4/units.dart';  // Import the correct file for units
import 'package:flutter_application_2/widgets/profile.dart'; // Import the profile.dart file

class CHEMICALSem4Screen extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const CHEMICALSem4Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _CHEMICALSem4ScreenState createState() => _CHEMICALSem4ScreenState();
}

class _CHEMICALSem4ScreenState extends State<CHEMICALSem4Screen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Notes & Books', 'PYQs'];

  late Map<String, List<Map<String, dynamic>>> _subjects;

  @override
  void initState() {
  super.initState();

  _subjects = {
    'Notes & Books': [
  {
    'name': 'Chemical Engineering Thermodynamics',
    'description': 'Study of thermodynamic principles applied to chemical engineering...',
    'image': 'assets/s5.png',
    'page': () => Cet(fullName: widget.fullName),
  },
  {
    'name': 'Numerical Methods for Chemical Engineers',
    'description': 'Introduction to numerical methods and their applications in chemical engineering...',
    'image': 'assets/s5.png',
    'page': () => Nmce(fullName: widget.fullName),
  },
  {
    'name': 'Fluid & Particle Mechanics',
    'description': 'Study of fluid mechanics and particle technology in chemical engineering...',
    'image': 'assets/s5.png',
    'page': () => Fpm(fullName: widget.fullName),
  },
  {
    'name': 'Heat Transfer Operations',
    'description': 'Principles and applications of heat transfer in chemical engineering...',
    'image': 'assets/s5.png',
    'page': () => Hto(fullName: widget.fullName),
  },
  {
    'name': 'Entrepreneurship and Startups',
    'description': 'Principles and practices of entrepreneurship and startup development...',
    'image': 'assets/s5.png',
    'page': () => Eas(fullName: widget.fullName),
  },
  {
    'name': 'Environmental Sciences',
    'description': 'Study of environmental science principles and their applications...',
    'image': 'assets/s5.png',
    'page': () => Es(fullName: widget.fullName),
  },
  {
    'name': 'Piping and Instrumentation Fundamentals',
    'description': 'Introduction to piping and instrumentation in chemical engineering...',
    'image': 'assets/s5.png',
    'page': () => Pif(fullName: widget.fullName),
  },
],
'PYQs': [
  {
    'name': 'Chemical Engineering Thermodynamics PYQs',
    'description': 'Previous Year Questions for Chemical Engineering Thermodynamics...',
    'image': 'assets/s2.png',
    'page': () =>   Cet(fullName: widget.fullName),
  },
  {
    'name': 'Numerical Methods for Chemical Engineers PYQs',
    'description': 'Previous Year Questions for Numerical Methods for Chemical Engineers...',
    'image': 'assets/s2.png',
    'page': () =>   Nmce(fullName: widget.fullName),
  },
  {
    'name': 'Fluid & Particle Mechanics PYQs',
    'description': 'Previous Year Questions for Fluid & Particle Mechanics...',
    'image': 'assets/s2.png',
    'page': () =>   Fpm(fullName: widget.fullName),
  },
  {
    'name': 'Heat Transfer Operations PYQs',
    'description': 'Previous Year Questions for Heat Transfer Operations...',
    'image': 'assets/s2.png',
    'page': () => Hto(fullName: widget.fullName),
  },
  {
    'name': 'Entrepreneurship and Startups PYQs',
    'description': 'Previous Year Questions for Entrepreneurship and Startups...',
    'image': 'assets/s2.png',
    'page': () => Eas(fullName: widget.fullName),
  },
  {
    'name': 'Environmental Sciences PYQs',
    'description': 'Previous Year Questions for Environmental Sciences...',
    'image': 'assets/s2.png',
    'page': () => Es(fullName: widget.fullName),
  },
  {
    'name': 'Piping and Instrumentation Fundamentals PYQs',
    'description': 'Previous Year Questions for Piping and Instrumentation Fundamentals...',
    'image': 'assets/s2.png',
    'page': () => Pif(fullName: widget.fullName),
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
