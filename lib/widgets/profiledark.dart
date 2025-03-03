// ignore_for_file: prefer_const_declarations, deprecated_member_use

import 'package:Nexia/ai/screens/pdf_ai.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../ai/main1.dart';
import '../widgets/sgpa.dart';
import '../widgets/signup.dart';
import '../widgets/calcu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../widgets/syllabus.dart';
import 'package:Nexia/widgets/pdfviewer.dart';


String? _examTimetableLink;

class ProfilePage extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  

  ProfilePage({
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

Future<void> _launchURL(url) async { //you can also just use "void" or nothing at all - they all seem to work in this case
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

Future<void> launchUrlStart({required String url}) async {
  if (!await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}
class _ProfilePageState extends State<ProfilePage> {
  late bool _isDarkMode;
  late String _syllabusLink;

  final SyllabusData _syllabusData = SyllabusData();

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    _setSyllabusLink();
  }

  void _setSyllabusLink() {
    setState(() {
      _syllabusLink = _syllabusData.getSyllabusLink(widget.branch, widget.semester);
    });
  }

  Future<void> _launchPDFViewer() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerPage(
          pdfUrl: _syllabusLink,
          title: 'Syllabus',
        ),
      ),
    );
  }

  Future<void> _toggleTheme(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = isDarkMode;
    });
    await prefs.setBool('isDarkMode', _isDarkMode);
    widget.onThemeChanged(_isDarkMode);
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
      (Route<dynamic> route) => false,
    );
  }
   void _showAboutUsPopup() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: _isDarkMode ? Color(0xFF202020) : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nexia Notes 🎓',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Nexia Notes comes with all possible materials an engineer has been looking for.',
                  style: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black87),
                ),
                SizedBox(height: 10),
                Text(
                  'We found people struggling for resources, and spending hours on getting basic material, Nexia Notes solves your problem by providing everything in a single place with an easy and ad-free experience.',
                  style: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black87),
                ),
                SizedBox(height: 10),
                Text(
                  'Nexia Notes comes with:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '- All types of notes for all possible branches\n'
                  '- Updated PYQ\'s\n'
                  '- Easiness to find the syllabus\n'
                  '- Updated time-table for university examinations\n'
                  '- Useful tools and notification updates',
                  style: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black87),
                ),
                SizedBox(height: 10),
                Text(
                  'Developed By:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () => launchUrlStart( url :'https://www.instagram.com/_vishnu._.25/'),
                  child: Text(
                    'Vishnu S',
                    style: TextStyle(color: _isDarkMode ? Colors.blue : Colors.blue),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSupportUsPopup() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: _isDarkMode ? Color(0xFF202020) : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FOUND SOME NOTES MISSING? 🤔',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Support us by submitting your materials using the form provided below.',
                  style: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black87),
                ),
                SizedBox(height: 15),
                
                
                ElevatedButton(
                  child: Text(
                    'Submit Materials',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed:  () => launchUrlStart( url :'https://forms.gle/ze5DsM2hZj98ubWw9'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'SUPPORT US TO GROW 🚀',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Finding app useful? Support us by sharing it with your friends or rate us on playstore.',
                  style: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black87),
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  child: Text('Rate Us Now' , style: TextStyle(  color:  Colors.white ),),
                  onPressed:  () => launchUrlStart( url :'https://forms.gle/WnnFQRTkWjYHxfAv5'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Color(0xFF1A1A2E) : Color(0xFFF0F8FF),
      body: SafeArea(
        child: Stack(
          children: [
            // Add decorative background pattern
            Positioned.fill(
              child: _isDarkMode
                  ? CustomPaint(
                      painter: DotPatternPainter(
                        color: Colors.white.withOpacity(0.03),
                      ),
                    )
                  : CustomPaint(
                      painter: DotPatternPainter(
                        color: Colors.blue.withOpacity(0.05),
                      ),
                    ),
            ),
            
            SingleChildScrollView(
              child: Column(
                children: [
                  // Enhanced Header with Glass Effect
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isDarkMode 
                                ? [
                                    Color(0xFF4C4DDC).withOpacity(0.9),
                                    Color(0xFF1A1A2E).withOpacity(0.9),
                                  ]
                                : [
                                    Colors.blue[400]!.withOpacity(0.9),
                                    Colors.blue[100]!.withOpacity(0.9),
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_back, color: Colors.white),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                Text(
                                  'Profile',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 40), // Balance the header
                              ],
                            ),
                            SizedBox(height: 20),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                // Decorative circles behind avatar
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withOpacity(0.2),
                                        Colors.white.withOpacity(0.1),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 12,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.fullName[0].toUpperCase(),
                                      style: TextStyle(
                                        color: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[800],
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              widget.fullName,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.school,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '${widget.year} - ${widget.branch}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    widget.semester,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Features Section
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Features',
                          style: TextStyle(
                            color: _isDarkMode ? Colors.white70 : Colors.grey[700],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildFeatureCard(
                          icon: Icons.book,
                          title: 'Syllabus',
                          onTap: _launchPDFViewer,
                        ),
                        _buildFeatureCard(
                          icon: Icons.calendar_today,
                          title: 'Exam Timetable',
                          onTap: () {
                            if (_examTimetableLink == null || _examTimetableLink!.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('No exams dude, just be chill!')),
                              );
                            } else {
                              _launchURL(_examTimetableLink!);
                            }
                          },
                        ),
                        _buildFeatureCard(
                          icon: Icons.calculate,
                          title: 'Nexia AI',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => GeminiChat()),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Settings Section
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Settings',
                          style: TextStyle(
                            color: _isDarkMode ? Colors.white70 : Colors.grey[700],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildSettingsCard(
                          icon: Icons.dark_mode,
                          title: 'Dark Mode',
                          isSwitch: true,
                          value: _isDarkMode,
                          onChanged: _toggleTheme,
                        ),
                        _buildFeatureCard(
                          icon: Icons.language,
                          title: 'Website',
                          onTap: () => _launchURL(Uri.https('nexianotes.vercel.app', '')),
                        ),
                        _buildFeatureCard(
                          icon: Icons.info,
                          title: 'About Us',
                          onTap: _showAboutUsPopup,
                        ),
                        _buildFeatureCard(
                          icon: Icons.support,
                          title: 'Support Us',
                          onTap: _showSupportUsPopup,
                        ),
                        _buildFeatureCard(
                          icon: Icons.share,
                          title: 'Share App',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  // Logout Button
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () => _logout(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Footer
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Terms & Conditions',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Text('|', style: TextStyle(color: Colors.grey)),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Privacy Policy',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        Text('v1.0.0', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: _isDarkMode ? Color(0xFF252542) : Colors.white,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: _isDarkMode 
              ? Color(0xFF4C4DDC).withOpacity(0.2)
              : Colors.blue.withOpacity(0.1),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _isDarkMode 
                      ? Color(0xFF4C4DDC).withOpacity(0.1)
                      : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: _isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required bool isSwitch,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Card(
      elevation: 0,
      color: _isDarkMode ? Color(0xFF252542) : Colors.white,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: _isDarkMode 
              ? Color(0xFF4C4DDC).withOpacity(0.2)
              : Colors.blue.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isDarkMode 
                    ? Color(0xFF4C4DDC).withOpacity(0.1)
                    : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: _isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Color(0xFF4C4DDC),
            ),
          ],
        ),
      ),
    );
  }
}

// Add the DotPatternPainter class at the end of the file
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
