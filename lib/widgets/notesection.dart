




// used for demo of notes testing



// import 'package:flutter/material.dart';
// import 'package:Nexia/widgets/units.dart';  // Import the correct file for units
// import 'profile.dart';  // Import the profile.dart file

// class SubjectSelectionScreen extends StatefulWidget {
//   final String fullName;
//   final String branch;
//   final String year;
//   final String semester;

//   const SubjectSelectionScreen({
//     Key? key,
//     required this.fullName,
//     required this.branch,
//     required this.year,
//     required this.semester,
//   }) : super(key: key);

//   @override
//   _SubjectSelectionScreenState createState() => _SubjectSelectionScreenState();
// }

// class _SubjectSelectionScreenState extends State<SubjectSelectionScreen> {
//   int _selectedIndex = 0;
//   final List<String> _tabs = ['Notes & Books', 'PYQs'];

//   late List<Map<String, dynamic>> _notesAndBooks;
//   late List<Map<String, dynamic>> _pyqs;

//   @override
//   void initState() {
//     super.initState();
//     _notesAndBooks = [
//       {
//         'name': 'Data Management System',
//         'description': 'DBMS is a software system used to store, retrieve, and...',
//         'image': 'assets/s1.png',
//         'page': () => ComputerNetworksPage(fullName: widget.fullName),
//       },
//       {
//         'name': 'Design Thinking',
//         'description': 'Design thinking is a process for solving problems by pr...',
//         'image': 'assets/s2.png',
//         'page': () => ComputerNetworksPage(fullName: widget.fullName),
//       },
//     ];

//     _pyqs = [
//       {
//         'name': 'Data Management System PYQs',
//         'description': 'Previous Year Questions for DBMS...',
//         'image': 'assets/s1.png',
//         'page': () => ComputerNetworksPage(fullName: widget.fullName),
//       },
//       {
//         'name': 'Design Thinking PYQs',
//         'description': 'Previous Year Questions for Design Thinking...',
//         'image': 'assets/s2.png',
//         'page': () => ComputerNetworksPage(fullName: widget.fullName),
//       },
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 3, 13, 148),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(25.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Hey ${widget.fullName}',
//                         style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
//                       ),
//                       const Text(
//                         'Select Subject',
//                         style: TextStyle(fontSize: 16, color: Colors.white70),
//                       ),
//                     ],
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ProfilePage(
//                             fullName: widget.fullName,
//                             branch: widget.branch,
//                             year: widget.year,
//                             semester: widget.semester,
//                           ),
//                         ),
//                       );
//                     },
//                     child: CircleAvatar(
//                       backgroundColor: Colors.red[600],
//                       radius: 30,
//                       child: Text(
//                         widget.fullName[0].toUpperCase(),
//                         style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                   color: Colors.black,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(25),
//                     topRight: Radius.circular(25),
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22),
//                       child: Container(
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: const Color.fromARGB(255, 58, 58, 58),
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           children: List.generate(
//                             _tabs.length,
//                             (index) => Expanded(
//                               child: GestureDetector(
//                                 onTap: () => setState(() => _selectedIndex = index),
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(vertical: 12),
//                                   decoration: BoxDecoration(
//                                     color: _selectedIndex == index
//                                         ? Colors.black
//                                         : const Color.fromARGB(255, 58, 58, 58),
//                                     borderRadius: BorderRadius.circular(25),
//                                   ),
//                                   child: Text(
//                                     _tabs[index],
//                                     textAlign: TextAlign.center,
//                                     style: const TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 1),
//                     Expanded(
//                       child: ListView.builder(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         itemCount: _tabs.length,
//                         itemBuilder: (context, index) {
//                           List<Map<String, dynamic>> subjects = index == 0 ? _notesAndBooks : _pyqs;
//                           return Column(
//                             children: subjects.map((subject) {
//                               return Card(
//                                 color: const Color.fromARGB(255, 58, 58, 58),
//                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                                 child: ListTile(
//                                   contentPadding: const EdgeInsets.all(8),
//                                   leading: subject['image'] != null
//                                       ? Image.asset(subject['image'], width: 80, height: 80)
//                                       : null,
//                                   title: Text(subject['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//                                   subtitle: Text(subject['description'], style: const TextStyle(color: Colors.white70)),
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => subject['page'](),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               );
//                             }).toList(),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
