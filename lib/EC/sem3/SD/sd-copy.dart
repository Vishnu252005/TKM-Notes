import 'package:flutter/material.dart';
import 'package:Nexia/widgets/profile.dart';
import 'package:Nexia/widgets/pdfviewer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sd1 extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  Sd1({
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  });

  @override
  _SdState createState() => _SdState();
}

class _SdState extends State<Sd1> {
  bool _isDarkMode = true;

  final List<UnitItem> units = [
    UnitItem(
      title: 'MODULE I: Basic Semiconductor Theory',
      isAvailable: false,
      pdfUrl: 'url_to_pdf_1',
    ),
    UnitItem(
      title: 'MODULE II: Carrier Transport in Semiconductors',
      isAvailable: false,
      pdfUrl: 'url_to_pdf_2',
    ),
    UnitItem(
      title: 'MODULE III: PN Junctions',
      isAvailable: false,
      pdfUrl: 'url_to_pdf_3',
    ),
    UnitItem(
      title: 'MODULE IV: MOS Structure',
      isAvailable: false,
      pdfUrl: 'url_to_pdf_4',
    ),
    UnitItem(
      title: 'MODULE V: MOSFET Scaling',
      isAvailable: false,
      pdfUrl: 'url_to_pdf_5',
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
      backgroundColor: _isDarkMode ? const Color.fromARGB(255, 3, 13, 148) : Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _isDarkMode ? Colors.white : Colors.blue[900]),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: _isDarkMode ? Colors.white : Colors.blue[900],
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
                            'Semiconductor Devices',
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
                  backgroundColor: _isDarkMode ? Colors.blue : Colors.blue,
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
        trailing: Icon(Icons.chevron_right, color: _isDarkMode ? Colors.white : Colors.blue[900]),
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

  UnitItem({
    required this.title,
    required this.isAvailable,
    required this.pdfUrl,
  });
}