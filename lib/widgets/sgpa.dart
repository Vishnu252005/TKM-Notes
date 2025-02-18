import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class SGPAConverterPage extends StatefulWidget {
  @override
  _SGPAConverterPageState createState() => _SGPAConverterPageState();
}

class _SGPAConverterPageState extends State<SGPAConverterPage> {
  double sgpa = 0.0;
  double percentage = 0.0;
  double cgpa = 0.0;
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

  void calculateValues(double inputSGPA) {
    setState(() {
      sgpa = inputSGPA;
      percentage = (sgpa - 0.75) * 10; // Assuming a formula to convert SGPA to percentage
      cgpa = (sgpa * 8) / 10; // Assuming a formula to convert SGPA to CGPA
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: _isDarkMode ? Color(0xFF1F1F1F) : Color.fromARGB(255, 3, 13, 148),
        title: Text('SGPA Converter', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter SGPA',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: _isDarkMode ? Colors.white : Color(0xFF333333)),
            ),
            SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
              cursorColor: _isDarkMode ? Colors.white : Colors.black,
              decoration: InputDecoration(
                hintText: 'Enter SGPA',
                hintStyle: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.grey[600]),
                fillColor: _isDarkMode ? Color(0xFF1E1E1E) : Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    sgpa = 0.0;
                    percentage = 0.0;
                    cgpa = 0.0;
                  });
                } else {
                  double inputSGPA = double.parse(value);
                  calculateValues(inputSGPA);
                }
              },
            ),
            SizedBox(height: 24),
            Text(
              'Results',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: _isDarkMode ? Colors.white : Color(0xFF333333)),
            ),
            SizedBox(height: 16),
            _buildResultCard('Percentage', '${percentage.toStringAsFixed(2)}%'),
            SizedBox(height: 8),
            _buildResultCard('CGPA', cgpa.toStringAsFixed(2)),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(String title, String value) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isDarkMode ? Color(0xFF1E1E1E) : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: _isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: _isDarkMode ? Colors.white70 : Color(0xFF333333), fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(color: _isDarkMode ? Colors.white : Color(0xFF333333), fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SGPAConverterPage(),
  ));
}
