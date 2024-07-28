import 'package:flutter/material.dart';
import 'package:flutter_application_2/CHEMICAL/sem3/CPE/cpe.dart';
import 'package:flutter_application_2/CHEMICAL/sem3/MEBC/mebc.dart';
import 'package:flutter_application_2/CHEMICAL/sem3/OCI/oci.dart';
import 'package:flutter_application_2/CHEMICAL/sem3/PBCA/pbca.dart';
import 'package:flutter_application_2/CHEMICAL/sem3/PS/ps.dart';
import 'package:flutter_application_2/CHEMICAL/sem3/units.dart'; // Import the correct file for units
import 'package:flutter_application_2/CIVIL/sem3/LSPE/lspe.dart';
import 'package:flutter_application_2/widgets/profile.dart'; // Import the profile.dart file

class CHEMICALSem3Screen extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  const CHEMICALSem3Screen({
    Key? key,
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  }) : super(key: key);

  @override
  _CHEMICALSem3ScreenState createState() => _CHEMICALSem3ScreenState();
}

class _CHEMICALSem3ScreenState extends State<CHEMICALSem3Screen> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Notes & Books', 'PYQs'];

  late Map<String, List<Map<String, dynamic>>> _subjects;

  @override
  void initState() {
    super.initState();

    _subjects = {
      'Notes & Books': [
        {
          'name': 'Probability Distributions and Complex Analysis',
          'description':
              'Overview of probability distributions and complex analysis...',
          'image': 'assets/s1.png',
          'page': () => Pbca(fullName: widget.fullName),
        },
        {
          'name': 'Overview of Chemical Industries',
          'description':
              'Sustainable development and pollution control in chemical industries...',
          'image': 'assets/s1.png',
          'page': () => Oci(fullName: widget.fullName),
        },
        {
          'name': 'Chemistry for Process Engineers',
          'description':
              'Fundamental chemistry concepts relevant to process engineering...',
          'image': 'assets/s1.png',
          'page': () => Cpe(fullName: widget.fullName),
        },
        {
          'name': 'Material & Energy Balance Computations',
          'description':
              'Techniques for performing material and energy balance calculations...',
          'image': 'assets/s1.png',
          'page': () => Mebc(fullName: widget.fullName),
        },
        {
          'name': 'Life Skills and Professional Ethics',
          'description':
              'Development of life skills and understanding professional ethics...',
          'image': 'assets/s1.png',
          'page': () => lspe(fullName: widget.fullName),
        },
        {
          'name': 'Process Safety',
          'description':
              'Principles and practices of ensuring safety in process industries...',
          'image': 'assets/s1.png',
          'page': () => Ps(fullName: widget.fullName),
        },
      ],
      'PYQs': [
        {
          'name': 'Probability Distributions and Complex Analysis PYQs',
          'description':
              'Previous Year Questions for Probability Distributions and Complex Analysis...',
          'image': 'assets/s2.png',
          'page': () => Pbca(fullName: widget.fullName),
        },
        {
          'name': 'Overview of Chemical Industries PYQs',
          'description':
              'Previous Year Questions for Overview of Chemical Industries...',
          'image': 'assets/s2.png',
          'page': () => Oci(fullName: widget.fullName),
        },
        {
          'name': 'Chemistry for Process Engineers PYQs',
          'description':
              'Previous Year Questions for Chemistry for Process Engineers...',
          'image': 'assets/s2.png',
          'page': () => Cpe(fullName: widget.fullName),
        },
        {
          'name': 'Material & Energy Balance Computations PYQs',
          'description':
              'Previous Year Questions for Material & Energy Balance Computations...',
          'image': 'assets/s2.png',
          'page': () => Mebc(fullName: widget.fullName),
        },
        {
          'name': 'Life Skills and Professional Ethics PYQs',
          'description':
              'Previous Year Questions for Life Skills and Professional Ethics...',
          'image': 'assets/s2.png',
          'page': () => lspe(fullName: widget.fullName),
        },
        {
          'name': 'Process Safety PYQs',
          'description': 'Previous Year Questions for Process Safety...',
          'image': 'assets/s2.png',
          'page': () => Ps(fullName: widget.fullName),
        },
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 33, 348),
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
                        style: TextStyle(fontSize: 36, color: Colors.white70),
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
            const SizedBox(height: 36),
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
                          horizontal: 36.0, vertical: 22),
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
                                      const EdgeInsets.symmetric(vertical: 32),
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
                    const SizedBox(height: 3),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 36),
                        itemCount: _subjects[_tabs[_selectedIndex]]!.length,
                        itemBuilder: (context, index) {
                          var subject =
                              _subjects[_tabs[_selectedIndex]]![index];
                          return Card(
                            color: const Color.fromARGB(255, 58, 58, 58),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32)),
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
