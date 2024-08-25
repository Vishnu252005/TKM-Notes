// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import '../widgets/sgpa.dart';
import '../widgets/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String fullName;
  final String branch;
  final String year;
  final String semester;

  ProfilePage({
    required this.fullName,
    required this.branch,
    required this.year,
    required this.semester,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    });
  }

  Future<void> _toggleTheme(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = isDarkMode;
    });
    await prefs.setBool('isDarkMode', _isDarkMode);
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
              // User profile section
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
                          Text(widget.fullName, style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
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
              
              // Features section
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
                      onTap: () {
                        // Navigate to Syllabus page
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.calendar_today, color: _isDarkMode ? Colors.white : Colors.black),
                      title: Text('Exam Timetable', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                      trailing: Icon(Icons.chevron_right, color: _isDarkMode ? Colors.white : Colors.black),
                      onTap: () {
                        // Navigate to Exam Timetable page
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
              
              // Dark Mode toggle
              SwitchListTile(
                secondary: Icon(Icons.dark_mode, color: _isDarkMode ? Colors.white : Colors.black),
                title: Text('Dark Mode', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                value: _isDarkMode, // Set the initial value
                onChanged: (bool value) {
                  _toggleTheme(value);
                },
              ),
              
              // Additional options
              ListTile(
                leading: Icon(Icons.language, color: _isDarkMode ? Colors.white : Colors.black),
                title: Text('Website', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                trailing: Icon(Icons.chevron_right, color: _isDarkMode ? Colors.white : Colors.black),
                onTap: () {
                  // Navigate to Website page
                },
              ),
              ListTile(
                leading: Icon(Icons.info, color: _isDarkMode ? Colors.white : Colors.black),
                title: Text('About Us', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                trailing: Icon(Icons.chevron_right, color: _isDarkMode ? Colors.white : Colors.black),
                onTap: () {
                  // Navigate to About Us page
                },
              ),
              ListTile(
                leading: Icon(Icons.support, color: _isDarkMode ? Colors.white : Colors.black),
                title: Text('Support Us', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                trailing: Icon(Icons.chevron_right, color: _isDarkMode ? Colors.white : Colors.black),
                onTap: () {
                  // Navigate to Support Us page
                },
              ),
              ListTile(
                leading: Icon(Icons.share, color: _isDarkMode ? Colors.white : Colors.black),
                title: Text('Share App', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                trailing: Icon(Icons.chevron_right, color: _isDarkMode ? Colors.white : Colors.black),
                onTap: () {
                  // Open share dialog
                },
              ),
              
              // Logout button
              Padding(
                padding: EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.logout, color: Colors.white),
                  label: Text('Logout', style: TextStyle(fontSize: 20, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    _logout(context);
                  },
                ),
              ),
              
              // Terms and Privacy
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Terms & Condition', style: TextStyle(color: Colors.grey)),
                  SizedBox(width: 16),
                  Text('Privacy Policy', style: TextStyle(color: Colors.grey)),
                ],
              ),
              SizedBox(height: 8),
              Text('v1.1.7(2)', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
