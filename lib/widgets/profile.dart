// ignore_for_file: avoid_unnecessary_containers, unnecessary_string_interpolations, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_2/widgets/sgpa.dart';
import 'package:flutter_application_2/widgets/signup.dart';

class ProfilePage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
                          Text(fullName, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('$year - $branch', style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 2),
                          Text('$semester', style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              // Add functionality for edit action
                            },
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.red[600],
                      child: Text(
                        fullName[0].toUpperCase(),
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
                      leading: Icon(Icons.book, color: Colors.white),
                      title: Text('Syllabus', style: TextStyle(color: Colors.white)),
                      trailing: Icon(Icons.chevron_right, color: Colors.white),
                      onTap: () {
                        // Navigate to Syllabus page
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.calendar_today, color: Colors.white),
                      title: Text('Exam Timetable', style: TextStyle(color: Colors.white)),
                      trailing: Icon(Icons.chevron_right, color: Colors.white),
                      onTap: () {
                        // Navigate to Exam Timetable page
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.calculate, color: Colors.white),
                      title: Text('SGPA Converter', style: TextStyle(color: Colors.white)),
                      trailing: Icon(Icons.chevron_right, color: Colors.white),
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
                secondary: Icon(Icons.dark_mode, color: Colors.white),
                title: Text('Dark Mode', style: TextStyle(color: Colors.white)),
                value: true, // Set the initial value
                onChanged: (bool value) {
                  // Toggle dark mode
                },
              ),
              
              // Additional options
              ListTile(
                leading: Icon(Icons.language, color: Colors.white),
                title: Text('Website', style: TextStyle(color: Colors.white)),
                trailing: Icon(Icons.chevron_right, color: Colors.white),
                onTap: () {
                  // Navigate to Website page
                },
              ),
              ListTile(
                leading: Icon(Icons.info, color: Colors.white),
                title: Text('About Us', style: TextStyle(color: Colors.white)),
                trailing: Icon(Icons.chevron_right, color: Colors.white),
                onTap: () {
                  // Navigate to About Us page
                },
              ),
              ListTile(
                leading: Icon(Icons.support, color: Colors.white),
                title: Text('Support Us', style: TextStyle(color: Colors.white)),
                trailing: Icon(Icons.chevron_right, color: Colors.white),
                onTap: () {
                  // Navigate to Support Us page
                },
              ),
              ListTile(
                leading: Icon(Icons.share, color: Colors.white),
                title: Text('Share App', style: TextStyle(color: Colors.white)),
                trailing: Icon(Icons.chevron_right, color: Colors.white),
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
                    Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                        );
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
