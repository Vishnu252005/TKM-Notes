import 'package:flutter/material.dart';
import 'package:flutter_application_2/CIVIL/sem4/CT/ct.dart';
import 'package:flutter_application_2/CIVIL/sem4/DMRI/dmri.dart';
import 'package:flutter_application_2/CIVIL/sem4/ES/es.dart';
import 'package:flutter_application_2/CIVIL/sem4/FM/fm.dart';
import 'package:flutter_application_2/CIVIL/sem4/SA/sa.dart';
import 'package:flutter_application_2/CIVIL/sem4/SM/sm.dart';
import 'package:flutter_application_2/CIVIL/sem4/TE/te.dart';
import 'package:flutter_application_2/CIVIL/sem4/units.dart'; // Import the correct file for units
import 'package:flutter_application_2/EEE/sem3/CT/ct.dart';
import 'package:flutter_application_2/widgets/profile.dart'; // Import the profile.dart file

class CIVILSem4Screen extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const CIVILSem4Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _CIVILSem4ScreenState createState() => _CIVILSem4ScreenState();
}

class _CIVILSem4ScreenState extends State<CIVILSem4Screen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Notes & Books', 'PYQs'];

  late Map<String, List<Map<String, dynamic>>> _subjects;

  @override
  void initState() {
    super.initState();

    _subjects = {
      "Notes & Books": [
        {
          "name": "Structural Analysis",
          "description": "Study of calculus and linear algebra including...",
          "image": "assets/s4.png",
          "page": () => sa(fullName: widget.fullName),
        },
        {
          "name": "Soil Mechanics",
          "description": "Exploration of fundamental concepts in chemistry...",
          "image": "assets/s4.png",
          "page": () => Sm(fullName: widget.fullName),
        },
        {
          "name": "Fluid Mechanics",
          "description": "Introduction to engineering mechanics principles...",
          "image": "assets/s4.png",
          "page": () => Fm(fullName: widget.fullName),
        },
        {
          "name": "Transportation Engineering",
          "description": "Fundamentals of engineering drawing and graphics...",
          "image": "assets/s4.png",
          "page": () => Te(fullName: widget.fullName),
        },
        {
          "name": "Disaster Management and Resilient Infrastructure",
          "description": "Introduction to various manufacturing processes...",
          "image": "assets/s4.png",
          "page": () => Dmri(fullName: widget.fullName),
        },
        {
          "name": "Environmental Sciences",
          "description":
              "Physical education and well-being through sports and yoga...",
          "image": "assets/s4.png",
          "page": () => Es(fullName: widget.fullName),
        },
        {
          "name": "Construction Technology",
          "description":
              "Basic concepts in electrical and electronics engineering...",
          "image": "assets/s4.png",
          "page": () => Ct(fullName: widget.fullName),
        }
      ],
      "PYQs": [
        {
          "name": "Structural Analysis PYQs",
          "description": "Previous Year Questions for Structural Analysis...",
          "image": "assets/s2.png",
          "page": () => sa(fullName: widget.fullName),
        },
        {
          "name": "Soil Mechanics PYQs",
          "description": "Previous Year Questions for Soil Mechanics...",
          "image": "assets/s2.png",
          "page": () => Sm(fullName: widget.fullName),
        },
        {
          "name": "Fluid Mechanics PYQs",
          "description": "Previous Year Questions for Fluid Mechanics...",
          "image": "assets/s2.png",
          "page": () => Fm(fullName: widget.fullName),
        },
        {
          "name": "Transportation Engineering PYQs",
          "description":
              "Previous Year Questions for Transportation Engineering...",
          "image": "assets/s2.png",
          "page": () => Te(fullName: widget.fullName),
        },
        {
          "name": "Disaster Management and Resilient Infrastructure PYQs",
          "description":
              "Previous Year Questions for Disaster Management and Resilient Infrastructure...",
          "image": "assets/s2.png",
          "page": () => Dmri(fullName: widget.fullName),
        },
        {
          "name": "Environmental Sciences PYQs",
          "description":
              "Previous Year Questions for Environmental Sciences...",
          "image": "assets/s2.png",
          "page": () => Es(fullName: widget.fullName),
        },
        {
          "name": "Construction Technology PYQs",
          "description":
              "Previous Year Questions for Construction Technology...",
          "image": "assets/s2.png",
          "page": () => ct(fullName: widget.fullName),
        }
      ]
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 43, 448),
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
                        style: TextStyle(fontSize: 46, color: Colors.white70),
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
            const SizedBox(height: 46),
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
                          horizontal: 46.0, vertical: 22),
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
                                      const EdgeInsets.symmetric(vertical: 42),
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
                    const SizedBox(height: 4),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 46),
                        itemCount: _subjects[_tabs[_selectedIndex]]!.length,
                        itemBuilder: (context, index) {
                          var subject =
                              _subjects[_tabs[_selectedIndex]]![index];
                          return Card(
                            color: const Color.fromARGB(255, 58, 58, 58),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(42)),
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
