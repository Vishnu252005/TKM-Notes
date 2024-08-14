import 'package:flutter/material.dart';
import 'package:flutter_application_2/CHEMICAL/sem4/ES/es.dart';
import 'package:flutter_application_2/CHEMICAL/sem5/COI/coi.dart';
import 'package:flutter_application_2/EEE/sem4/DC/dc.dart';
import 'package:flutter_application_2/EEE/sem6/DSP/dsp.dart';
import 'package:flutter_application_2/ER/sem5/CS/cs.dart';
import 'package:flutter_application_2/ER/sem5/ESIOT/esiot.dart';
import 'package:flutter_application_2/ER/sem5/LIC/lic.dart';
import 'package:flutter_application_2/ER/sem5/units.dart';  // Import the correct file for units
import 'package:flutter_application_2/widgets/profile.dart'; // Import the profile.dart file

class ERSem5Screen extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const ERSem5Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _ERSem5ScreenState createState() => _ERSem5ScreenState();
}

class _ERSem5ScreenState extends State<ERSem5Screen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Notes & Books', 'PYQs'];

  late Map<String, List<Map<String, dynamic>>> _subjects;

  @override
  void initState() {
  super.initState();

  _subjects = {
    'Notes & Books': [//t
  {
    'name': 'Control Systems',
    'description': 'Study of feedback and control systems in engineering...',
    'image': 'assets/s1.png',
    'page': () => Cs(fullName: widget.fullName),
  },
  {
    'name': 'Digital Signal Processing',
    'description': 'Introduction to digital signal processing techniques and applications...',
    'image': 'assets/s1.png',
    'page': () => Dsp(fullName: widget.fullName),
  },
  {
    'name': 'Embedded Systems and IoT',
    'description': 'Study of embedded systems and the Internet of Things...',
    'image': 'assets/s1.png',
    'page': () => Esiot(fullName: widget.fullName),
  },
  {
    'name': 'Digital Communication',
    'description': 'Fundamentals of digital communication systems...',
    'image': 'assets/s1.png',
    'page': () => Dc(fullName: widget.fullName),
  },
  {
    'name': 'Entrepreneurship and Startups',
    'description': 'Principles and practices of entrepreneurship and startup development...',
    'image': 'assets/s1.png',
    'page': () => Es(fullName: widget.fullName),
  },
  {
    'name': 'Constitution of India',
    'description': 'Study of the Constitution of India and its significance...',
    'image': 'assets/s1.png',
    'page': () => Coi(fullName: widget.fullName),
  },
  {
    'name': 'Linear Integrated Circuits',
    'description': 'Introduction to linear integrated circuits and their applications...',
    'image': 'assets/s1.png',
    'page': () => Lic(fullName: widget.fullName),
  },
],
'PYQs': [
  {
    'name': 'Control Systems PYQs',
    'description': 'Previous Year Questions for Control Systems...',
    'image': 'assets/s2.png',
    'page': () => Cs(fullName: widget.fullName),
  },
  {
    'name': 'Digital Signal Processing PYQs',
    'description': 'Previous Year Questions for Digital Signal Processing...',
    'image': 'assets/s2.png',
    'page': () => Dsp(fullName: widget.fullName),
  },
  {
    'name': 'Embedded Systems and IoT PYQs',
    'description': 'Previous Year Questions for Embedded Systems and IoT...',
    'image': 'assets/s2.png',
    'page': () => Esiot(fullName: widget.fullName),
  },
  {
    'name': 'Digital Communication PYQs',
    'description': 'Previous Year Questions for Digital Communication...',
    'image': 'assets/s2.png',
    'page': () => Dc(fullName: widget.fullName),
  },
  {
    'name': 'Entrepreneurship and Startups PYQs',
    'description': 'Previous Year Questions for Entrepreneurship and Startups...',
    'image': 'assets/s2.png',
    'page': () => Es(fullName: widget.fullName),
  },
  {
    'name': 'Constitution of India PYQs',
    'description': 'Previous Year Questions for Constitution of India...',
    'image': 'assets/s2.png',
    'page': () => Coi(fullName: widget.fullName),
  },
  {
    'name': 'Linear Integrated Circuits PYQs',
    'description': 'Previous Year Questions for Linear Integrated Circuits...',
    'image': 'assets/s2.png',
    'page': () => Lic(fullName: widget.fullName),
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