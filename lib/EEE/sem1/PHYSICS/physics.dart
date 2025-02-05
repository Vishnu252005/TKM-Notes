import 'package:flutter/material.dart';
import 'package:Nexia/widgets/profile.dart';
import 'package:Nexia/widgets/pdfviewer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:Nexia/widgets/navbar/home_screen.dart';
import 'package:Nexia/widgets/navbar/ai_screen.dart';
import 'package:Nexia/widgets/navbar/tools_screen.dart';
import 'package:Nexia/widgets/navbar/profile_screen.dart';
import 'package:Nexia/EEE/sem1/eee_sem1_screen.dart';

class physics extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  physics({required this.fullName, required this.branch, required this.year, required this.semester});

  @override
  _physicsState createState() => _physicsState();
}

class _physicsState extends State<physics> {
  bool _isDarkMode = true;
  int _currentIndex = 0;
  int _tapCount = 0;
  DateTime? _lastTapTime;

  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;

  final List<UnitItem> units = [
    UnitItem(
      title: 'MODULE I: Oscillations and Wave Motion',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?id=1V-FCKg7Tz_umFg8S4-jWIqVeZhBZ9vik&export=download',
    ),
    UnitItem(
      title: 'MODULE II: Wave Optics',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?id=1Ut1Dzv04dHfP2XC19MFDpTaw_Tg1ebiN&export=download',
    ),
    UnitItem(
      title: 'MODULE III: Quantum Mechanics for Engineers',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?export=download&id=1RevW5URdibj1YaHkcK6H2o5hzzlJAOSX',
    ),
    UnitItem(
      title: 'MODULE IV: Introduction to Electromagnetic Theory',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?id=1wAN75ixM3jg2veCKDH4meb2z0eM4Igoz&export=download',
    ),
    UnitItem(
      title: 'MODULE V: Introduction to Solids',
      isAvailable: true,
      pdfUrl: 'https://drive.google.com/uc?id=1zbtXyLrD3ePTP5ts66DimQbQ89Gj58Go&export=download',
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
      appBar: _currentIndex == 0 // Show AppBar only for the physics screen
          ? AppBar(
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
            )
          : null, // No AppBar for other screens
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Stack(
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
                                'Engineering physics',
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
                      backgroundColor: Colors.blue[700], // Updated color
                      child: Text(
                        widget.fullName[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          AIScreen(),
          ToolsScreen(),
          ProfileScreen(),
        ],
      ),
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
            if (index == 0) {
              // Handle double tap to navigate to EEESem1Screen
              final currentTime = DateTime.now();
              if (_lastTapTime == null || currentTime.difference(_lastTapTime!) > Duration(seconds: 1)) {
                _tapCount = 0; // Reset tap count if more than 1 second has passed
              }

              _tapCount++;
              _lastTapTime = currentTime;

              if (_tapCount == 2) {
                // Navigate to EEESem1Screen on double tap
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EEESem1Screen(
                      fullName: widget.fullName,
                      branch: widget.branch,
                      year: widget.year,
                      semester: widget.semester,
                    ),
                  ),
                );
              } else {
                // Single tap to go to physics screen
                setState(() {
                  _currentIndex = 0; // Set the current index to physics
                });
              }
            } else {
              setState(() {
                _currentIndex = index; // Update the current index
              });
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
