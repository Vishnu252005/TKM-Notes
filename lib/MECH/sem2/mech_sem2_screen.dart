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
          'page': () => maths(
            fullName: widget.fullName,
            branch: widget.branch,
            year: widget.year,
            semester: widget.semester,
          ),
        },
        {
          'name': 'Engineering Physics',
          'description': 'Exploration of fundamental concepts in physics...',
          'image': 'assets/s1.png',
          'page': () => physics(
            fullName: widget.fullName,
            branch: widget.branch,
            year: widget.year,
            semester: widget.semester,
          ),
        },
        {
          'name': 'Problem Solving and Programming',
          'description': 'Basics of programming and problem-solving techniques...',
          'image': 'assets/s1.png',
          'page': () => Psp(
            fullName: widget.fullName,
            branch: widget.branch,
            year: widget.year,
            semester: widget.semester,
          ),
        },
        {
          'name': 'Technical English for Engineers',
          'description': 'Improving technical English communication skills...',
          'image': 'assets/s1.png',
          'page': () => english(
            fullName: widget.fullName,
            branch: widget.branch,
            year: widget.year,
            semester: widget.semester,
          ),
        },
        {
          'name': 'IDEA Lab Workshop',
          'description': 'Hands-on workshop for innovation and design...',
          'image': 'assets/s1.png',
          'page': () => idea(
            fullName: widget.fullName,
            branch: widget.branch,
            year: widget.year,
            semester: widget.semester,
          ),
        },
        {
          'name': 'Universal Human Values-II',
          'description': 'Exploration of universal human values...',
          'image': 'assets/s1.png',
          'page': () => Uhv(
            fullName: widget.fullName,
            branch: widget.branch,
            year: widget.year,
            semester: widget.semester,
          ),
        },
      ],
      'PYQs': [
        {
          'name': 'Differential Equations and Transforms PYQs',
          'description': 'Previous Year Questions for Differential Equations and Transforms...',
          'image': 'assets/s2.png',
          'page': () => maths1(
            fullName: widget.fullName,
            branch: widget.branch,
            year: widget.year,
            semester: widget.semester,
          ),
        },
        {
          'name': 'Engineering Physics PYQs',
          'description': 'Previous Year Questions for Engineering Physics...',
          'image': 'assets/s2.png',
          'page': () => physics1(
            fullName: widget.fullName,
            branch: widget.branch,
            year: widget.year,
            semester: widget.semester,
          ),
        },
        {
          'name': 'Problem Solving and Programming PYQs',
          'description': 'Previous Year Questions for Problem Solving and Programming...',
          'image': 'assets/s2.png',
          'page': () => Psp1(
            fullName: widget.fullName,
            branch: widget.branch,
            year: widget.year,
            semester: widget.semester,
          ),
        },
        {
          'name': 'Technical English for Engineers PYQs',
          'description': 'Previous Year Questions for Technical English for Engineers...',
          'image': 'assets/s2.png',
          'page': () => english1(
            fullName: widget.fullName,
            branch: widget.branch,
            year: widget.year,
            semester: widget.semester,
          ),
        },
        {
          'name': 'IDEA Lab Workshop PYQs',
          'description': 'Previous Year Questions for IDEA Lab Workshop...',
          'image': 'assets/s2.png',
          'page': () => idea1(
            fullName: widget.fullName,
            branch: widget.branch,
            year: widget.year,
            semester: widget.semester,
          ),
        },
        {
          'name': 'Universal Human Values-II PYQs',
          'description': 'Previous Year Questions for Universal Human Values-II...',
          'image': 'assets/s2.png',
          'page': () => Uhv1(
            fullName: widget.fullName,
            branch: widget.branch,
            year: widget.year,
            semester: widget.semester,
          ),
        },
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isPortrait = screenSize.height > screenSize.width;
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final cardColor = isDarkMode ? Color.fromARGB(255, 58, 58, 58) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.black87;

    return Scaffold(
      backgroundColor: backgroundColor,
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
                              color: textColor),
                        ),
                        Text(
                          'Select Subject',
                          style: TextStyle(fontSize: 16, color: subtitleColor),
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
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[900] : Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 70,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _tabs.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 24.0),
                              child: Text(
                                _tabs[index],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _selectedIndex == index
                                      ? Colors.red[600]
                                      : subtitleColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.all(isPortrait ? 16.0 : 8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isPortrait ? 2 : 3,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                        ),
                        itemCount: _subjects[_tabs[_selectedIndex]]!.length,
                        itemBuilder: (context, index) {
                          final subject = _subjects[_tabs[_selectedIndex]]![index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => subject['page'](),
                                ),
                              );
                            },
                            child: Card(
                              color: cardColor,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Image.asset(subject['image']),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      subject['name'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      subject['description'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: subtitleColor,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
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
