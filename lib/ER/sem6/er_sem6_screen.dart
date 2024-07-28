import 'package:flutter/material.dart';
import 'package:flutter_application_2/ER/sem6/AET/aet.dart';
import 'package:flutter_application_2/ER/sem6/IIA/iia.dart';
import 'package:flutter_application_2/ER/sem6/VLSID/vlsid.dart';
import 'package:flutter_application_2/ER/sem6/units.dart';  // Import the correct file for units
import 'package:flutter_application_2/widgets/profile.dart'; // Import the profile.dart file

class ERSem6Screen extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const ERSem6Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _ERSem6ScreenState createState() => _ERSem6ScreenState();
}

class _ERSem6ScreenState extends State<ERSem6Screen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Notes & Books', 'PYQs'];

  late Map<String, List<Map<String, dynamic>>> _subjects;

  @override
  void initState() {
  super.initState();

  _subjects = {
    'Notes & Books': [
      {
    'name': 'Applied Electromagnetic Theory',
    'description': 'Study of electromagnetic theory and its applications...',
    'image': 'assets/s1.png',
    'page': () => Aet(fullName: widget.fullName),
  },
  {
    'name': 'VLSI Design',
    'description': 'Introduction to Very-Large-Scale Integration (VLSI) design principles...',
    'image': 'assets/s1.png',
    'page': () => Vlsid(fullName: widget.fullName),
  },
  {
    'name': 'Instrumentation and Industrial Automation',
    'description': 'Study of instrumentation and automation in industrial settings...',
    'image': 'assets/s1.png',
    'page': () => Iia(fullName: widget.fullName),
  },
    ],
    'PYQs': [
      {
    'name': 'Applied Electromagnetic Theory PYQs',
    'description': 'Previous Year Questions for Applied Electromagnetic Theory...',
    'image': 'assets/s2.png',
    'page': () => Aet(fullName: widget.fullName),
  },
  {
    'name': 'VLSI Design PYQs',
    'description': 'Previous Year Questions for VLSI Design...',
    'image': 'assets/s2.png',
    'page': () => Vlsid(fullName: widget.fullName),
  },
  {
    'name': 'Instrumentation and Industrial Automation PYQs',
    'description': 'Previous Year Questions for Instrumentation and Industrial Automation...',
    'image': 'assets/s2.png',
    'page': () => Iia(fullName: widget.fullName),
  },
    ],
  };
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 63, 648),
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
                        style: TextStyle(fontSize: 66, color: Colors.white70),
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
            const SizedBox(height: 66),
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
                      padding: const EdgeInsets.symmetric(horizontal: 66.0, vertical: 22),
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
                                  padding: const EdgeInsets.symmetric(vertical: 62),
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
                    const SizedBox(height: 6),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 66),
                        itemCount: _subjects[_tabs[_selectedIndex]]!.length,
                        itemBuilder: (context, index) {
                          var subject = _subjects[_tabs[_selectedIndex]]![index];
                          return Card(
                            color: const Color.fromARGB(255, 58, 58, 58),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(62)),
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
