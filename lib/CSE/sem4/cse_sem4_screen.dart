import 'package:flutter/material.dart';
import 'package:flutter_application_2/CSE/sem4/BE/be.dart';
import 'package:flutter_application_2/CSE/sem4/CN/cn.dart';
import 'package:flutter_application_2/CSE/sem4/DM/dm.dart';
import 'package:flutter_application_2/CSE/sem4/IDS/ids.dart';
import 'package:flutter_application_2/CSE/sem4/OB/ob.dart';
import 'package:flutter_application_2/CSE/sem4/OS/os.dart';
import 'package:flutter_application_2/CSE/sem4/units.dart'; // Import the correct file for units
import 'package:flutter_application_2/EEE/sem4/ES/es.dart';
import 'package:flutter_application_2/widgets/profile.dart'; // Import the profile.dart file

class CSESem4Screen extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const CSESem4Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _CSESem4ScreenState createState() => _CSESem4ScreenState();
}

class _CSESem4ScreenState extends State<CSESem4Screen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Notes & Books', 'PYQs'];

  late Map<String, List<Map<String, dynamic>>> _subjects;

  @override
  void initState() {
    super.initState();

    _subjects = {
      'Notes & Books': [
        {
          'name': 'Discrete Mathematics',
          'description':
              'Discrete mathematics is the study of mathematical structures...',
          'image': 'assets/discrete_mathematics.png',
          'page': () => DM(fullName: widget.fullName),
        },
        {
          'name': 'Computer Networks',
          'description':
              'Computer Networks is the study of interconnected computing devices...',
          'image': 'assets/computer_networks.png',
          'page': () => Cn(fullName: widget.fullName),
        },
        {
          'name': 'Operating Systems',
          'description':
              'Operating Systems manage the hardware and software resources...',
          'image': 'assets/operating_systems.png',
          'page': () => Os(fullName: widget.fullName),
        },
        {
          'name': 'Introduction to Database Systems',
          'description':
              'This subject covers the basics of database design and use...',
          'image': 'assets/database_systems.png',
          'page': () => Ids(fullName: widget.fullName),
        },
        {
          'name': 'Organizational Behaviour',
          'description':
              'Organizational Behaviour is the study of how people interact within groups...',
          'image': 'assets/organizational_behaviour.png',
          'page': () => Ob(fullName: widget.fullName),
        },
        {
          'name': 'Environmental Science',
          'description':
              'Environmental Science is the study of the environment and solutions to environmental problems...',
          'image': 'assets/environmental_science.png',
          'page': () => Es(fullName: widget.fullName),
        },
        {
          'name': 'Biology for Engineers',
          'description':
              'Biology for Engineers integrates biology with engineering principles...',
          'image': 'assets/biology_for_engineers.png',
          'page': () => Be(fullName: widget.fullName),
        },
      ],
      'PYQs': [
        {
          'name': 'Discrete Mathematics PYQs',
          'description': 'Previous Year Questions for Discrete Mathematics...',
          'image': 'assets/discrete_mathematics.png',
          'page': () => DM(fullName: widget.fullName),
        },
        {
          'name': 'Computer Networks PYQs',
          'description': 'Previous Year Questions for Computer Networks...',
          'image': 'assets/computer_networks.png',
          'page': () => Cn(fullName: widget.fullName),
        },
        {
          'name': 'Operating Systems PYQs',
          'description': 'Previous Year Questions for Operating Systems...',
          'image': 'assets/operating_systems.png',
          'page': () => Os(fullName: widget.fullName),
        },
        {
          'name': 'Introduction to Database Systems PYQs',
          'description':
              'Previous Year Questions for Introduction to Database Systems...',
          'image': 'assets/database_systems.png',
          'page': () => Ids(fullName: widget.fullName),
        },
        {
          'name': 'Organizational Behaviour PYQs',
          'description':
              'Previous Year Questions for Organizational Behaviour...',
          'image': 'assets/organizational_behaviour.png',
          'page': () => Ob(fullName: widget.fullName),
        },
        {
          'name': 'Environmental Science PYQs',
          'description': 'Previous Year Questions for Environmental Science...',
          'image': 'assets/environmental_science.png',
          'page': () => Es(fullName: widget.fullName),
        },
        {
          'name': 'Biology for Engineers PYQs',
          'description': 'Previous Year Questions for Biology for Engineers...',
          'image': 'assets/biology_for_engineers.png',
          'page': () => Be(fullName: widget.fullName),
        },
      ],
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
