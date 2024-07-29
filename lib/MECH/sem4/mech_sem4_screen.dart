import 'package:flutter/material.dart';
import 'package:flutter_application_2/CHEMICAL/sem4/ES/es.dart';
import 'package:flutter_application_2/CSE/sem4/BE/be.dart';
import 'package:flutter_application_2/EEE/sem4/FA/fa.dart';
import 'package:flutter_application_2/MECH/sem3/MM/mm.dart';
import 'package:flutter_application_2/MECH/sem4/HTTM/httm.dart';
import 'package:flutter_application_2/MECH/sem4/MDS/mds.dart';
import 'package:flutter_application_2/MECH/sem4/MP/mp.dart';
import 'package:flutter_application_2/MECH/sem4/units.dart'; // Import the correct file for units
import 'package:flutter_application_2/widgets/profile.dart'; // Import the profile.dart file

class MECHSem4Screen extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const MECHSem4Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _MECHSem4ScreenState createState() => _MECHSem4ScreenState();
}

class _MECHSem4ScreenState extends State<MECHSem4Screen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Notes & Books', 'PYQs'];

  late Map<String, List<Map<String, dynamic>>> _subjects;

  @override
  void initState() {
    super.initState();

    _subjects = {
      'Notes & Books': [
        {
          'name': 'Mechanics of Deformable Solids',
          'description':
              'Study of mechanics related to deformable solid materials...',
          'image': 'assets/s2.png',
          'page': () => Mds(fullName: widget.fullName),
        },
        {
          'name': 'Measurements & Metrology',
          'description':
              'Exploration of measurement techniques and metrology...',
          'image': 'assets/s2.png',
          'page': () => Mm(fullName: widget.fullName),
        },
        {
          'name': 'Manufacturing Processes',
          'description': 'Introduction to various manufacturing processes...',
          'image': 'assets/s2.png',
          'page': () => Mp(fullName: widget.fullName),
        },
        {
          'name': 'Heat Transfer & Thermal Machines',
          'description':
              'Fundamentals of heat transfer and thermal machinery...',
          'image': 'assets/s2.png',
          'page': () => Httm(fullName: widget.fullName),
        },
        {
          'name': 'Management – I (Finance and Accounting)',
          'description':
              'Principles of finance and accounting in management...',
          'image': 'assets/s2.png',
          'page': () => Fa(fullName: widget.fullName),
        },
        {
          'name': 'Environmental Sciences',
          'description':
              'Study of environmental science principles and applications...',
          'image': 'assets/s2.png',
          'page': () => Es(fullName: widget.fullName),
        },
        {
          'name': 'Biology for Engineers',
          'description':
              'Introduction to biological concepts relevant to engineering...',
          'image': 'assets/s2.png',
          'page': () => Be(fullName: widget.fullName),
        },
      ],
      'PYQs': [
        {
          'name': 'Mechanics of Deformable Solids PYQs',
          'description':
              'Previous Year Questions for Mechanics of Deformable Solids...',
          'image': 'assets/s2.png',
          'page': () => Mds(fullName: widget.fullName),
        },
        {
          'name': 'Measurements & Metrology PYQs',
          'description':
              'Previous Year Questions for Measurements & Metrology...',
          'image': 'assets/s2.png',
          'page': () => Mm(fullName: widget.fullName),
        },
        {
          'name': 'Manufacturing Processes PYQs',
          'description':
              'Previous Year Questions for Manufacturing Processes...',
          'image': 'assets/s2.png',
          'page': () => Mp(fullName: widget.fullName),
        },
        {
          'name': 'Heat Transfer & Thermal Machines PYQs',
          'description':
              'Previous Year Questions for Heat Transfer & Thermal Machines...',
          'image': 'assets/s2.png',
          'page': () => Httm(fullName: widget.fullName),
        },
        {
          'name': 'Management – I (Finance and Accounting) PYQs',
          'description':
              'Previous Year Questions for Management – I (Finance and Accounting)...',
          'image': 'assets/s2.png',
          'page': () => Fa(fullName: widget.fullName),
        },
        {
          'name': 'Environmental Sciences PYQs',
          'description':
              'Previous Year Questions for Environmental Sciences...',
          'image': 'assets/s2.png',
          'page': () => Es(fullName: widget.fullName),
        },
        {
          'name': 'Biology for Engineers PYQs',
          'description': 'Previous Year Questions for Biology for Engineers...',
          'image': 'assets/s2.png',
          'page': () => Be(fullName: widget.fullName),
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