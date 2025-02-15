import 'package:flutter/material.dart';
import 'package:Nexia/widgets/profile.dart';
import 'package:Nexia/widgets/pdfviewer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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

  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;

  final List<UnitItem> units = [
    UnitItem(
      title: 'MODULE I: D.C. Circuits and Magnetic Circuits',
      isAvailable: true,
      pdfUrl:
          'https://drive.google.com/uc?id=1upWv1xmmJS04tXp6wSAyDnn9CMCDXYCb&export=download',
    ),
    UnitItem(
      title: 'MODULE II: Single Phase Systems',
      isAvailable: true,
      pdfUrl:
          'https://drive.google.com/uc?id=1C6Rq9tyDeEiQEBsuxgFbIlZtEkIqk3UV&export=download',
    ),
    UnitItem(
      title: 'MODULE III: Three Phase Systems and Power Transmission',
      isAvailable: true,
      pdfUrl:
          'https://drive.google.com/uc?id=1M2_s78Psixy20UTdWURZbKH1TSqrk6oo&export=download',
    ),
    UnitItem(
      title: 'MODULE IV: DC Machines and Transformers',
      isAvailable: false,
      pdfUrl:
          'https://drive.google.com/uc?id=1cytyh20LsW6hSEmBun8LBi8ZKdbfy9wM&export=download',
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
      adUnitId:
          'ca-app-pub-1850470420397635/2911662464', // Replace with your Ad Unit ID
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
                            'Basics of Electrical Engineering',
                            style: _textStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Select Chapter',
                            style: _textStyle(fontSize: 18),
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
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ]
                        : [],
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
    );
  }

  TextStyle _textStyle(
      {required double fontSize, FontWeight fontWeight = FontWeight.normal}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: _isDarkMode ? Colors.white : Colors.blue[900],
    );
  }

  Widget _buildListItem(
      BuildContext context, String title, bool isAvailable, String? pdfUrl) {
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
          style:
              TextStyle(color: _isDarkMode ? Colors.white : Colors.blue[900]),
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
