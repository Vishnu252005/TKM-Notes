import 'package:flutter/material.dart';
import 'package:Nexia/widgets/profile.dart';
import 'package:Nexia/widgets/pdfviewer.dart';

class Dsp extends StatelessWidget {
  final String fullName; // Full name received as a parameter
  final List<UnitItem> units = [
    UnitItem(
      title: 'MODULE I: Introduction to DSP and Fourier Transform',
      isAvailable: false,
      pdfUrl: 'url_to_pdf_1',
    ),
    UnitItem(
      title: 'MODULE II: Fast Fourier Transform',
      isAvailable: false,
      pdfUrl: 'url_to_pdf_2',
    ),
    UnitItem(
      title:
          'MODULE III: Infinite Impulse Response Filters',
      isAvailable: false,
      pdfUrl: 'url_to_pdf_3',
    ),
    UnitItem(
      title: 'MODULE IV: Finite Impulse Response Filters',
      isAvailable: false,
      pdfUrl: 'url_to_pdf_4',
    ),
    UnitItem(
      title: 'MODULE V: Digital Signal Processors',
      isAvailable: false,
      pdfUrl: 'url_to_pdf_5',
    ),
  ];

  Dsp({required this.fullName}); // Constructor accepting fullName

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 13, 148),
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0, // No shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back when pressed
          },
        ),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(28.0, 0, 28.0, 16.0),
                child: TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 500),
                  tween: Tween<double>(begin: -100, end: 0),
                  builder: (BuildContext context, double value, Widget? child) {
                    return Transform.translate(
                      offset: Offset(value, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Digital Signal Processing',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            'Select Chapter',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white70),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: ListView(
                      children: [
                        _buildListItem(context, 'Textbooks', false, null),
                        ...units
                            .map((unit) => _buildListItem(context, unit.title,
                                unit.isAvailable, unit.pdfUrl))
                            .toList(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 1,
            right: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      fullName: fullName,
                      branch: 'Computer Science', // vishnumeta branch
                      year: 'Third Year', // vishnumeta year
                      semester: 'Fifth Semester', // vishnumeta semester
                    ), // Redirects to ProfilePage
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.red[600],
                  child: Text(
                    fullName[0].toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24), // Increase font size here
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(
      BuildContext context, String title, bool isAvailable, String? pdfUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white),
        onTap: () {
          if (isAvailable && pdfUrl != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PDFViewerPage(pdfUrl: pdfUrl, title: title),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('This unit is not available.'),
              ),
            );
          }
        },
        subtitle: !isAvailable
            ? const Text(
                'Not Available',
                style: TextStyle(color: Colors.red),
              )
            : null,
      ),
    );
  }
}

class UnitItem {
  final String title;
  final bool isAvailable;
  final String pdfUrl;

  UnitItem(
      {required this.title, required this.isAvailable, required this.pdfUrl});
}
