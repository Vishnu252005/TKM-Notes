// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:Nexia/widgets/adpage.dart';
import 'package:flutter/material.dart';
import 'package:Nexia/widgets/calcu.dart';
import 'package:Nexia/widgets/conv.dart';
import 'package:Nexia/widgets/graph.dart';
import 'package:rive/rive.dart';
import '../widgets/sgpa.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';


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
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
  double _currentZoom = 1.0;
  bool _isNightMode = false;
  bool _showControls = true;
  PDFViewController? _pdfViewController;
  TextEditingController _pageController = TextEditingController();
  List<int> _bookmarks = [];
  bool _isFullScreen = false;

  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;

  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _loadBookmarks();
    _downloadFile(widget.pdfUrl);
    // _loadBannerAd();
    _loadInterstitialAd();
    
    // Auto-hide controls after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
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
      adUnitId: 'ca-app-pub-1850470420397635/7479635461', // Replace with your Interstitial Ad unit ID
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
      _isNightMode = prefs.getBool('isNightMode') ?? false;
    });
  }

  // Load bookmarks from SharedPreferences
  Future<void> _loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String bookmarkKey = 'bookmarks_${widget.pdfUrl.hashCode}';
    List<String>? bookmarkStrings = prefs.getStringList(bookmarkKey);
    if (bookmarkStrings != null) {
      setState(() {
        _bookmarks = bookmarkStrings.map((s) => int.parse(s)).toList();
      });
    }
  }

  // Save bookmarks to SharedPreferences
  Future<void> _saveBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String bookmarkKey = 'bookmarks_${widget.pdfUrl.hashCode}';
    List<String> bookmarkStrings = _bookmarks.map((b) => b.toString()).toList();
    await prefs.setStringList(bookmarkKey, bookmarkStrings);
  }

  // Toggle bookmark for current page
  void _toggleBookmark() {
    setState(() {
      if (_bookmarks.contains(_currentPage)) {
        _bookmarks.remove(_currentPage);
      } else {
        _bookmarks.add(_currentPage);
      }
      _saveBookmarks();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _bookmarks.contains(_currentPage) 
              ? 'Page ${_currentPage + 1} bookmarked' 
              : 'Bookmark removed'
        ),
        duration: Duration(seconds: 1),
      ),
    );
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
  
  // Toggle night reading mode
  void _toggleNightMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNightMode = !_isNightMode;
      prefs.setBool('isNightMode', _isNightMode);
    });
  }

  // Toggle fullscreen mode
  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    });
  }

  // Navigate to specific page
  void _goToPage(int page) {
    if (_pdfViewController != null && page >= 0 && page < _totalPages) {
      _pdfViewController!.setPage(page);
    }
  }

  // Share the PDF file
  Future<void> _sharePDF() async {
    if (localFilePath != null) {
      await Share.shareXFiles(
        [XFile(localFilePath!)],
        text: 'Sharing ${widget.title} PDF',
      );
    }
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

  // Show bookmarks dialog
  void _showBookmarksDialog() {
    if (_bookmarks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No bookmarks yet')),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bookmarks'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _bookmarks.length,
              itemBuilder: (context, index) {
                int page = _bookmarks[index];
                return ListTile(
                  title: Text('Page ${page + 1}'),
                  onTap: () {
                    Navigator.pop(context);
                    _goToPage(page);
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _bookmarks.removeAt(index);
                        _saveBookmarks();
                      });
                      Navigator.pop(context);
                      _showBookmarksDialog();
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
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
    _pageController.dispose();
    // Reset system UI when widget is disposed
    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    super.dispose();
  }

   @override
  Widget build(BuildContext context) {
    return BasePage(
      child: Scaffold(
        appBar: _isFullScreen ? null : AppBar(
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
              onPressed: _toggleTheme,
            ),
            IconButton(
              icon: Icon(Icons.bookmark, color: Colors.white),
              onPressed: _showBookmarksDialog,
            ),
            IconButton(
              icon: Icon(Icons.share, color: Colors.white),
              onPressed: _sharePDF,
            ),
          ],
        ),
        body: GestureDetector(
          onTap: () {
            setState(() {
              _showControls = !_showControls;
            });
          },
          child: Stack(
          children: [
              // Night mode overlay
              if (_isNightMode)
                Positioned.fill(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.amber.withOpacity(0.1),
                      BlendMode.overlay,
                    ),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              
              // PDF View
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
                          pageSnap: true,
                          defaultPage: _currentPage,
                          fitPolicy: FitPolicy.WIDTH,
                          preventLinkNavigation: false,
                        onRender: (pages) {
                          setState(() {
                            _totalPages = pages!;
                              _pageController.text = '${_currentPage + 1}';
                            });
                          },
                          onViewCreated: (PDFViewController pdfViewController) {
                            setState(() {
                              _pdfViewController = pdfViewController;
                          });
                        },
                        onPageChanged: (int? page, int? total) {
                          setState(() {
                            _currentPage = page!;
                              _pageController.text = '${_currentPage + 1}';
                          });
                        },
                        onError: (error) {
                          _showErrorDialog('Error loading PDF: $error');
                        },
                        onPageError: (page, error) {
                          _showErrorDialog('Page $page error: $error');
                        },
                      ),
              
              // Page indicator
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _isDarkMode ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    'Page ${_currentPage + 1} of $_totalPages',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              // Bottom controls
              if (_showControls)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: _isDarkMode ? Colors.black.withOpacity(0.8) : Colors.white.withOpacity(0.8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Zoom controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.zoom_out),
                              onPressed: () {
                                setState(() {
                                  _currentZoom = (_currentZoom - 0.1).clamp(0.5, 3.0);
                                });
                                // Note: PDFView doesn't directly support zoom control
                                // This is a UI indication only
                              },
                            ),
                            Slider(
                              value: _currentZoom,
                              min: 0.5,
                              max: 3.0,
                              divisions: 25,
                              label: '${(_currentZoom * 100).round()}%',
                              onChanged: (value) {
                                setState(() {
                                  _currentZoom = value;
                                });
                                // Note: PDFView doesn't directly support zoom control
                                // This is a UI indication only
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.zoom_in),
                              onPressed: () {
                                setState(() {
                                  _currentZoom = (_currentZoom + 0.1).clamp(0.5, 3.0);
                                });
                                // Note: PDFView doesn't directly support zoom control
                                // This is a UI indication only
                              },
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 8),
                        
                        // Page navigation
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(Icons.first_page),
                              onPressed: () => _goToPage(0),
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () => _goToPage(_currentPage - 1),
                            ),
                            Container(
                              width: 60,
                              child: TextField(
                                controller: _pageController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                  border: OutlineInputBorder(),
                                ),
                                onSubmitted: (value) {
                                  int? page = int.tryParse(value);
                                  if (page != null) {
                                    _goToPage(page - 1);
                                  }
                                },
                              ),
                            ),
                            Text('/ $_totalPages'),
                            IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              onPressed: () => _goToPage(_currentPage + 1),
                            ),
                            IconButton(
                              icon: Icon(Icons.last_page),
                              onPressed: () => _goToPage(_totalPages - 1),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 8),
                        
                        // Additional controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(
                                _bookmarks.contains(_currentPage) 
                                    ? Icons.bookmark 
                                    : Icons.bookmark_border,
                                color: _bookmarks.contains(_currentPage) 
                                    ? Colors.blue 
                                    : null,
                              ),
                              onPressed: _toggleBookmark,
                              tooltip: 'Bookmark this page',
                            ),
                            IconButton(
                              icon: Icon(
                                _isNightMode 
                                    ? Icons.nightlight_round 
                                    : Icons.nightlight_outlined,
                                color: _isNightMode 
                                    ? Colors.amber 
                                    : null,
                              ),
                              onPressed: _toggleNightMode,
                              tooltip: 'Night reading mode',
                            ),
                            IconButton(
                              icon: Icon(
                                _isFullScreen
                                    ? Icons.fullscreen_exit
                                    : Icons.fullscreen,
                              ),
                              onPressed: _toggleFullScreen,
                              tooltip: 'Toggle fullscreen',
                            ),
                            IconButton(
                              icon: Icon(Icons.rotate_90_degrees_ccw),
                              onPressed: () {
                                // Note: PDFView doesn't directly support rotation
                                // This is a placeholder for future implementation
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Rotation not supported yet')),
                                );
                              },
                              tooltip: 'Rotate page',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
        floatingActionButton: _showControls ? FloatingActionButton(
          onPressed: () {
            // Show a quick help dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('PDF Viewer Help'),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHelpItem(Icons.bookmark, 'Bookmark pages for quick access'),
                        _buildHelpItem(Icons.nightlight_round, 'Night mode for comfortable reading'),
                        _buildHelpItem(Icons.fullscreen, 'Toggle fullscreen mode'),
                        _buildHelpItem(Icons.zoom_in, 'Zoom in/out using the slider'),
                        _buildHelpItem(Icons.first_page, 'Navigate between pages'),
                        _buildHelpItem(Icons.share, 'Share this PDF with others'),
                        _buildHelpItem(Icons.touch_app, 'Tap anywhere to show/hide controls'),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(Icons.help_outline),
          backgroundColor: _isDarkMode ? Colors.blue : Colors.blue[700],
        ) : null,
      ),
    );
  }
  
  // Helper method to build help items
  Widget _buildHelpItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24),
          SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}