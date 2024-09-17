// ignore_for_file: prefer_const_declarations, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/sgpa.dart';
import '../widgets/signup.dart';
import '../widgets/calcu.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      backgroundColor: _isDarkMode ? Color(0xFF101010) : Colors.white,
      appBar: AppBar(
        backgroundColor: _isDarkMode ? Color(0xFF101010) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _isDarkMode ? Colors.white : Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.fullName, 
                              style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('${widget.year} - ${widget.branch}', style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 2),
                          Text('${widget.semester}', style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue,
                      child: Text(
                        widget.fullName[0].toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text('Features', style: TextStyle(color: Colors.grey)),
                    ),
                    ListTile(
                      leading: Icon(Icons.book, color: _isDarkMode ? Colors.white : Colors.black),
                      title: Text('Syllabus', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                      trailing: Icon(Icons.chevron_right, color: _isDarkMode ? Colors.white : Colors.black),
                      onTap: _launchPDFViewer,
                    ),
                    // navigate to syllabus page
                    
                    
                    ListTile(
                      leading: Icon(Icons.calendar_today, color: _isDarkMode ? Colors.white : Colors.black),
                      title: Text('Exam Timetable', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                      trailing: Icon(Icons.chevron_right, color: _isDarkMode ? Colors.white : Colors.black),
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
                    ListTile(
                      leading: Icon(Icons.calculate, color: _isDarkMode ? Colors.white : Colors.black),
                      title: Text('SGPA Converter', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                      trailing: Icon(Icons.chevron_right, color: _isDarkMode ? Colors.white : Colors.black),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SGPAConverterPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              SwitchListTile(
                secondary: Icon(Icons.dark_mode, color: _isDarkMode ? Colors.white : Colors.black),
                title: Text('Dark Mode', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                value: _isDarkMode,
                onChanged: (bool value) {
                  _toggleTheme(value);
                },
              ),
              
              ListTile(
                leading: Icon(Icons.language, color: _isDarkMode ? Colors.white : Colors.black),
                title: Text('Website', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                trailing: Icon(Icons.chevron_right, color: _isDarkMode ? Colors.white : Colors.black),
                onTap: () async {
                       _launchURL(Uri.https('nexianotes.vercel.app', ''));
                 },
                
                ),
             
              ListTile(
                leading: Icon(Icons.info, color: _isDarkMode ? Colors.white : Colors.black),
                title: Text('About Us', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                trailing: Icon(Icons.chevron_right, color: _isDarkMode ? Colors.white : Colors.black),
                onTap: _showAboutUsPopup,
              ),
              ListTile(
                leading: Icon(Icons.support, color: _isDarkMode ? Colors.white : Colors.black),
                title: Text('Support Us', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                trailing: Icon(Icons.chevron_right, color: _isDarkMode ? Colors.white : Colors.black),
                onTap: _showSupportUsPopup,
              ),
              ListTile(
                leading: Icon(Icons.share, color: _isDarkMode ? Colors.white : Colors.black),
                title: Text('Share App', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                trailing: Icon(Icons.chevron_right, color: _isDarkMode ? Colors.white : Colors.black),
                onTap: () {
                  // Open share dialog
                },
              ),
              
              Padding(
                padding: EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.logout, color: Colors.white),
                  label: Text('Logout', style: TextStyle(fontSize: 20, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    _logout(context);
                  },
                ),
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Terms & Condition', style: TextStyle(color: Colors.grey)),
                  SizedBox(width: 16),
                  Text('Privacy Policy', style: TextStyle(color: Colors.grey)),
                ],
              ),
              SizedBox(height: 8),
              Text('v1.0.0', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
