import 'package:flutter/material.dart';
import 'package:Nexia/widgets/profile.dart';
import 'package:Nexia/widgets/pdfviewer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:Nexia/widgets/navbar/home_screen.dart';
import 'package:Nexia/widgets/navbar/ai_screen.dart';
import 'package:Nexia/widgets/navbar/tools_screen.dart';
import 'package:Nexia/widgets/navbar/profile_screen.dart';


class Bee extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  Bee({
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  });

  @override
  _BeeState createState() => _BeeState();
}

class _BeeState extends State<Bee> {
  bool _isDarkMode = true;
  int _currentIndex = 0;

  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;

  final List<UnitItem> units = [
    UnitItem(
      title: 'MODULE I: D.C. Circuits and Magnetic Circuits',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?id=1HfowrHTQNAbo-MU8m33FaMLLQb6jLVW1&export=download',
    ),
    UnitItem(
      title: 'MODULE II: Single Phase Systems',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?id=18of05v5k0LTXA4UZb2dV9jjar7OnFEX-&export=download',
    ),
    UnitItem(
      title: 'MODULE III: Three Phase Systems and Power Transmission',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?id=1fOE2zTU78oFMNNwQIMzDNLlO3wOg4NKi&export=download',
    ),
    UnitItem(
      title: 'MODULE IV: DC Machines and Transformers',
      isAvailable: false,
      pdfUrl: 'url_to_pdf_4',
    ),
    UnitItem(
      title: 'MODULE V: AC Machines',
      isAvailable: false,
      pdfUrl: 'url_to_pdf_5',
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
      body: _getBody(),
      bottomNavigationBar: AnimatedContainer(
        duration: Duration(milliseconds: 300), // Animation duration
        decoration: BoxDecoration(
          color: _isDarkMode ? Color(0xFF121212) : Colors.white, // Use a better shade of black
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.5), // Blue shadow effect
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index; // Update the current index
            });
            switch (index) {
              case 0:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                break;
              case 1:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AIScreen()));
                break;
              case 2:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ToolsScreen()));
                break;
              case 3:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: _isDarkMode ? Colors.white : Colors.black), // Change icon color
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.android, color: _isDarkMode ? Colors.white : Colors.black), // Change icon color
              label: 'AI',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.build, color: _isDarkMode ? Colors.white : Colors.black), // Change icon color
              label: 'Tools',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: _isDarkMode ? Colors.white : Colors.black), // Change icon color
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.blue, // Keep selected item color blue
          unselectedItemColor: Colors.white70, // Adjust unselected item color for better visibility
          backgroundColor: _isDarkMode ? Color(0xFF121212) : Colors.white, // Use a better shade of black
          type: BottomNavigationBarType.fixed,
          elevation: 0, // Remove elevation from BottomNavigationBar
        ),
      ),
    );
  }

  Widget _getBody() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen();
      case 1:
        return AIScreen();
      case 2:
        return ToolsScreen();
      case 3:
        return ProfileScreen();
      default:
        return HomeScreen();
    }
  }

  TextStyle _textStyle({required double fontSize, FontWeight fontWeight = FontWeight.normal}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: _isDarkMode ? Colors.white : Colors.blue[900],
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
