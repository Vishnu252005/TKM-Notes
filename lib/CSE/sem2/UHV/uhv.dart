import 'package:flutter/material.dart';
import 'package:flutter_application_2/widgets/profile.dart';
import 'package:flutter_application_2/widgets/pdfviewer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Uhv extends StatefulWidget {
  final String fullName;
  final String branch; // Add branch information
  final String year; // Add year information
  final String semester; // Add semester information

  Uhv({
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  });

  @override
  _UhvState createState() => _UhvState();
}

class _UhvState extends State<Uhv> {
  bool _isDarkMode = true;

  final List<UnitItem> units = [
    UnitItem(
      title: 'MODULE I: Introduction to Value Education',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?export=download&id=1KxmDDyYEi4aR-FCh50FuyuLVFuryew0F',
    ),
    UnitItem(
      title: 'MODULE II: Harmony in the Human Being',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?export=download&id=1_4hiEhdWrJrDPJHGlMl42J2uL9RA95NO',
    ),
    UnitItem(
      title: 'MODULE III: Harmony in the Family and Society',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?export=download&id=1c9SWhMVB5Oe0Xs1w85khkumZbkklVT_2',
    ),
    UnitItem(
      title: 'MODULE IV: Harmony in the Nature/Existence',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?export=download&id=1drnFkkEzQAjQKBhDZ96oB0UEB3PLyC02',
    ),
    UnitItem(
      title: 'MODULE V: Implications of the Holistic Understanding – a Look at Professional Ethics',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?export=download&id=1ok4F1xf0D9xb5kusTLK0X6VfJW4sd3oC',
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
    final Color backgroundColor = _isDarkMode ? const Color(0xFF4C4DDC) : Colors.blue[50]!;
    final Color appBarIconColor = _isDarkMode ? Colors.white : Colors.blue[900]!;
    final Color listTileColor = _isDarkMode ? Colors.grey[900]! : Colors.white;
    final Color titleColor = _isDarkMode ? Colors.white : Colors.blue[900]!;
    final Color subtitleColor = _isDarkMode ? Colors.white70 : Colors.blue[700]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appBarIconColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: appBarIconColor,
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
                            'Universal Human Values-II',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: titleColor,
                            ),
                          ),
                          Text(
                            'Select Chapter',
                            style: TextStyle(
                              fontSize: 18,
                              color: subtitleColor,
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
                  backgroundColor: _isDarkMode ? Colors.blue[700] : Colors.blue[300],
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
        color: _isDarkMode ? Colors.grey[900]! : Colors.white,
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

  UnitItem({required this.title, required this.isAvailable, required this.pdfUrl});
}
