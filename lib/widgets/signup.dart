import 'package:flutter/material.dart';


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


import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _fullName, _branch, _year, _semester;
  List<String> _branchOptions = ['CSE', 'MECH', 'EEE', 'CIVIL', 'CHEMICAL', 'EC', 'ER'];
  List<String> _yearOptions = ['First Year', 'Second Year', 'Third Year', 'Fourth Year'];
  Map<String, List<String>> _semesterOptions = {
    'First Year': ['Sem1', 'Sem2'],
    'Second Year': ['Sem3', 'Sem4'],
    'Third Year': ['Sem5', 'Sem6'],
    'Fourth Year': ['Sem7', 'Sem8'],
  };

  // Updated color scheme
  final Color primaryBlue = Color(0xFF2563EB);
  final Color darkBlue = Color(0xFF1E40AF);
  final Color lightBlue = Color(0xFF60A5FA);
  final Color surfaceBlue = Color(0xFF0F172A);
  final Color inputBlue = Color(0xFF1E293B);
  final Color accentBlue = Color(0xFF38BDF8);
  final Color errorRed = Color(0xFFDC2626);

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString('fullName');
      _branch = prefs.getString('branch');
      _year = prefs.getString('year');
      _semester = prefs.getString('semester');
    });

    // Navigate to the respective route if the user has already signed up
    if (_fullName != null && _branch != null && _year != null && _semester != null) {
      String routeName = '${_branch!}${_semester!}';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(
          context,
          routeName,
          arguments: {
            'fullName': _fullName!,
            'branch': _branch!,
            'year': _year!,
            'semester': _semester!,
          },
        );
      });
    }
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_fullName != null && _branch != null && _year != null && _semester != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('fullName', _fullName!);
        await prefs.setString('branch', _branch!);
        await prefs.setString('year', _year!);
        await prefs.setString('semester', _semester!);

        String routeName = '${_branch!}${_semester!}';
        Navigator.pushNamed(
          context,
          routeName,
          arguments: {
            'fullName': _fullName!,
            'branch': _branch!,
            'year': _year!,
            'semester': _semester!,
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: surfaceBlue,
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient with pattern
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [darkBlue.withOpacity(0.8), surfaceBlue],
                ),
              ),
              child: ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Colors.transparent],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    backgroundBlendMode: BlendMode.overlay,
                    image: DecorationImage(
                      image: AssetImage('assets/images/pattern.png'), // Add a subtle pattern image
                      repeat: ImageRepeat.repeat,
                      opacity: 0.05,
                    ),
                  ),
                ),
              ),
            ),
            
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.04),
                    child: Column(
                      children: [
                        // Animated logo container
                        TweenAnimationBuilder(
                          duration: Duration(milliseconds: 800),
                          tween: Tween<double>(begin: 0, end: 1),
                          builder: (context, double value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primaryBlue.withOpacity(0.1),
                                  border: Border.all(
                                    color: primaryBlue.withOpacity(0.3),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryBlue.withOpacity(0.2),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.school_rounded,
                                  size: 48,
                                  color: accentBlue,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 24),
                        // Animated text
                        TweenAnimationBuilder(
                          duration: Duration(milliseconds: 800),
                          tween: Tween<double>(begin: 0, end: 1),
                          builder: (context, double value, child) {
                            return Opacity(
                              opacity: value,
                              child: child,
                            );
                          },
                          child: Column(
                            children: [
                              Text(
                                'Student Registration',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Enter your academic details below',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: lightBlue.withOpacity(0.7),
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Form Container
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: padding),
                    padding: EdgeInsets.all(padding),
                    decoration: BoxDecoration(
                      color: surfaceBlue.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: primaryBlue.withOpacity(0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: darkBlue.withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildFormField('Full Name', Icons.person_outline),
                          SizedBox(height: 24),
                          _buildBranchDropdown(),
                          SizedBox(height: 24),
                          _buildYearDropdown(),
                          SizedBox(height: 24),
                          _buildSemesterSelection(),
                          SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 100), // Space for the button
                ],
              ),
            ),

            // Submit Button
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: _buildSubmitButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(String label, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        _buildAnimatedContainer(
          child: TextFormField(
            decoration: _buildInputDecoration(label, icon),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
            validator: (value) => value?.isEmpty ?? true ? 'This field is required' : null,
            onSaved: (value) => _fullName = value,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          padding: EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Complete Registration',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            inputBlue.withOpacity(0.5),
            inputBlue,
          ],
        ),
        border: Border.all(
          color: primaryBlue.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: child,
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          color: accentBlue,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: accentBlue.withOpacity(0.5),
        fontSize: 16,
      ),
      prefixIcon: Icon(icon, color: accentBlue),
      filled: true,
      fillColor: Colors.transparent,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryBlue, width: 1),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _buildBranchDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Branch'),
        _buildAnimatedContainer(
          child: DropdownButtonFormField(
            items: _branchOptions.map((String branch) {
              return DropdownMenuItem(value: branch, child: Text(branch));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _branch = newValue;
              });
            },
            decoration: _buildInputDecoration('Select Branch', Icons.school_outlined),
            style: TextStyle(color: Colors.white, fontSize: 16),
            dropdownColor: inputBlue,
            icon: Icon(Icons.arrow_drop_down, color: accentBlue),
            validator: (value) => value == null ? 'Please select your branch' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildYearDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Year'),
        _buildAnimatedContainer(
          child: DropdownButtonFormField(
            items: _yearOptions.map((String year) {
              return DropdownMenuItem(value: year, child: Text(year));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _year = newValue;
                _semester = null;
              });
            },
            decoration: _buildInputDecoration('Select Year', Icons.calendar_today_outlined),
            style: TextStyle(color: Colors.white, fontSize: 16),
            dropdownColor: inputBlue,
            icon: Icon(Icons.arrow_drop_down, color: accentBlue),
          ),
        ),
      ],
    );
  }

  Widget _buildSemesterSelection() {
    if (_year != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('Semester'),
          Container(
            height: 55,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _semesterOptions[_year]!.map((String sem) {
                bool isSelected = _semester == sem;
                return Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: _buildAnimatedContainer(
                    child: ElevatedButton(
                      child: Text(
                        sem,
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected ? Colors.white : accentBlue,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          letterSpacing: 0.5,
                        ),
                      ),
                      onPressed: () => setState(() => _semester = sem),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? primaryBlue : inputBlue,
                        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: isSelected ? 8 : 0,
                        shadowColor: isSelected ? primaryBlue.withOpacity(0.5) : Colors.transparent,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
