import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100], // Light blue background
      appBar: AppBar(
        title: Text('Welcome to Nexia Notes'),
        backgroundColor: Colors.blue, // AppBar color
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildPage(
                  title: 'Comprehensive Notes',
                  description: 'Access a wide range of notes for all subjects.',
                  icon: Icons.book, // Use Material Icons
                ),
                _buildPage(
                  title: 'Previous Year Questions',
                  description: 'Prepare effectively with previous year questions.',
                  icon: Icons.question_answer, // Use Material Icons
                ),
                _buildPage(
                  title: 'Exam Timetable',
                  description: 'Stay updated with the latest exam schedules.',
                  icon: Icons.calendar_today, // Use Material Icons
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                width: _currentPage == index ? 12.0 : 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            }),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              if (_currentPage == 2) {
                // On the last page, navigate to the sign-up screen
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isFirstTime', false);
                Navigator.of(context).pushReplacementNamed('/signup'); // Ensure this matches the route defined
              } else {
                // Move to the next page
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Button color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Button padding
            ),
            child: Text(
              _currentPage == 2 ? 'Sign Up' : 'Next',
              style: TextStyle(fontSize: 18, color: Colors.white), // Button text style
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPage({required String title, required String description, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: Colors.blue), // Use an icon instead of an image
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue[800]), // Title style
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(fontSize: 16, color: Colors.black54), // Description style
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 