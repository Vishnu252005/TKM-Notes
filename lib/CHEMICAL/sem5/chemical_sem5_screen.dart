import 'package:flutter/material.dart';
import 'package:flutter_application_2/CHEMICAL/sem5/COI/coi.dart';
import 'package:flutter_application_2/CHEMICAL/sem5/EEA/eea.dart';
import 'package:flutter_application_2/CHEMICAL/sem5/EMCI/emci.dart';
import 'package:flutter_application_2/CHEMICAL/sem5/KRD/krd.dart';
import 'package:flutter_application_2/CHEMICAL/sem5/MTO1/mto1.dart';
import 'package:flutter_application_2/CHEMICAL/sem5/PT/pt.dart';
import 'package:flutter_application_2/CHEMICAL/sem5/TP/tp.dart';
import 'package:flutter_application_2/CHEMICAL/sem5/units.dart';  // Import the correct file for units
import 'package:flutter_application_2/widgets/profile.dart'; // Import the profile.dart file

class CHEMICALSem5Screen extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const CHEMICALSem5Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _CHEMICALSem5ScreenState createState() => _CHEMICALSem5ScreenState();
}

class _CHEMICALSem5ScreenState extends State<CHEMICALSem5Screen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Notes & Books', 'PYQs'];

  late Map<String, List<Map<String, dynamic>>> _subjects;

  @override
  void initState() {
  super.initState();

  _subjects = {
    'Notes & Books': [
  {
    'name': 'Mass Transfer Operations - I',
    'description': 'Study of mass transfer operations in chemical engineering...',
    'image': 'assets/s1.png',
    'page': () => Mto1(fullName: widget.fullName),
  },
  {
    'name': 'KINETICS AND REACTOR DESIGN',
    'description': 'Exploration of chemical kinetics and reactor design principles...',
    'image': 'assets/s1.png',
    'page': () => Krd(fullName: widget.fullName),
  },
  {
    'name': 'TRANSPORT PHENOMENA',
    'description': 'Introduction to the principles of transport phenomena...',
    'image': 'assets/s1.png',
    'page': () => Tp(fullName: widget.fullName),
  },
  {
    'name': 'Particle Technology',
    'description': 'Fundamentals of particle technology in chemical engineering...',
    'image': 'assets/s1.png',
    'page': () => Pt(fullName: widget.fullName),
  },
  {
    'name': 'ECONOMICS AND MANAGEMENT FOR CHEMICAL INDUSTRIES',
    'description': 'Introduction to economics and management in chemical industries...',
    'image': 'assets/s1.png',
    'page': () => Emci(fullName: widget.fullName),
  },
  {
    'name': 'CONSTITUTION OF INDIA',
    'description': 'Study of the Constitution of India and its significance...',
    'image': 'assets/s1.png',
    'page': () => Coi(fullName: widget.fullName),
  },
  {
    'name': 'ENERGY & ENVIRONMENTAL AUDIT',
    'description': 'Basic concepts in energy and environmental auditing...',
    'image': 'assets/s1.png',
    'page': () => Eea(fullName: widget.fullName),
  },
],
'PYQs': [
  {
    'name': 'Mass Transfer Operations - I PYQs',
    'description': 'Previous Year Questions for Mass Transfer Operations - I...',
    'image': 'assets/s2.png',
    'page': () => Mto1(fullName: widget.fullName),
  },
  {
    'name': 'KINETICS AND REACTOR DESIGN PYQs',
    'description': 'Previous Year Questions for Kinetics and Reactor Design...',
    'image': 'assets/s2.png',
    'page': () => Krd(fullName: widget.fullName),
  },
  {
    'name': 'TRANSPORT PHENOMENA PYQs',
    'description': 'Previous Year Questions for Transport Phenomena...',
    'image': 'assets/s2.png',
    'page': () => Tp(fullName: widget.fullName),
  },
  {
    'name': 'Particle Technology PYQs',
    'description': 'Previous Year Questions for Particle Technology...',
    'image': 'assets/s2.png',
    'page': () => Pt(fullName: widget.fullName),
  },
  {
    'name': 'ECONOMICS AND MANAGEMENT FOR CHEMICAL INDUSTRIES PYQs',
    'description': 'Previous Year Questions for Economics and Management for Chemical Industries...',
    'image': 'assets/s2.png',
    'page': () => Emci(fullName: widget.fullName),
  },
  {
    'name': 'CONSTITUTION OF INDIA PYQs',
    'description': 'Previous Year Questions for Constitution of India...',
    'image': 'assets/s2.png',
    'page': () => Coi(fullName: widget.fullName),
  },
  {
    'name': 'ENERGY & ENVIRONMENTAL AUDIT PYQs',
    'description': 'Previous Year Questions for Energy & Environmental Audit...',
    'image': 'assets/s2.png',
    'page': () => Eea(fullName: widget.fullName),
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