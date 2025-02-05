import 'package:flutter/material.dart';
import 'package:Nexia/widgets/profile.dart';
import 'package:Nexia/widgets/pdfviewer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:Nexia/widgets/navbar/home_screen.dart'; // Import HomeScreen
import 'package:Nexia/widgets/navbar/ai_screen.dart'; // Import AIScreen
import 'package:Nexia/widgets/navbar/tools_screen.dart'; // Import ToolsScreen
import 'package:Nexia/widgets/navbar/profile_screen.dart'; // Import ProfileScreen

class bme extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  bme({required this.fullName, required this.branch, required this.year, required this.semester});

  @override
  _bmeState createState() => _bmeState();
}

class _bmeState extends State<bme> {
  bool _isDarkMode = true;
  int _currentIndex = 0;

  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;

  final List<UnitItem> units = [
    UnitItem(
      title: 'MODULE I: Thermodynamics and Heat Transfer',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?id=1XI0lw-dkG6Pg-8SD-O8dIvV4Opna6jLu&export=download',
    ),
    UnitItem(
      title: 'MODULE II: Thermal Power Generation Systems',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?id=1VLPSe3vgnX8HjeDrutp3_L54rJIMdTPY&export=download',
    ),
    UnitItem(
      title: 'MODULE III: Fluid Machines',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?id=1VTGNJAYBCMLVzd1YavpHWi9hINwcFB34&export=download',
    ),
    UnitItem(
      title: 'MODULE IV: Refrigeration and Air Conditioning',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?id=13fb3OYc-L8oTBT5B1TJ94wjiPXbscQ9S&export=download',
    ),
    UnitItem(
      title: 'MODULE V: Manufacturing Process',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?id=19-oWN-cAY3yeR2bLL6_TDR7cqSyjbztb&export=download',
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
