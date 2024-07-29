import 'package:flutter/material.dart';
import 'package:flutter_application_2/MECH/sem2/ENGLISH/english%20-%20Copy.dart';
import 'package:flutter_application_2/MECH/sem2/ENGLISH/english.dart';
import 'package:flutter_application_2/MECH/sem2/IDEALAB/idealab%20-%20Copy.dart';
import 'package:flutter_application_2/MECH/sem2/IDEALAB/idealab.dart';
import 'package:flutter_application_2/MECH/sem2/MATHS/maths%20-%20Copy.dart';
import 'package:flutter_application_2/MECH/sem2/MATHS/maths.dart';
import 'package:flutter_application_2/MECH/sem2/PHYSICS/physics%20-%20Copy.dart';
import 'package:flutter_application_2/MECH/sem2/PHYSICS/physics.dart';
import 'package:flutter_application_2/MECH/sem2/PSP/psp%20-%20Copy.dart';
import 'package:flutter_application_2/MECH/sem2/PSP/psp.dart';
import 'package:flutter_application_2/MECH/sem2/UHV/uhv%20-%20Copy.dart';
import 'package:flutter_application_2/MECH/sem2/UHV/uhv.dart';
import 'package:flutter_application_2/widgets/profile.dart'; // Import the profile.dart file

class MECHSem2Screen extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const MECHSem2Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _MECHSem2ScreenState createState() => _MECHSem2ScreenState();
}

class _MECHSem2ScreenState extends State<MECHSem2Screen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Notes & Books', 'PYQs'];

  late Map<String, List<Map<String, dynamic>>> _subjects;

  @override
  void initState() {
  super.initState();

  _subjects = {
    'Notes & Books': [
      {
        'name': 'Differential Equations and Transforms',
        'description': 'Study of differential equations and various transforms...',
        'image': 'assets/s1.png',
        'page': () => maths(fullName: widget.fullName),
      },
      {
        'name': 'Engineering Physics',
        'description': 'Exploration of fundamental concepts in physics...',
        'image': 'assets/s1.png',
        'page': () => physics(fullName: widget.fullName),
      },
      {
        'name': 'Problem Solving and Programming',
        'description': 'Basics of programming and problem-solving techniques...',
        'image': 'assets/s1.png',
        'page': () => Psp(fullName: widget.fullName),
      },
      {
        'name': 'Technical English for Engineers',
        'description': 'Improving technical English communication skills...',
        'image': 'assets/s1.png',
        'page': () => english(fullName: widget.fullName),
      },
      {
        'name': 'IDEA Lab Workshop',
        'description': 'Hands-on workshop for innovation and design...',
        'image': 'assets/s1.png',
        'page': () => idea(fullName: widget.fullName),
      },
      // {
      //   'name': 'Design Thinking',
      //   'description': 'Problem-solving approach using design thinking principles...',
      //   'image': 'assets/s1.png',
      //   'page': () => ComputerNetworksPage(fullName: widget.fullName),
      // },
      {
        'name': 'Universal Human Values-II',
        'description': 'Exploration of universal human values...',
        'image': 'assets/s1.png',
        'page': () => Uhv(fullName: widget.fullName),
      },
    ],
    'PYQs': [
      {
        'name': 'Differential Equations and Transforms PYQs',
        'description': 'Previous Year Questions for Differential Equations and Transforms...',
        'image': 'assets/s2.png',
        'page': () => maths1(fullName: widget.fullName),
      },
      {
        'name': 'Engineering Physics PYQs',
        'description': 'Previous Year Questions for Engineering Physics...',
        'image': 'assets/s2.png',
        'page': () => physics1(fullName: widget.fullName),
      },
      {
        'name': 'Problem Solving and Programming PYQs',
        'description': 'Previous Year Questions for Problem Solving and Programming...',
        'image': 'assets/s2.png',
        'page': () =>Psp1(fullName: widget.fullName),
      },
      {
        'name': 'Technical English for Engineers PYQs',
        'description': 'Previous Year Questions for Technical English for Engineers...',
        'image': 'assets/s2.png',
        'page': () => english1(fullName: widget.fullName),
      },
      {
        'name': 'IDEA Lab Workshop PYQs',
        'description': 'Previous Year Questions for IDEA Lab Workshop...',
        'image': 'assets/s2.png',
        'page': () => idea1(fullName: widget.fullName),
      },
      // {
      //   'name': 'Design Thinking PYQs',
      //   'description': 'Previous Year Questions for Design Thinking...',
      //   'image': 'assets/s2.png',
      //   'page': () => ComputerNetworksPage(fullName: widget.fullName),
      // },
      {
        'name': 'Universal Human Values-II PYQs',
        'description': 'Previous Year Questions for Universal Human Values-II...',
        'image': 'assets/s2.png',
        'page': () => Uhv1(fullName: widget.fullName),
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