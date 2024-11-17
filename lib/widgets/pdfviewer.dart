// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:Nexia/widgets/adpage.dart';
import 'package:flutter/material.dart';
import 'package:Nexia/widgets/calcu.dart';
import 'package:Nexia/widgets/conv.dart';
import 'package:Nexia/widgets/graph.dart';
import '../widgets/sgpa.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


import 'dart:io';


import '../CHEMICAL/sem1/chemical_sem1_screen.dart';
import '../CHEMICAL/sem2/chemical_sem2_screen.dart';
import '../CHEMICAL/sem3/chemical_sem3_screen.dart';
import '../CHEMICAL/sem4/chemical_sem4_screen.dart';
import '../CHEMICAL/sem5/chemical_sem5_screen.dart';
import '../CHEMICAL/sem6/chemical_sem6_screen.dart';
import '../CHEMICAL/sem7/chemical_sem7_screen.dart';
import '../CHEMICAL/sem8/chemical_sem8_screen.dart';

import '../CIVIL/sem1/civil_sem1_screen.dart';
import '../CIVIL/sem2/civil_sem2_screen.dart';
import '../CIVIL/sem3/civil_sem3_screen.dart';
import '../CIVIL/sem4/civil_sem4_screen.dart';
import '../CIVIL/sem5/civil_sem5_screen.dart';
import '../CIVIL/sem6/civil_sem6_screen.dart';
import '../CIVIL/sem7/civil_sem7_screen.dart';
import '../CIVIL/sem8/civil_sem8_screen.dart';

import '../CSE/sem1/cse_sem1_screen.dart';
import '../CSE/sem2/cse_sem2_screen.dart';
import '../CSE/sem3/cse_sem3_screen.dart';
import '../CSE/sem4/cse_sem4_screen.dart';
import '../CSE/sem5/cse_sem5_screen.dart';
import '../CSE/sem6/cse_sem6_screen.dart';
import '../CSE/sem7/cse_sem7_screen.dart';
import '../CSE/sem8/cse_sem8_screen.dart';

import '../EC/sem1/ec_sem1_screen.dart';
import '../EC/sem2/ec_sem2_screen.dart';
import '../EC/sem3/ec_sem3_screen.dart';
import '../EC/sem4/ec_sem4_screen.dart';
import '../EC/sem5/ec_sem5_screen.dart';
import '../EC/sem6/ec_sem6_screen.dart';
import '../EC/sem7/ec_sem7_screen.dart';
import '../EC/sem8/ec_sem8_screen.dart';

import '../EEE/sem1/eee_sem1_screen.dart';
import '../EEE/sem2/eee_sem2_screen.dart';
import '../EEE/sem2/PSP/psp.dart';
import '../EEE/sem3/eee_sem3_screen.dart';
import '../EEE/sem4/eee_sem4_screen.dart';
import '../EEE/sem5/eee_sem5_screen.dart';
import '../EEE/sem6/eee_sem6_screen.dart';
import '../EEE/sem7/eee_sem7_screen.dart';
import '../EEE/sem8/eee_sem8_screen.dart';

import '../ER/sem1/er_sem1_screen.dart';
import '../ER/sem2/er_sem2_screen.dart';
import '../ER/sem3/er_sem3_screen.dart';
import '../ER/sem4/er_sem4_screen.dart';
import '../ER/sem5/er_sem5_screen.dart';
import '../ER/sem6/er_sem6_screen.dart';
import '../ER/sem7/er_sem7_screen.dart';
import '../ER/sem8/er_sem8_screen.dart';

import '../MECH/sem1/mech_sem1_screen.dart';
import '../MECH/sem2/mech_sem2_screen.dart';
import '../MECH/sem3/mech_sem3_screen.dart';
import '../MECH/sem4/mech_sem4_screen.dart';
import '../MECH/sem5/mech_sem5_screen.dart';
import '../MECH/sem6/mech_sem6_screen.dart';
import '../MECH/sem7/mech_sem7_screen.dart';
import '../MECH/sem8/mech_sem8_screen.dart';






// Add this import at the top
// Replace with actual path

import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';




// Ensure this is the correct import for BasePage



class PDFViewerPage extends StatefulWidget {
  final String pdfUrl;
  final String title;

  const PDFViewerPage({required this.pdfUrl, required this.title});

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String? localFilePath;
  bool _isLoading = true;
  bool _isDarkMode = true;
  int _currentPage = 0;
  int _totalPages = 0;

  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;

  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _downloadFile(widget.pdfUrl);
    // _loadBannerAd();
    _loadInterstitialAd();
  }

  // Load the banner ad
  // void _loadBannerAd() {
  //   _bannerAd = BannerAd(
  //     adUnitId: 'ca-app-pub-3940256099942544/9214589741', // Replace with your Banner Ad unit ID
  //     size: AdSize.banner,
  //     request: AdRequest(),
  //     listener: BannerAdListener(
  //       onAdLoaded: (_) {
  //         setState(() {
  //           _isBannerAdLoaded = true;
  //         });
  //       },
  //       onAdFailedToLoad: (ad, error) {
  //         print('Banner ad failed to load: $error');
  //         ad.dispose();
  //       },
  //     ),
  //   );
  //   _bannerAd.load();
  // }

  // Load the interstitial ad
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Replace with your Interstitial Ad unit ID
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _interstitialAd = ad;
            _isInterstitialAdReady = true;
            _showInterstitialAd(); // Show ad when loaded
          });
        },
        onAdFailedToLoad: (error) {
          print('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  // Show the interstitial ad
  void _showInterstitialAd() {
    if (_isInterstitialAdReady) {
      _interstitialAd.show();
    } else {
      print("Interstitial ad is not ready.");
    }
  }

  // Load theme preference from SharedPreferences
  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    });
  }

  // Download the PDF file from the URL
  Future<void> _downloadFile(String url) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/downloaded.pdf');
        await file.writeAsBytes(bytes);
        setState(() {
          localFilePath = file.path;
        });
      } else {
        _showErrorDialog('Failed to load PDF. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('Error downloading PDF: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Toggle the theme (light/dark mode)
  void _toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = !_isDarkMode;
      prefs.setBool('isDarkMode', _isDarkMode);
    });
  }

  // Show an error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Dispose of ads to prevent memory leaks
    if (_isInterstitialAdReady) {
      _interstitialAd.dispose();
    }
    if (_isBannerAdLoaded) {
      _bannerAd.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          backgroundColor: _isDarkMode ? Colors.black : Colors.blue[700],
          actions: [
            IconButton(
              icon: Icon(
                _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: Colors.white,
              ),
              onPressed: _toggleTheme,  // This is where the theme toggle happens
            ),
          ],
        ),
        body: Stack(
          children: [
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _isDarkMode ? Colors.blue : Colors.blue,
                      ),
                    ),
                  )
                : localFilePath == null
                    ? Center(child: Text('Error loading PDF'))
                    : PDFView(
                        filePath: localFilePath!,
                        enableSwipe: true,
                        swipeHorizontal: false,
                        autoSpacing: false,
                        pageFling: false,
                        onRender: (pages) {
                          setState(() {
                            _totalPages = pages!;
                          });
                        },
                        onPageChanged: (int? page, int? total) {
                          setState(() {
                            _currentPage = page!;
                          });
                        },
                        onError: (error) {
                          _showErrorDialog('Error loading PDF: $error');
                        },
                        onPageError: (page, error) {
                          _showErrorDialog('Page $page error: $error');
                        },
                      ),
            if (_isBannerAdLoaded)
              Positioned(
                bottom: 0,
                child: Container(
                  width: _bannerAd.size.width.toDouble(),
                  height: _bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
