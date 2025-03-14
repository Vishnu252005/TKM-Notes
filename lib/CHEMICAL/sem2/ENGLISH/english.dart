import 'package:flutter/material.dart';
import 'package:Nexia/widgets/profile.dart';
import 'package:Nexia/widgets/pdfviewer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class english extends StatefulWidget { // Capitalized class name
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  english({required this.fullName, required this.branch, required this.year, required this.semester});

  @override
  _englishState createState() => _englishState();
}

class _englishState extends State<english> {
  bool _isDarkMode = true;

  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;

  final List<UnitItem> units = [
    UnitItem(
      title: 'MODULE I: Use of Language in Communication',
      isAvailable: true,
      pdfUrl: 'http://drive.google.com/uc?export=download&id=1wHumE5jVk8XZJOaEC8B7LQzYt5g3udFn',
    ),
    UnitItem(
      title: 'MODULE II: Oral Presentation',
      isAvailable: true,
      pdfUrl: 'http://drive.google.com/uc?export=download&id=1wJVMzrvDAZIWzOvJE0a0LCdgkeUwyJOT',
    ),
    UnitItem(
      title: 'MODULE III: Interview Skills',
      isAvailable: true,
      pdfUrl: 'http://drive.google.com/uc?export=download&id=1wKjk0e44K2fm20cM6x3F8_rHfbEJN2Nq',
    ),
    UnitItem(
      title: 'MODULE IV: Formal Writing',
      isAvailable: true,
      pdfUrl: 'http://drive.google.com/uc?export=download&id=1wKYGUO7wbYWpN7zG6WGxc-nFNeJqNV3C',
    ),
    UnitItem(
      title: 'MODULE V: Reading Comprehension and Listening Skills',
      isAvailable: true,
      pdfUrl: 'http://drive.google.com/uc?export=download&id=1wKlF4f4hvDnUtSTBCTyzu1htdO4eP_0G',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _loadBannerAd();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
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

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-1850470420397635/2911662464', // Replace with your Ad Unit ID
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();
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
                            'english',
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
                              offset: const Offset(0, 3), // changes position of shadow
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
                  backgroundColor:  Colors.blue[700], // Updated color
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
