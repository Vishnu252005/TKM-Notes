import 'package:flutter/material.dart';
import 'package:flutter_application_2/widgets/profile.dart';
import 'package:flutter_application_2/widgets/pdfviewer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class fec extends StatefulWidget { // Capitalized class name
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  fec({required this.fullName, required this.branch, required this.year, required this.semester});

  @override
  _fecState createState() => _fecState();
}

class _fecState extends State<fec> {
  bool _isDarkMode = true;

  final List<UnitItem> units = [
    UnitItem(
      title: 'MODULE I: Electronic Components & Devices',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?export=download&id=1BAYUDzCaYSgZcEAaWHutyANcD0P0rUK-',
    ),
    UnitItem(
      title: 'MODULE II: Electronic Circuits',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?export=download&id=1BSfew3z7Xiir6tneBPDy0se1Ee045_6O',
    ),
    UnitItem(
      title: 'MODULE III: Integrated Circuits',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?export=download&id=1BSU0XwbyzYCJFIeZmwEnPwV_9Cjpdory',
    ),
    UnitItem(
      title: 'MODULE IV: Electronic Instrumentation',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?export=download&id=1BS45MBMXvsVZTlOLwmmuJ8_ESO6LD3w4',
    ),
    UnitItem(
      title: 'MODULE V: Communication Systems',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?export=download&id=1BOskampAzE7ggEnrn94lYidVvSSMxGed',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    });
  }

  Future<void> _toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = !_isDarkMode;
      prefs.setBool('isDarkMode', _isDarkMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.blue[900] : Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: _isDarkMode ? Colors.white : Colors.blue[900], // Updated color
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: Colors.white,
            ),
            onPressed: _toggleTheme,
          ),
        ],
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
                        children: [
                          Text(
                            'Fundamentals of Electronics Engineering',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _isDarkMode ? Colors.white : Colors.blue[900],
                            ),
                          ),
                          Text(
                            'Select Chapter',
                            style: TextStyle(
                              fontSize: 18,
                              color: _isDarkMode ? Colors.white70 : Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: _isDarkMode ? Colors.black : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: !_isDarkMode
                        ? [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: ListView(
                      children: [
                        _buildListItem(context, 'Textbooks', false, null),
                        ...units.map((unit) => _buildListItem(context, unit.title, unit.isAvailable, unit.pdfUrl)).toList(),
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
                      fullName: widget.fullName,
                      branch: widget.branch,
                      year: widget.year,
                      semester: widget.semester,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor:  Colors.blue[700],
                  child: Text(
                    widget.fullName[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, String title, bool isAvailable, String? pdfUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: !_isDarkMode
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: _isDarkMode ? Colors.white : Colors.blue[900]),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white),
        onTap: () {
          if (isAvailable && pdfUrl != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PDFViewerPage(pdfUrl: pdfUrl, title: title),
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

  UnitItem({required this.title, required this.isAvailable, required this.pdfUrl});
}