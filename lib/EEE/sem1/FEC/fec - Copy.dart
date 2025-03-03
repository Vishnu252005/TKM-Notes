import 'package:flutter/material.dart';
import 'package:Nexia/widgets/profile.dart';
import 'package:Nexia/widgets/pdfviewer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class fec1 extends StatefulWidget { // Capitalized class name
  final String fullName;
  final String branch;
  final String year;
  final String semester;
  final String subjectName;

  fec1({
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
    required this.subjectName,
  });

  @override
  _fec1State createState() => _fec1State();
}

class _fec1State extends State<fec1> {
  bool _isDarkMode = true;

  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;

  final List<UnitItem> units = [
    UnitItem(
      title: 'MODULE I: Electronic Components & Devices',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?export=download&id=1Xgr0YAMbPfAB0mRc6-DlFtxlAMLdBsfm',
    ),
    UnitItem(
      title: 'MODULE II: Electronic Circuits',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?export=download&id=1ai44hKJIcbdpyZ2EUTUJR2QPuBJBwgA3',
    ),
    UnitItem(
      title: 'MODULE III: Integrated Circuits',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?export=download&id=14vnK7RRcSMYST4GmYWF1VAWf9iXIc8hS',
    ),
    UnitItem(
      title: 'MODULE IV: Electronic Instrumentation',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?export=download&id=1DJdH-mpT8K9BKETyXxF6nB4f1sVUzCmB',
    ),
    UnitItem(
      title: 'MODULE V: Communication Systems',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?export=download&id=1r1NdveyCEm_iFdBgzEGX4CmTZ4kXwLUq',
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
      backgroundColor: _isDarkMode ? Color(0xFF1A1A2E) : Color(0xFFF8FAFF),
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: DotPatternPainter(
                color: _isDarkMode 
                    ? Colors.white.withOpacity(0.03)
                    : Colors.blue.withOpacity(0.05),
              ),
            ),
          ),

          Column(
            children: [
              // Enhanced Glass Effect Header
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 20,
                      bottom: 20,
                      left: 20,
                      right: 20,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isDarkMode 
                            ? [
                                Color(0xFF4C4DDC),
                                Color(0xFF1A1A2E),
                              ]
                            : [
                                Color(0xFF0A84FF),  // iOS-style blue
                                Color(0xFF48A2FF),  // Lighter vibrant blue
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.science,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'PHYSICS',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                IconButton(
                  icon: Icon(
                    _isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                    color: Colors.white,
                  ),
                  onPressed: _toggleTheme,
                ),
              ],
                        ),
                        SizedBox(height: 20),
                              Text(
                          widget.subjectName,
                                style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                                  fontWeight: FontWeight.bold,
                            height: 1.2,
                            shadows: [
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 5,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ],
                          ),
                        ),
                          ],
                        ),
                      ),
                    ),
                  ),

              // Units List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: units.length + 1, // +1 for textbooks
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildListItem(context, 'Textbooks', false, null)
                          .animate()
                          .fadeIn(duration: Duration(milliseconds: 500))
                          .slideX(begin: -0.2, end: 0);
                    }
                    final unit = units[index - 1];
                    return _buildListItem(context, unit.title, unit.isAvailable, unit.pdfUrl)
                        .animate()
                        .fadeIn(duration: Duration(milliseconds: 500))
                        .slideX(begin: -0.2, end: 0, delay: Duration(milliseconds: index * 100));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, String title, bool isAvailable, String? pdfUrl) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _isDarkMode 
            ? Color(0xFF252542) 
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isAvailable 
              ? (_isDarkMode 
                  ? Color(0xFF4C4DDC).withOpacity(0.2)
                  : Color(0xFF0A84FF).withOpacity(0.1))
              : (_isDarkMode 
                  ? Colors.red.withOpacity(0.2)
                  : Colors.red.withOpacity(0.1)),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isAvailable
                ? (_isDarkMode 
                    ? Colors.black.withOpacity(0.3)
                    : Color(0xFF0A84FF).withOpacity(0.08))
                : Colors.red.withOpacity(0.08),
            offset: Offset(4, 6),
            blurRadius: 20,
            spreadRadius: -2,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        title: Text(
          title,
          style: TextStyle(
            color: _isDarkMode 
                ? Colors.white 
                : Color(0xFF2C3E50),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.3,
            letterSpacing: 0.2,
          ),
        ),
        subtitle: !isAvailable ? Text(
          'Not Available',
          style: TextStyle(
            color: Colors.red[400],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ) : null,
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isAvailable
                ? (_isDarkMode 
                    ? Color(0xFF4C4DDC) 
                    : Color(0xFF0A84FF)).withOpacity(0.1)
                : (_isDarkMode 
                    ? Colors.red 
                    : Colors.red[400])!.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isAvailable ? Icons.book_outlined : Icons.lock_outline,
            color: isAvailable
                ? (_isDarkMode 
                    ? Color(0xFF4C4DDC)
                    : Color(0xFF0A84FF))
                : Colors.red[400],
            size: 24,
          ),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: isAvailable
                ? (_isDarkMode 
                    ? Color(0xFF4C4DDC) 
                    : Color(0xFF0A84FF)).withOpacity(0.1)
                : (_isDarkMode 
                    ? Colors.red 
                    : Colors.red[400])!.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(8),
          child: Icon(
            isAvailable ? Icons.arrow_forward_ios : Icons.lock,
            color: isAvailable
                ? (_isDarkMode 
                    ? Color(0xFF4C4DDC)
                    : Color(0xFF0A84FF))
                : Colors.red[400],
            size: 16,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onTap: () {
          if (isAvailable && pdfUrl != null) {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PDFViewerPage(pdfUrl: pdfUrl, title: title),
              ),
            );
          } else {
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.lock, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'This content is not available yet',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.red[400],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.all(16),
                elevation: 4,
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
      ),
    ).animate()
      .fadeIn(duration: Duration(milliseconds: 500))
      .slideX(begin: -0.2, end: 0)
      .scale(begin: Offset(0.95, 0.95), end: Offset(1, 1));
  }
}

class UnitItem {
  final String title;
  final bool isAvailable;
  final String pdfUrl;

  UnitItem({required this.title, required this.isAvailable, required this.pdfUrl});
}

class DotPatternPainter extends CustomPainter {
  final Color color;
  
  DotPatternPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final double spacing = 20;
    final double radius = 1;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
