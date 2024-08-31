import 'package:flutter/material.dart';
import 'package:Nexia/EC/sem5/OS/os.dart';
import 'package:Nexia/EC/sem5/AI/ai.dart';
import 'package:Nexia/EC/sem5/ESDIOT/esdiot.dart';
import 'package:Nexia/EC/sem5/PMF/pmf.dart';
import 'package:Nexia/EC/sem5/units.dart';  // Import the correct file for units
import 'package:Nexia/ER/sem5/CS/cs.dart';
import 'package:Nexia/EC/sem5/SE/se.dart';
import 'package:Nexia/widgets/profile.dart'; // Import the profile.dart file

class ECSem5Screen extends StatefulWidget {//t
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const ECSem5Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _ECSem5ScreenState createState() => _ECSem5ScreenState();
}

class _ECSem5ScreenState extends State<ECSem5Screen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Notes & Books', 'PYQs'];

  late Map<String, List<Map<String, dynamic>>> _subjects;

  @override
  void initState() {
  super.initState();

  _subjects = {
    'Notes & Books': [
      {
        'name': 'Control Systems',
        'description': 'Study of control systems and their applications...',
        'image': 'assets/s1.png',
        'page': () => Cs(fullName: widget.fullName),
      },
      {
        'name': 'Embedded System Design and IoT',
        'description': 'Design of embedded systems and applications in IoT...',
        'image': 'assets/s1.png',
        'page': () => Esdiot(fullName: widget.fullName),
      },
      {
        'name': 'Artificial Intelligence: Theory and Applications',
        'description': 'Theory and applications of artificial intelligence...',
        'image': 'assets/s1.png',
        'page': () => Ai(fullName: widget.fullName),
      },
      {
        'name': 'Operating Systems',
        'description': 'Study of operating systems principles and applications...',
        'image': 'assets/s1.png',
        'page': () => Os(fullName: widget.fullName),
      },
      {
        'name': 'Project Management and Finance',
        'description': 'Principles of project management and finance...',
        'image': 'assets/s1.png',
        'page': () => Pmf(fullName: widget.fullName),
      },
      {
        'name': 'Software Engineering',
        'description': 'Study of software engineering principles and practices...',
        'image': 'assets/s1.png',
        'page': () => Se(fullName: widget.fullName),
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
        'name': 'Embedded System Design and IoT PYQs',
        'description': 'Previous Year Questions for Embedded System Design and IoT...',
        'image': 'assets/s2.png',
        'page': () => Esdiot(fullName: widget.fullName),
      },
      {
        'name': 'Artificial Intelligence: Theory and Applications PYQs',
        'description': 'Previous Year Questions for Artificial Intelligence: Theory and Applications...',
        'image': 'assets/s2.png',
        'page': () =>   Ai(fullName: widget.fullName),
      },
      {
        'name': 'Operating Systems PYQs',
        'description': 'Previous Year Questions for Operating Systems...',
        'image': 'assets/s2.png',
        'page': () =>    Os(fullName: widget.fullName),
      },
      {
        'name': 'Project Management and Finance PYQs',
        'description': 'Previous Year Questions for Project Management and Finance...',
        'image': 'assets/s2.png',
        'page': () =>   Pmf(fullName: widget.fullName),
      },
      {
        'name': 'Software Engineering PYQs',
        'description': 'Previous Year Questions for Software Engineering...',
        'image': 'assets/s2.png',
        'page': () =>   Se(fullName: widget.fullName),
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