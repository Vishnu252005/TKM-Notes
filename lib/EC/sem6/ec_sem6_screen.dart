import 'package:flutter/material.dart';
import 'package:flutter_application_2/CSE/sem4/CN/cn.dart';
import 'package:flutter_application_2/EC/sem6/DMS/dms.dart';
import 'package:flutter_application_2/EC/sem6/PED/ped.dart';
import 'package:flutter_application_2/EC/sem6/units.dart';  // Import the correct file for units
import 'package:flutter_application_2/widgets/profile.dart'; // Import the profile.dart file

class ECSem6Screen extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const ECSem6Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _ECSem6ScreenState createState() => _ECSem6ScreenState();
}

class _ECSem6ScreenState extends State<ECSem6Screen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Notes & Books', 'PYQs'];

  late Map<String, List<Map<String, dynamic>>> _subjects;

  @override
  void initState() {
  super.initState();

  _subjects = {
    'Notes & Books': [
      {
        'name': 'Computer Networks',
        'description': 'Study of computer networks and their applications...',
        'image': 'assets/s1.png',
        'page': () => Cn(fullName: widget.fullName),
      },
      {
        'name': 'Database Management Systems',
        'description': 'Study of database management systems and applications...',
        'image': 'assets/s1.png',
        'page': () => Dms(fullName: widget.fullName),
      },
      {
        'name': 'Power Electronics & Drives',
        'description': 'Study of power electronics and drive systems...',
        'image': 'assets/s1.png',
        'page': () => Ped(fullName: widget.fullName),
      },
    ],
    'PYQs': [
      {
        'name': 'Computer Networks PYQs',
        'description': 'Previous Year Questions for Computer Networks...',
        'image': 'assets/s2.png',
        'page': () => Cn(fullName: widget.fullName),
      },
      {
        'name': 'Database Management Systems PYQs',
        'description': 'Previous Year Questions for Database Management Systems...',
        'image': 'assets/s2.png',
        'page': () => Dms(fullName: widget.fullName),
      },
      {
        'name': 'Power Electronics & Drives PYQs',
        'description': 'Previous Year Questions for Power Electronics & Drives...',
        'image': 'assets/s2.png',
        'page': () => Ped(fullName: widget.fullName),
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