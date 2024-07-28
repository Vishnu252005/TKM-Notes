import 'package:flutter/material.dart';
import 'package:flutter_application_2/CSE/sem3/LSPE/lspe.dart';
import 'package:flutter_application_2/EEE/sem3/BEM/bem.dart';
import 'package:flutter_application_2/EEE/sem3/CT/ct.dart';
import 'package:flutter_application_2/EEE/sem3/DELD/deld.dart';
import 'package:flutter_application_2/EEE/sem3/FEPS/feps.dart';
import 'package:flutter_application_2/EEE/sem3/MATHS3/maths3.dart';
import 'package:flutter_application_2/EEE/sem3/MI/mi.dart';
import 'package:flutter_application_2/EEE/sem3/units.dart'; // Import the correct file for units
import 'package:flutter_application_2/widgets/profile.dart'; // Import the profile.dart file

class EEESem3Screen extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const EEESem3Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _EEESem3ScreenState createState() => _EEESem3ScreenState();
}

class _EEESem3ScreenState extends State<EEESem3Screen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Notes & Books', 'PYQs'];

  late Map<String, List<Map<String, dynamic>>> _subjects;

  @override
  void initState() {
    super.initState();

    _subjects = {
      'Notes & Books': [
        {
          'name': 'Mathematics III',
          'description': 'Advanced mathematical concepts for engineering...',
          'image': 'assets/s1.png',
          'page': () => maths3(fullName: widget.fullName),
        },
        {
          'name': 'Basic Engineering Mechanics',
          'description': 'Fundamentals of engineering mechanics...',
          'image': 'assets/s1.png',
          'page': () => Bem(fullName: widget.fullName),
        },
        {
          'name': 'Digital Electronics and Logic Design',
          'description': 'Study of digital circuits and logic design...',
          'image': 'assets/s1.png',
          'page': () => Deld(fullName: widget.fullName),
        },
        {
          'name': 'Measurements & Instrumentation',
          'description':
              'Principles and applications of measurements and instrumentation...',
          'image': 'assets/s1.png',
          'page': () => mi(fullName: widget.fullName),
        },
        {
          'name': 'Circuit Theory',
          'description': 'Analysis and understanding of electrical circuits...',
          'image': 'assets/s1.png',
          'page': () => ct(fullName: widget.fullName),
        },
        {
          'name': 'Life Skills and Professional Ethics',
          'description':
              'Development of life skills and understanding professional ethics...',
          'image': 'assets/s1.png',
          'page': () => Lspe(fullName: widget.fullName),
        },
        {
          'name': 'Fundamentals of Electrical Power Systems',
          'description': 'Basic concepts of electrical power systems...',
          'image': 'assets/s1.png',
          'page': () => Feps(fullName: widget.fullName),
        },
      ],
      'PYQs': [
        {
          'name': 'Mathematics III PYQs',
          'description': 'Previous Year Questions for Mathematics III...',
          'image': 'assets/s2.png',
          'page': () => maths3(fullName: widget.fullName),
        },
        {
          'name': 'Basic Engineering Mechanics PYQs',
          'description':
              'Previous Year Questions for Basic Engineering Mechanics...',
          'image': 'assets/s2.png',
          'page': () => Bem(fullName: widget.fullName),
        },
        {
          'name': 'Digital Electronics and Logic Design PYQs',
          'description':
              'Previous Year Questions for Digital Electronics and Logic Design...',
          'image': 'assets/s2.png',
          'page': () => Deld(fullName: widget.fullName),
        },
        {
          'name': 'Measurements & Instrumentation PYQs',
          'description':
              'Previous Year Questions for Measurements & Instrumentation...',
          'image': 'assets/s2.png',
          'page': () => mi(fullName: widget.fullName),
        },
        {
          'name': 'Circuit Theory PYQs',
          'description': 'Previous Year Questions for Circuit Theory...',
          'image': 'assets/s2.png',
          'page': () => ct(fullName: widget.fullName),
        },
        {
          'name': 'Life Skills and Professional Ethics PYQs',
          'description':
              'Previous Year Questions for Life Skills and Professional Ethics...',
          'image': 'assets/s2.png',
          'page': () => Lspe(fullName: widget.fullName),
        },
        {
          'name': 'Fundamentals of Electrical Power Systems PYQs',
          'description':
              'Previous Year Questions for Fundamentals of Electrical Power Systems...',
          'image': 'assets/s2.png',
          'page': () => Feps(fullName: widget.fullName),
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
