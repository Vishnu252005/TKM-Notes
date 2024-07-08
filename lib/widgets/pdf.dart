





// // used for demo of pdf working testing




// import 'package:flutter/material.dart';
// import 'package:flutter_application_2/widgets/pdfviewer.dart'; // Import the PDF viewer

// class NotesPage extends StatelessWidget {
//   final List<NoteItem> notes = [
//     NoteItem(title: 'Lect 1: Data Networks', pdfUrl: 'https://drive.google.com/file/d/1xHrnfrC1LasqPNnzz69I_u8Z5_858OpV/view?usp=sharing'),
//     NoteItem(title: 'Lect 2: Types of networks', pdfUrl: 'url_to_pdf_2'),
//     NoteItem(title: 'Lect 3: Network Models', pdfUrl: 'url_to_pdf_3'),
//     NoteItem(title: 'Lect 4: Transmission Medium', pdfUrl: 'url_to_pdf_4'),
//     NoteItem(title: 'Lect 5: Network Devices', pdfUrl: 'url_to_pdf_5'),
//     NoteItem(title: 'Lect 6: Layering Schemes', pdfUrl: 'url_to_pdf_6'),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 3, 13, 148),
//       appBar: AppBar(
//         title: Text('Notes', style: TextStyle(color: Colors.white)),
//         backgroundColor: Color.fromARGB(255, 3, 13, 148),
//         centerTitle: true,
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               'Files',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.black,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(30),
//                   topRight: Radius.circular(30),
//                 ),
//               ),
//               child: ListView.builder(
//                 padding: EdgeInsets.all(16),
//                 itemCount: notes.length,
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => PDFViewerPage(
//                             pdfUrl: notes[index].pdfUrl,
//                             title: notes[index].title,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Card(
//                       color: Colors.grey[900],
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       margin: EdgeInsets.symmetric(vertical: 8),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Icon(Icons.picture_as_pdf, size: 50, color: Colors.red),
//                                 SizedBox(width: 16),
//                                 Expanded(
//                                   child: Text(
//                                     notes[index].title,
//                                     style: TextStyle(color: Colors.white, fontSize: 16),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 8),
//                             Text(
//                               'TKM COLLEGE',
//                               style: TextStyle(color: Colors.grey, fontSize: 12),
//                             ),
//                             Text(
//                               'THIRD YEAR OF COMPUTER ENGINEERING (2019 COURSE)',
//                               style: TextStyle(color: Colors.grey, fontSize: 12),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class NoteItem {
//   final String title;
//   final String pdfUrl;

//   NoteItem({required this.title, required this.pdfUrl});
// }
