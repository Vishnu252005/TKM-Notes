import 'package:flutter/material.dart'; // Import Flutter Material
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart'; // Import SharedPreferences
import 'package:flutter_animate/flutter_animate.dart'; // Import the flutter_animate package
import 'package:flutter/rendering.dart'; // Import flutter rendering
import 'package:flutter/services.dart'; // Add this import for HapticFeedback
import 'package:url_launcher/url_launcher.dart'; // Add this import for URL launching
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;

class ProfileScreen extends StatefulWidget {
    @override
    _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
    final TextEditingController usernameController = TextEditingController(); // Controller for username
    final TextEditingController emailController = TextEditingController(); // Controller for email
    final TextEditingController passwordController = TextEditingController(); // Controller for password
    final TextEditingController phoneController = TextEditingController(); // Controller for phone number
    final TextEditingController universityController = TextEditingController(); // Controller for university
    final TextEditingController yearController = TextEditingController(); // Controller for year of study
    final TextEditingController departmentController = TextEditingController(); // Controller for department

    bool isSignUp = true; // Toggle between sign-up and sign-in
    String? username; // Store username
    String? email; // Store email
    String? phone; // Store phone number
    String? university; // Store university
    String? year; // Store year of study
    String? selectedCollege; // Variable to hold the selected college
    String? selectedDepartment; // Variable to hold the selected department
    String? selectedYear; // Variable to hold the selected year of study
    String? department; // Store department
    bool isDarkMode = true; // Set default to dark mode

    // List of engineering colleges for the dropdown
    final List<String> colleges = [
    'APJ Abdul Kalam Technological University',
    'Adi Shankara Institute of Engineering and Technology, Kalady',
    'Aditya Kiran College of Applied Studies, Kannur',
    'Ahalia School of Engineering and Technology, Palakkad',
    'Albertian Institute of Science and Technology, Kalamassery',
    'Amal Jyothi College of Engineering, Kanjirappally',
    'Ammini College of Engineering, Palakkad',
    'Amrita School of Engineering, Amritapuri',
    'Amrita Vishwa Vidyapeetham, Coimbatore',
    'Aryanet Institute of Technology, Palakkad',
    'Baselios MathewsII College of Engineering, Sasthamcotta',
    'Believers Church Caarmel Engineering College, Pathanamthitta',
    'Caarmel Engineering College, Pathanamthitta',
    'Calicut University Institute of Engineering and Technology, Tenhipalam',
    'Christ Knowledge City, Ernakulam',
    'College of Dairy Science and Technology, Mannuthy',
    'College of Engineering Adoor, Pathanamthitta',
    'College of Engineering Attingal, Thiruvananthapuram',
    'College of Engineering Chengannur, Alappuzha',
    'College of Engineering Cherthala, Alappuzha',
    'College of Engineering Kallooppara, Pathanamthitta',
    'College of Engineering Karunagappally, Kollam',
    'College of Engineering Kottarakkara, Kollam',
    'College of Engineering Munnar, Idukki',
    'College of Engineering Pathanapuram, Kollam',
    'College of Engineering Poonjar, Kottayam',
    'College of Engineering Thalassery, Kannur',
    'College of Engineering Trikaripur, Kasaragod',
    'College of Engineering Vadakara, Kozhikode',
    'College of Engineering, Aranmula',
    'College of Engineering, Kidangoor',
    'College of Engineering, Perumon',
    'College of Engineering, Punnapra',
    'College of Engineering, Thiruvananthapuram',
    'Cochin University College of Engineering Kuttanad, Alappuzha',
    'Cochin University of Science and Technology, Kochi',
    'Federal Institute of Science and Technology, Angamaly',
    'Government College of Engineering, Kannur',
    'Government Engineering College Barton Hill, Thiruvananthapuram',
    'Government Engineering College Idukki, Painavu',
    'Government Engineering College Kozhikode, West Hill',
    'Government Engineering College Sreekrishnapuram, Palakkad',
    'Government Engineering College Thrissur',
    'Government Engineering College Wayanad, Mananthavady',
    'Government Model Engineering College, Kochi',
    'Heera College of Engineering and Technology, Thiruvananthapuram',
    'Hindustan College of Engineering, Kollam',
    'Holy Grace Academy of Engineering, Mala',
    'Holy Kings College of Engineering and Technology, Ernakulam',
    'IES College of Engineering, Thrissur',
    'Ilahia College of Engineering and Technology, Muvattupuzha',
    'Indian Institute of Information Technology Kottayam',
    'Indian Institute of Science Education and Research, Thiruvananthapuram',
    'Indian Institute of Space Science and Technology, Thiruvananthapuram',
    'Jawaharlal College of Engineering and Technology, Palakkad',
    'Jyothi Engineering College, Thrissur',
    'KMEA Engineering College, Aluva',
    'Kelappaji College of Agricultural Engineering and Technology, Tavanur',
    'LBS College of Engineering, Kasaragod',
    'LBS Institute of Technology for Women, Thiruvananthapuram',
    'Lourdes Matha College of Science and Technology, Thiruvananthapuram',
    'MES College of Engineering, Kuttippuram',
    'MG College of Engineering, Thiruvananthapuram',
    'MG University College of Engineering, Thodupuzha',
    'MEA Engineering College, Perinthalmanna',
    'MES Institute of Technology and Management, Kollam',
    'MES College of Engineering and Technology, Ernakulam',
    'METS School of Engineering, Mala',
    'MG College of Engineering, Thiruvananthapuram',
    'MG University College of Engineering, Thodupuzha',
    'MVJ College of Engineering, Bangalore',
    'MVSR Engineering College, Hyderabad',
    'MZC College of Engineering and Technology, Pathanamthitta',
    'Muthoot Institute of Technology and Science, Ernakulam',
    'NSS College of Engineering, Palakkad',
    'Nehru College of Engineering and Research Centre, Thrissur',
    'Nirmala College of Engineering, Chalakudy',
    'North Malabar Institute of Technology, Kanhangad',
    'PA Aziz College of Engineering and Technology, Thiruvananthapuram',
    'PES Institute of Technology and Management, Shimoga',
    'PSN College of Engineering and Technology, Tirunelveli',
    'Pankajakasthuri College of Engineering and Technology, Thiruvananthapuram',
    'Rajadhani Institute of Engineering and Technology, Thiruvananthapuram',
    'Rajagiri School of Engineering and Technology, Kochi',
    'Rajiv Gandhi Institute of Technology, Kottayam',
    'Royal College of Engineering and Technology, Thirussur',
    'SB College of Engineering, Bangalore',
    'SCMS School of Engineering and Technology, Ernakulam',
    'SNG College of Engineering, Kolenchery',
    'SNM Institute of Management and Technology, Ernakulam',
    'SNS College of Engineering, Coimbatore',
    'Sahrdaya College of Engineering and Technology, Thiruvananthapuram',
    'Saintgits College of Engineering, Kottayam',
    'Sarabhai Institute of Science and Technology, Thiruvananthapuram',
    'Sherlock Institute of Engineering and Technology, Ernakulam',
    'Sree Buddha College of Engineering, Alappuzha',
    'Sree Chitra Thirunal College of Engineering, Thiruvananthapuram',
    'Sree Narayana Gurukulam College of Engineering, Ernakulam',
    'Sreepathy Institute of Management and Technology, Vavanoor',
    'St. Joseph\'s College of Engineering and Technology, Palai',
    'St. Thomas College of Engineering and Technology, Kannur',
    'TKM College of Engineering, Kollam',
    'Thejus Engineering College, Thiruvananthapuram',
    'Travancore Engineering College, Kollam',
    'UKF College of Engineering and Technology, Kollam',
    'University College of Engineering, Kariavattom',
    'Vidya Academy of Science and Technology, Thiruvananthapuram',
];


    // List of departments for the dropdown
    final List<String> departments = [
        'Computer Science',
        'Electrical Engineering',
        'Mechanical Engineering',
        'Civil Engineering',
        'Biology',
        'Business Administration',
        'Psychology',
        'Mathematics',
        'Physics',
        'Chemistry',
        // Add more departments as needed
    ];

    // List of years for the dropdown
    final List<String> years = ['1', '2', '3', '4', '5'];

    @override
    void initState() {
        super.initState();
        _loadUserCredentials(); // Load user credentials on app launch
        _loadThemePreference(); // Load theme preference
    }

    // Method to load user credentials from SharedPreferences
    Future<void> _loadUserCredentials() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? savedEmail = prefs.getString('email');
        String? savedPassword = prefs.getString('password');

        if (savedEmail != null && savedPassword != null) {
            emailController.text = savedEmail; // Pre-fill email
            passwordController.text = savedPassword; // Pre-fill password
            await signIn(); // Automatically sign in the user
        }
    }

    // Method to load theme preference from SharedPreferences
    Future<void> _loadThemePreference() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
            isDarkMode = prefs.getBool('isDarkMode') ?? true; // Default to true if not set
        });
    }

    // Method to toggle theme
    void _toggleTheme() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
            isDarkMode = !isDarkMode; // Toggle the theme
            prefs.setBool('isDarkMode', isDarkMode); // Save preference
        });
    }

    // Method to handle sign-up
    Future<void> signUp() async {
        String usernameInput = usernameController.text.trim();
        String emailInput = emailController.text.trim();
        String password = passwordController.text;

        if (usernameInput.isEmpty || emailInput.isEmpty || password.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please fill in all required fields")),
            );
            return;
        }

        try {
            // Create user in Firebase Auth
            UserCredential userCredential = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: emailInput,
                    password: password,
                );

            // Create a new document with auto-generated ID in users collection
            await FirebaseFirestore.instance
                .collection('users')
                .add({  // Using .add() instead of .doc().set() for auto ID
                    'username': usernameInput,
                    'email': emailInput,
                    'createdAt': FieldValue.serverTimestamp(),
                    'userId': userCredential.user?.uid,  // Store Firebase Auth UID
                    'phone': null,
                    'address': null,
                    'major': null,
                    'university': null,
                    'department': null,
                    'year': null,
                    'bio': null,
                    'interests': null,
                    'socialMedia': null,
                });

            // Save credentials
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('email', emailInput);
            await prefs.setString('password', password);

            // Update local state
            setState(() {
                username = usernameInput;
                email = emailInput;
                // Initialize other fields as null
                phone = null;
                university = null;
                department = null;
                year = null;
            });

            // Show success message
            _showSuccessMessage(
                "Account created successfully!",
                Icons.check,
            );

        } on FirebaseAuthException catch (e) {
            String errorMessage = "An error occurred during sign up";
            
            if (e.code == 'weak-password') {
                errorMessage = 'The password provided is too weak';
            } else if (e.code == 'email-already-in-use') {
                errorMessage = 'An account already exists for this email';
            } else if (e.code == 'invalid-email') {
                errorMessage = 'Please enter a valid email address';
            }
            
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(errorMessage)),
            );
        } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: ${e.toString()}")),
            );
        }
    }

    // Method to handle sign-in
    Future<void> signIn() async {
        String emailInput = emailController.text.trim();
        String password = passwordController.text;

        if (emailInput.isEmpty || password.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please enter email and password")),
            );
            return;
        }

        try {
            // Sign in with Firebase Auth
            UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: emailInput,
                password: password,
            );

            // Query Firestore to get user data using userId
            QuerySnapshot userDocs = await FirebaseFirestore.instance
                .collection('users')
                .where('userId', isEqualTo: userCredential.user?.uid)
                .get();

            if (userDocs.docs.isNotEmpty) {
                // Get the first document (should be only one)
                DocumentSnapshot userData = userDocs.docs.first;
                Map<String, dynamic> data = userData.data() as Map<String, dynamic>;

                // Save credentials
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('email', emailInput);
                await prefs.setString('password', password);

                // Update state with user data
                setState(() {
                    username = data['username'] ?? '';
                    email = data['email'] ?? '';
                    phone = data['phone'];
                    university = data['university'];
                    department = data['department'];
                    year = data['year'];
                });

                // Show success message
                _showSuccessMessage(
                    "Welcome back! Signed in successfully",
                    Icons.login_rounded,
                );
            } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("User data not found")),
                );
            }

        } on FirebaseAuthException catch (e) {
            String errorMessage = "An error occurred during sign in";
            
            if (e.code == 'user-not-found') {
                errorMessage = 'No user found for that email';
            } else if (e.code == 'wrong-password') {
                errorMessage = 'Wrong password provided';
            } else if (e.code == 'invalid-email') {
                errorMessage = 'Please enter a valid email address';
            }
            
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(errorMessage)),
            );
        } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: ${e.toString()}")),
            );
        }
    }

    // Method to handle password reset
    Future<void> resetPassword() async {
        String emailInput = emailController.text; // Get email from the controller
        if (emailInput.isNotEmpty) {
            try {
                await FirebaseAuth.instance.sendPasswordResetEmail(email: emailInput);
                // Show a message to the user
                _showSuccessMessage("Password reset email sent! Check your inbox.", Icons.email);
            } catch (e) {
                // Handle error (e.g., show error message)
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error sending password reset email: $e")),
                );
            }
        } else {
            // Show a message to enter an email
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please enter your email address.")),
            );
        }
    }

    // Method to update user profile
    Future<void> updateProfile() async {
        try {
            // Get current user's auth ID
            String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
            
            if (currentUserId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("No user signed in")),
                );
                return;
            }

            // Get the user document using userId field
            QuerySnapshot userDocs = await FirebaseFirestore.instance
                .collection('users')
                .where('userId', isEqualTo: currentUserId)
                .get();

            if (userDocs.docs.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("User document not found")),
                );
                return;
            }

            // Get the document reference
            DocumentReference userDoc = userDocs.docs.first.reference;

            // Update the document with new values
            await userDoc.update({
                'phone': phoneController.text.trim(),
                'university': selectedCollege,
                'department': selectedDepartment,
                'year': selectedYear,
            });

            // Fetch updated data
            DocumentSnapshot updatedData = await userDoc.get();
            Map<String, dynamic> data = updatedData.data() as Map<String, dynamic>;

            // Update state with new values
            setState(() {
                phone = data['phone'];
                university = data['university'];
                department = data['department'];
                year = data['year'];
            });

            // Show success message
            _showSuccessMessage(
                "Your profile has been updated successfully!",
                Icons.check_circle_outline,
            );

        } catch (e) {
            // Handle error
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error updating profile: ${e.toString()}")),
            );
        }
    }

    // Add this method to your _ProfileScreenState class
    Future<void> logout() async {
        try {
            await FirebaseAuth.instance.signOut();
            // Clear user credentials from SharedPreferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove('email');
            await prefs.remove('password');

            // Set username to null to show the authentication screen
            setState(() {
                username = null; // This will trigger the _buildAuthScreen to be displayed
            });
        } catch (e) {
            // Handle logout error (e.g., show error message)
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error logging out: $e")),
            );
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: isDarkMode ? Color(0xFF1A1A2E) : Colors.blue[50],
            body: Stack(
                children: [
                    // Background pattern
                    Positioned.fill(
                        child: CustomPaint(
                            painter: DotPatternPainter(
                                color: isDarkMode 
                                    ? Colors.white.withOpacity(0.03)
                                    : Colors.blue.withOpacity(0.05),
                            ),
                        ),
                    ),

                    // Main content
                    username == null
                        ? _buildAuthScreen()
                        : SingleChildScrollView(
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
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        colors: isDarkMode 
                                                            ? [
                                                                Color(0xFF4C4DDC),
                                                                Color(0xFF1A1A2E),
                                                            ]
                                                            : [
                                                                Colors.blue[400]!,
                                                                Colors.blue[100]!,
                                                            ],
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                    ),
                                                ),
                                                child: SafeArea(
                                                    child: Padding(
                                                        padding: EdgeInsets.all(24),
                                                        child: Column(
                                                            children: [
                                                                Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                        Container(
                                                                            padding: EdgeInsets.symmetric(
                                                                                horizontal: 16,
                                                                                vertical: 8,
                                                                            ),
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.white.withOpacity(0.15),
                                                                                borderRadius: BorderRadius.circular(20),
                                                                            ),
                                                                            child: Row(
                                                                                children: [
                                                                                    Icon(
                                                                                        Icons.person,
                                                                                        color: Colors.white,
                                                                                        size: 16,
                                                                                    ),
                                                                                    SizedBox(width: 8),
                                                                                    Text(
                                                                                        'PROFILE',
                                                                                        style: TextStyle(
                                                                                            color: Colors.white,
                                                                                            fontSize: 14,
                                                                                            letterSpacing: 0.3,
                                                                                        ),
                                                                                    ),
                                                                                ],
                                                                            ),
                                                                        ),
                                                                        _buildThemeToggle(),
                                                                    ],
                                                                ),
                                                                SizedBox(height: 24),
                                                                CircleAvatar(
                                                                    radius: 50,
                                                                    backgroundColor: Colors.white,
                                                                    child: Text(
                                                                        username?[0].toUpperCase() ?? 'U',
                                                                        style: TextStyle(
                                                                            fontSize: 40,
                                                                            fontWeight: FontWeight.bold,
                                                                            color: isDarkMode 
                                                                                ? Color(0xFF4C4DDC)
                                                                                : Colors.blue[700],
                                                                        ),
                                                                    ),
                                                                ).animate()
                                                                    .fadeIn(duration: 600.ms)
                                                                    .scale(delay: 200.ms),
                                                                SizedBox(height: 16),
                                                                Text(
                                                                    username ?? 'User',
                                                                    style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 24,
                                                                        fontWeight: FontWeight.bold,
                                                                    ),
                                                                ),
                                                                if (email != null)
                                                                    Text(
                                                                        email!,
                                                                        style: TextStyle(
                                                                            color: Colors.white.withOpacity(0.8),
                                                                            fontSize: 16,
                                                                        ),
                                                                    ),
                                                            ],
                                                        ),
                                                    ),
                                                ),
                                            ),
                                        ),
                                    ),

                                    // Profile sections with consistent styling
                                    Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                            children: [
                                                _buildProfileSection()
                                                    .animate()
                                                    .fadeIn(delay: 200.ms)
                                                    .slideX(begin: -0.2),
                                                SizedBox(height: 16),
                                                _buildEducationSection()
                                                    .animate()
                                                    .fadeIn(delay: 400.ms)
                                                    .slideX(begin: 0.2),
                                                SizedBox(height: 16),
                                                // Management sections
                                                FutureBuilder<bool>(
                                                    future: _isUserSuperAdmin(),
                                                    builder: (context, superAdminSnapshot) {
                                                        if (superAdminSnapshot.connectionState == ConnectionState.waiting) {
                                                            return Center(child: CircularProgressIndicator());
                                                        }

                                                        if (superAdminSnapshot.hasData && superAdminSnapshot.data!) {
                                                            return Column(
                                                                children: [
                                                                    _buildManagementSection()
                                                                        .animate()
                                                                        .fadeIn(delay: 400.ms)
                                                                        .slideX(begin: -0.2),
                                                                    SizedBox(height: 16),
                                                                    _buildSuperAdminSection()
                                                                        .animate()
                                                                        .fadeIn(delay: 500.ms)
                                                                        .slideX(begin: -0.2),
                                                                    SizedBox(height: 16),
                                                                    _buildAdminManagementSection()
                                                                        .animate()
                                                                        .fadeIn(delay: 600.ms)
                                                                        .slideX(begin: 0.2),
                                                                    SizedBox(height: 16),
                                                                    _buildOrganizerManagementSection()
                                                                        .animate()
                                                                        .fadeIn(delay: 700.ms)
                                                                        .slideX(begin: 0.2),
                                                                    SizedBox(height: 16),
                                                                ],
                                                            );
                                                        }

                                                        return FutureBuilder<bool>(
                                                            future: _isUserAdmin(),
                                                            builder: (context, adminSnapshot) {
                                                                if (adminSnapshot.connectionState == ConnectionState.waiting) {
                                                                    return Center(child: CircularProgressIndicator());
                                                                }

                                                                if (adminSnapshot.hasData && adminSnapshot.data!) {
                                                                    return Column(
                                                                        children: [
                                                                            _buildManagementSection()
                                                                                .animate()
                                                                                .fadeIn(delay: 500.ms)
                                                                                .slideX(begin: -0.2),
                                                                            SizedBox(height: 16),
                                                                            _buildAdminManagementSection()
                                                                                .animate()
                                                                                .fadeIn(delay: 600.ms)
                                                                                .slideX(begin: -0.2),
                                                                            SizedBox(height: 16),
                                                                            _buildOrganizerManagementSection()
                                                                                .animate()
                                                                                .fadeIn(delay: 700.ms)
                                                                                .slideX(begin: 0.2),
                                                                            SizedBox(height: 16),
                                                                        ],
                                                                    );
                                                                }

                                                                return FutureBuilder<bool>(
                                                                    future: _isUserOrganizer(),
                                                                    builder: (context, organizerSnapshot) {
                                                                        if (organizerSnapshot.connectionState == ConnectionState.waiting) {
                                                                            return Center(child: CircularProgressIndicator());
                                                                        }

                                                                        if (organizerSnapshot.hasData && organizerSnapshot.data!) {
                                                                            return Column(
                                                                                children: [
                                                                                    _buildManagementSection()
                                                                                        .animate()
                                                                                        .fadeIn(delay: 600.ms)
                                                                                        .slideX(begin: -0.2),
                                                                                    SizedBox(height: 16),
                                                                                    _buildOrganizerManagementSection()
                                                                                        .animate()
                                                                                        .fadeIn(delay: 700.ms)
                                                                                        .slideX(begin: 0.2),
                                                                                    SizedBox(height: 16),
                                                                                ],
                                                                            );
                                                                        }
                                                                        return SizedBox.shrink();
                                                                    },
                                                                );
                                                            },
                                                        );
                                                    },
                                                ),
                                                _buildEventsSection()
                                                    .animate()
                                                    .fadeIn(delay: 800.ms)
                                                    .slideX(begin: 0.2),
                                                SizedBox(height: 24),
                                                _buildLogoutButton(),
                                            ],
                                        ),
                                    ),
                                ],
                            ),
                        ),
                ],
            ),
            floatingActionButton: username != null
                ? FloatingActionButton(
                    onPressed: _showEditProfileDialog,
                    backgroundColor: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
                    child: Icon(Icons.edit, color: Colors.white),
                  ).animate()
                    .scale(delay: 1200.ms)
                : null,
        );
    }

    Widget _buildProfileSection() {
        return _buildSection(
            'Personal Information',
            Icons.person_outline,
            [
                _buildInfoTile(Icons.email, 'Email', email ?? 'Not provided'),
                _buildInfoTile(Icons.phone, 'Phone', phone ?? 'Not provided'),
            ],
        );
    }

    Widget _buildEducationSection() {
        return _buildSection(
            'Education',
            Icons.school,
            [
                _buildInfoTile(
                    Icons.business, 
                    'College', 
                    university ?? 'Not provided'
                ),
                _buildInfoTile(
                    Icons.category, 
                    'Department', 
                    department ?? 'Not provided'
                ),
                _buildInfoTile(
                    Icons.calendar_today, 
                    'Year', 
                    year ?? 'Not provided'
                ),
            ],
        );
    }

    Widget _buildManagementSection() {
        return Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
                color: isDarkMode ? Color(0xFF252542) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                    ),
                ],
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text(
                                    'Event Management',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode ? Colors.white : Colors.black,
                                    ),
                                ),
                                IconButton(
                                    icon: Icon(
                                        Icons.download,
                                        color: isDarkMode ? Colors.white70 : Colors.grey[700],
                                    ),
                                    onPressed: _downloadEventData,
                                    tooltip: 'Download Events Report',
                                ),
                            ],
                        ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('events')
                            .snapshots(),
                        builder: (context, snapshot) {
                            if (snapshot.hasError) {
                                return Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text('Error loading events'),
                                );
                            }

                            if (!snapshot.hasData) {
                                return Center(child: CircularProgressIndicator());
                            }

                            final events = snapshot.data!.docs;
                            int totalEvents = events.length;
                            int totalRegistrations = 0;
                            double totalRevenue = 0;

                            for (var event in events) {
                                final data = event.data() as Map<String, dynamic>;
                                List<dynamic>? registeredUsers = data['registeredUsers'] as List<dynamic>?;
                                totalRegistrations += registeredUsers?.length ?? 0;
                                totalRevenue += (data['price'] ?? 0) * (registeredUsers?.length ?? 0);
                            }

                            return Column(
                                children: [
                                    Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                                _buildStatCard(
                                                    'Total Events',
                                                    totalEvents.toString(),
                                                    Icons.event,
                                                    isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                                                ),
                                                _buildStatCard(
                                                    'Registrations',
                                                    totalRegistrations.toString(),
                                                    Icons.people,
                                                    isDarkMode ? Color(0xFF4C4DDC) : Colors.green,
                                                ),
                                                _buildStatCard(
                                                    'Revenue',
                                                    '₹${totalRevenue.toStringAsFixed(2)}',
                                                    Icons.currency_rupee,
                                                    isDarkMode ? Color(0xFF4C4DDC) : Colors.orange,
                                                ),
                                            ],
                                        ),
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: events.length,
                                        itemBuilder: (context, index) {
                                            final event = events[index].data() as Map<String, dynamic>;
                                            event['id'] = events[index].id;
                                            return _buildEventListTile(event);
                                        },
                                    ),
                                ],
                            );
                        },
                    ),
                ],
            ),
        );
    }

    Widget _buildEventsSection() {
        return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('events')
                .where('registeredUsers', arrayContains: FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, registeredSnapshot) {
                if (registeredSnapshot.hasError) {
                    return _buildSection(
                        'My Events',
                        Icons.event,
                        [Text('Error loading events')],
                    );
                }

                return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('events')
                        .where('creatorId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                        .snapshots(),
                    builder: (context, createdSnapshot) {
                        if (createdSnapshot.hasError) {
                            return _buildSection(
                                'My Events',
                                Icons.event,
                                [Text('Error loading events')],
                            );
                        }

                        List<Widget> eventWidgets = [];
                        DateTime now = DateTime.now();

                        // Process registered events
                        if (registeredSnapshot.hasData) {
                            List<DocumentSnapshot> registeredEvents = registeredSnapshot.data!.docs;
                            List<DocumentSnapshot> pastEvents = [];
                            List<DocumentSnapshot> upcomingEvents = [];

                            for (var event in registeredEvents) {
                                Map<String, dynamic> eventData = event.data() as Map<String, dynamic>;
                                DateTime eventDate = (eventData['date'] as Timestamp).toDate();
                                if (eventDate.isBefore(now)) {
                                    pastEvents.add(event);
                                } else {
                                    upcomingEvents.add(event);
                                }
                            }

                            if (upcomingEvents.isNotEmpty) {
                                eventWidgets.add(
                                    Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Text(
                                                    'Upcoming Registered Events',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: isDarkMode ? Colors.white : Colors.black,
                                                    ),
                                                ),
                                                SizedBox(height: 8),
                                                ...upcomingEvents.map((event) => _buildEventTile(event.data() as Map<String, dynamic>)),
                                            ],
                                        ),
                                    ),
                                );
                            }

                            if (pastEvents.isNotEmpty) {
                                eventWidgets.add(
                                    Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Text(
                                                    'Past Registered Events',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: isDarkMode ? Colors.white : Colors.black,
                                                    ),
                                                ),
                                                SizedBox(height: 8),
                                                ...pastEvents.map((event) => _buildEventTile(event.data() as Map<String, dynamic>)),
                                            ],
                                        ),
                                    ),
                                );
                            }
                        }

                        return _buildSection(
                            'My Events',
                            Icons.event,
                            eventWidgets,
                        );
                    },
                );
            },
        );
    }

    Widget _buildEventTile(Map<String, dynamic> eventData, {bool isCreated = false}) {
        String title = eventData['title'] ?? 'Untitled Event';
        DateTime date = (eventData['date'] as Timestamp).toDate();
        String location = eventData['location'] ?? 'No location';
        int registeredCount = (eventData['registeredUsers'] as List?)?.length ?? 0;
        int capacity = eventData['capacity'] ?? 0;
        bool isFull = registeredCount >= capacity;
        String type = eventData['type'] ?? 'Event';
        int points = eventData['points'] ?? 0;
        int price = eventData['price'] ?? 0;

        return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            color: isDarkMode ? Colors.grey[900] : Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                    color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                    width: 1,
                ),
            ),
            child: InkWell(
                onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EventDetailsScreen(
                                eventData: eventData,
                                isCreated: isCreated,
                                isDarkMode: isDarkMode,
                            ),
                        ),
                    );
                },
                borderRadius: BorderRadius.circular(12),
                child: Column(
                    children: [
                        // Event Image
                        ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                                eventData['image'] ?? 'https://images.unsplash.com/photo-1505373877841-8d25f7d46678',
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                    height: 120,
                                    color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                                    child: Icon(Icons.image_not_supported, color: Colors.grey),
                                ),
                            ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Row(
                                        children: [
                                            Container(
                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                    color: _getEventTypeColor(type).withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                    type,
                                                    style: TextStyle(
                                                        color: _getEventTypeColor(type),
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                    ),
                                                ),
                                            ),
                                            Spacer(),
                                            if (isCreated)
                                                Container(
                                                    padding: EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                        color: isDarkMode ? Colors.blue[900]!.withOpacity(0.2) : Colors.blue[50],
                                                        borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Icon(
                                                        Icons.edit,
                                                        size: 16,
                                                        color: isDarkMode ? Colors.blue[400] : Colors.blue[800],
                                                    ),
                                                ),
                                        ],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                        title,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: isDarkMode ? Colors.white : Colors.black,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                        children: [
                                            Icon(
                                                Icons.calendar_today,
                                                size: 16,
                                                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                                '${date.day}/${date.month}/${date.year}',
                                                style: TextStyle(
                                                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                                ),
                                            ),
                                            SizedBox(width: 16),
                                            Icon(
                                                Icons.location_on,
                                                size: 16,
                                                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                            ),
                                            SizedBox(width: 4),
                                            Expanded(
                                                child: Text(
                                                    location,
                                                    style: TextStyle(
                                                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                ),
                                            ),
                                        ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                        children: [
                                            Icon(
                                                Icons.star,
                                                size: 16,
                                                color: Colors.amber,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                                '$points pts',
                                                style: TextStyle(
                                                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                                    fontWeight: FontWeight.bold,
                                                ),
                                            ),
                                            SizedBox(width: 16),
                                            Icon(
                                                Icons.currency_rupee,
                                                size: 16,
                                                color: Colors.green[400],
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                                'Rs. $price',
                                                style: TextStyle(
                                                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                                    fontWeight: FontWeight.bold,
                                                ),
                                            ),
                                            Spacer(),
                                            Container(
                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                    color: isFull
                                                        ? Colors.red.withOpacity(0.1)
                                                        : Colors.green.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                    '$registeredCount/$capacity',
                                                    style: TextStyle(
                                                        color: isFull
                                                            ? Colors.red
                                                            : Colors.green,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                    ),
                                                ),
                                            ),
                                        ],
                                    ),
                                ],
                            ),
                        ),
                    ],
                ),
            ),
        );
    }

    Color _getEventTypeColor(String type) {
        switch (type.toLowerCase()) {
            case 'workshop':
                return Colors.orange;
            case 'seminar':
                return Colors.green;
            case 'conference':
                return Colors.purple;
            case 'hackathon':
                return Colors.red;
            default:
                return Colors.blue;
        }
    }

    Widget _buildSection(String title, IconData icon, List<Widget> children) {
        return Container(
            decoration: BoxDecoration(
                color: isDarkMode ? Color(0xFF252542) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: isDarkMode 
                        ? Color(0xFF4C4DDC).withOpacity(0.2)
                        : Colors.blue.withOpacity(0.1),
                    width: 1,
                ),
                boxShadow: [
                    BoxShadow(
                        color: isDarkMode 
                            ? Colors.black.withOpacity(0.3)
                            : Colors.blue.withOpacity(0.1),
                        offset: Offset(4, 4),
                        blurRadius: 15,
                        spreadRadius: 1,
                    ),
                    BoxShadow(
                        color: Colors.white.withOpacity(isDarkMode ? 0.1 : 1),
                        offset: Offset(-4, -4),
                        blurRadius: 15,
                        spreadRadius: 1,
                    ),
                ],
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                            children: [
                                Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: isDarkMode 
                                            ? Color(0xFF4C4DDC).withOpacity(0.1)
                                            : Colors.blue[50],
                                        borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                        icon,
                                        color: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
                                    ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                    title,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode ? Colors.white : Colors.blue[800],
                                    ),
                                ),
                            ],
                        ),
                    ),
                    ...children,
                ],
            ),
        );
    }

    Widget _buildInfoTile(IconData icon, String label, String value) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
                children: [
                    Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: isDarkMode 
                                ? Colors.blue[900]!.withOpacity(0.2)
                                : Colors.blue[50]!,
                            borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                            icon, 
                            color: isDarkMode ? Colors.blue[400] : Colors.blue[800],
                            size: 22,
                        ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                label,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                                        fontSize: 14,
                ),
            ),
                                SizedBox(height: 4),
                                Text(
                value,
                style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.w500,
                                    ),
                                ),
                            ],
                        ),
                    ),
                ],
            ),
        )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideX(begin: 0.2);
    }

    Widget _buildCollegeDropdown() {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: DropdownSearch<String>(
                popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                            hintText: 'Search college...',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                            ),
                        ),
                    ),
                    constraints: BoxConstraints(maxHeight: 300), // Adjust popup height
                    showSelectedItems: true,
                    itemBuilder: (context, item, isSelected) {
                        return Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Text(
                                item,
                                style: TextStyle(fontSize: 16),
                            ),
                        );
                    },
                ),
                items: colleges,
                dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                        labelText: "Select College",
                        prefixIcon: Icon(Icons.business),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                ),
                selectedItem: selectedCollege,
                onChanged: (String? newValue) {
                    setState(() {
                        selectedCollege = newValue; // Update selected university
                    });
                },
            ),
        );
    }

    Widget _buildDepartmentDropdown() {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: DropdownSearch<String>(
                popupProps: PopupProps.menu(
                    constraints: BoxConstraints(maxHeight: 300),
                    showSelectedItems: true,
                    itemBuilder: (context, item, isSelected) {
                        return Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Text(
                                item,
                                style: TextStyle(fontSize: 16),
                            ),
                        );
                    },
                ),
                items: departments,
                dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                        labelText: "Select Department",
                        prefixIcon: Icon(Icons.school),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                ),
                selectedItem: selectedDepartment,
                onChanged: (String? newValue) {
                    setState(() {
                        selectedDepartment = newValue; // Update selected department
                    });
                },
            ),
        );
    }

    Widget _buildYearDropdown() {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: DropdownSearch<String>(
                popupProps: PopupProps.menu(
                    constraints: BoxConstraints(maxHeight: 200),
                    showSelectedItems: true,
                    itemBuilder: (context, item, isSelected) {
                        return Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Text(
                                item,
                                style: TextStyle(fontSize: 16),
                            ),
                        );
                    },
                ),
                items: years,
                dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                        labelText: "Select Year",
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                ),
                selectedItem: selectedYear,
                onChanged: (String? newValue) {
                    setState(() {
                        selectedYear = newValue;
                    });
                },
            ),
        );
    }

    void _showEditProfileDialog() {
        showDialog(
            context: context,
            builder: (context) {
                return AlertDialog(
                    title: Row(
                        children: [
                            Icon(Icons.edit, color: Colors.blue[800]),
                            SizedBox(width: 8),
                            Text('Edit Profile'),
                        ],
                    ),
                    content: SingleChildScrollView(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                                _buildEditField('Phone Number', phoneController, Icons.phone),
                                _buildCollegeDropdown(),
                                _buildDepartmentDropdown(),
                                _buildYearDropdown(),
                            ],
                        ),
                    ),
                    actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Cancel'),
                        ),
                        ElevatedButton(
                            onPressed: () {
                                updateProfile();
                                Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[800],
                            ),
                            child: Text('Save'),
                        ),
                    ],
                );
            },
        );
    }

    Widget _buildEditField(
        String label,
        TextEditingController controller,
        IconData icon, {
        int maxLines = 1,
        String? hintText,
    }) {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
                controller: controller,
                maxLines: maxLines,
                decoration: InputDecoration(
                    labelText: label,
                    prefixIcon: Icon(icon),
                    hintText: hintText,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                    ),
                ),
            ),
        );
    }

    Widget _buildAuthScreen() {
        return Stack(
            children: [
                // Glass effect header
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                    ),
                    child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(24),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: isDarkMode 
                                        ? [
                                            Color(0xFF4C4DDC),
                                            Color(0xFF1A1A2E),
                                        ]
                                        : [
                                            Colors.blue[400]!,
                                            Colors.blue[100]!,
                                        ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                ),
                            ),
                            child: SafeArea(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 8,
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white.withOpacity(0.15),
                                                        borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    child: Row(
                                                        children: [
                                                            Icon(
                                                                Icons.person_outline,
                                                                color: Colors.white,
                                                                size: 16,
                                                            ),
                                                            SizedBox(width: 8),
                                                            Text(
                                                                isSignUp ? 'SIGN UP' : 'SIGN IN',
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 14,
                                                                    letterSpacing: 0.3,
                                                                ),
                                                            ),
                                                        ],
                                                    ),
                                                ),
                                                _buildThemeToggle(),
                                            ],
                                        ),
                                        SizedBox(height: 40),
                                        Text(
                                            isSignUp ? 'Create\nAccount' : 'Welcome\nBack',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                                height: 1.2,
                                            ),
                                        ).animate()
                                            .fadeIn(duration: 600.ms)
                                            .slideY(begin: 0.2),
                                        SizedBox(height: 8),
                                        Text(
                                            isSignUp 
                                                ? 'Sign up to get started!'
                                                : 'Sign in to continue',
                                            style: TextStyle(
                                                color: Colors.white.withOpacity(0.8),
                                                fontSize: 16,
                                            ),
                                        ).animate()
                                            .fadeIn(duration: 600.ms, delay: 200.ms)
                                            .slideY(begin: 0.2),
                                    ],
                                ),
                            ),
                        ),
                    ),
                ),

                // Form content
                Padding(
                    padding: EdgeInsets.only(top: 280),
                    child: SingleChildScrollView(
                        child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Column(
                                children: [
                                    if (isSignUp) 
                                        _buildAnimatedTextField(
                                            controller: usernameController,
                                            icon: Icons.person_outline,
                                            label: 'Username',
                                            delay: 0,
                                        ),
                                    SizedBox(height: isSignUp ? 16 : 0),
                                    _buildAnimatedTextField(
                                        controller: emailController,
                                        icon: Icons.email_outlined,
                                        label: 'Email',
                                        delay: isSignUp ? 200 : 0,
                                    ),
                                    SizedBox(height: 16),
                                    _buildAnimatedTextField(
                                        controller: passwordController,
                                        icon: Icons.lock_outline,
                                        label: 'Password',
                                        isPassword: true,
                                        delay: isSignUp ? 400 : 200,
                                    ),
                                    SizedBox(height: 24),

                                    // Sign In/Sign Up Button
                                    Container(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                            onPressed: isSignUp ? signUp : signIn,
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
                                                padding: EdgeInsets.symmetric(vertical: 16),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                ),
                                                elevation: 8,
                                            ),
                                            child: Text(
                                                isSignUp ? 'Create Account' : 'Sign In',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                ),
                                            ),
                                        ),
                                    ).animate()
                                        .fadeIn(duration: 600.ms, delay: 600.ms)
                                        .slideY(begin: 0.2),

                                    SizedBox(height: 24),

                                    // Toggle Sign In/Sign Up
                                    TextButton(
                                        onPressed: () {
                                            setState(() {
                                                isSignUp = !isSignUp;
                                            });
                                        },
                                        child: Text.rich(
                                            TextSpan(
                                                children: [
                                                    TextSpan(
                                                        text: isSignUp 
                                                            ? 'Already have an account? '
                                                            : 'Don\'t have an account? ',
                                                        style: TextStyle(
                                                            color: isDarkMode ? Colors.white70 : Colors.grey[600],
                                                        ),
                                                    ),
                                                    TextSpan(
                                                        text: isSignUp ? 'Sign In' : 'Sign Up',
                                                        style: TextStyle(
                                                            color: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue[700],
                                                            fontWeight: FontWeight.bold,
                                                        ),
                                                    ),
                                                ],
                                            ),
                                        ),
                                    ).animate()
                                        .fadeIn(duration: 600.ms, delay: 800.ms),

                                    if (!isSignUp) ...[
                                        SizedBox(height: 16),
                                        TextButton(
                                            onPressed: resetPassword,
                                            child: Text(
                                                'Forgot Password?',
                                                style: TextStyle(
                                                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                                                ),
                                            ),
                                        ).animate()
                                            .fadeIn(duration: 600.ms, delay: 1000.ms),
                                    ],
                                ],
                            ),
                        ),
                    ),
                ),
            ],
        );
    }

    Widget _buildAnimatedTextField({
        required TextEditingController controller,
        required IconData icon,
        required String label,
        bool isPassword = false,
        required int delay,
    }) {
        final darkInputBgColor = Color(0xFF2A2A40);
        final darkPrimaryColor = Colors.blue[400]!;

        return Container(
            decoration: BoxDecoration(
                color: isDarkMode ? darkInputBgColor : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: isDarkMode 
                    ? Border.all(color: darkPrimaryColor.withOpacity(0.2))
                    : null,
            ),
            child: TextField(
                controller: controller,
                obscureText: isPassword,
                style: TextStyle(
                    color: isDarkMode ? Colors.grey[100] : Colors.black,
                ),
                decoration: InputDecoration(
                    prefixIcon: Icon(
                        icon,
                        color: isDarkMode ? darkPrimaryColor : Colors.blue[600],
                    ),
                    labelText: label,
                    labelStyle: TextStyle(
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                ),
            ),
        )
            .animate()
            .fadeIn(duration: 500.ms, delay: delay.ms)
            .slideX(begin: -0.2);
    }

    Widget _buildProfileInfo(IconData icon, String text) {
        return Row(
            children: [
                Icon(icon, size: 20, color: Colors.blueAccent),
                SizedBox(width: 10),
                Expanded(child: Text(text, style: TextStyle(fontSize: 18))),
            ],
        );
    }

    Widget _buildThemeToggle() {
        return Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDarkMode 
                    ? Colors.white.withOpacity(0.15)
                    : Colors.blue.withOpacity(0.15),
            ),
            child: IconButton(
                icon: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: Colors.white,
                ),
                onPressed: _toggleTheme,
            ),
        );
    }

    Widget _buildLogoutButton() {
        return ElevatedButton(
            onPressed: logout,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.9),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
            ),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                    Icon(Icons.logout, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                        'Logout',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                        ),
                    ),
                ],
            ),
        ).animate()
            .fadeIn(delay: 1200.ms)
            .scale(delay: 1200.ms)
            .shimmer(delay: 1200.ms);
    }

    void _showSuccessMessage(String message, IconData icon) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                duration: Duration(seconds: 4),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: isDarkMode ? Color(0xFF2A2A40) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                            ),
                        ],
                    ),
                    child: Row(
                        children: [
                            Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                    icon,
                                    color: Colors.green,
                                    size: 24,
                                ),
                            ).animate()
                                .scale(duration: 300.ms)
                                .then()
                                .shake(duration: 500.ms),
                            SizedBox(width: 16),
                            Expanded(
                                child: Text(
                                    message,
                                    style: TextStyle(
                                        color: isDarkMode ? Colors.white : Colors.black87,
                                        fontSize: 16,
                                    ),
                                ),
                            ),
                        ],
                    ),
                ).animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 1, end: 0),
            ),
        );
    }

    Widget _buildStatCard(String title, String value, IconData icon, Color color) {
        return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    Icon(icon, color: color),
                    SizedBox(height: 8),
                    Text(
                        value,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                        ),
                    ),
                    SizedBox(height: 4),
                    Text(
                        title,
                        style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode ? Colors.white70 : Colors.grey[600],
                        ),
                    ),
                ],
            ),
        );
    }

    // Add this method before the _downloadEventData method
    String _formatTimestamp(dynamic timestamp) {
        if (timestamp == null) return 'Not available';
        DateTime dateTime = (timestamp as Timestamp).toDate();
        return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }

    Future<void> _downloadEventData() async {
        try {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                    return Center(child: CircularProgressIndicator());
                },
            );

            // Get all events
            final eventsSnapshot = await FirebaseFirestore.instance
                .collection('events')
                .get();

            // Fetch registration details for each event
            Map<String, List<Map<String, dynamic>>> eventRegistrationsMap = {};
            for (var eventDoc in eventsSnapshot.docs) {
                String eventId = eventDoc.id;
                try {
                    final registrationsSnapshot = await FirebaseFirestore.instance
                        .collection('events')
                        .doc(eventId)
                        .collection('registrations')
                        .where(FieldPath.documentId, isNotEqualTo: '_info')  // Exclude _info document
                        .get();

                    eventRegistrationsMap[eventId] = registrationsSnapshot.docs
                        .map((doc) => doc.data())
                        .toList();
                } catch (e) {
                    print('Error fetching registrations for event $eventId: $e');
                    eventRegistrationsMap[eventId] = [];
                }
            }

            final pdf = pw.Document();

            // Define styles
            final baseStyle = pw.TextStyle(
                font: pw.Font.helvetica(),
                fontSize: 10,
                color: PdfColors.black
            );

            final titleStyle = baseStyle.copyWith(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue900
            );

            final headerStyle = baseStyle.copyWith(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800
            );

            final subHeaderStyle = baseStyle.copyWith(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue700
            );

            final normalStyle = baseStyle;
            final emphasisStyle = baseStyle.copyWith(fontWeight: pw.FontWeight.bold);

            // Calculate total statistics
            int totalRegistrations = 0;
            double totalRevenue = 0;
            Set<String> uniqueColleges = {};
            Set<String> uniqueDepartments = {};

            for (var eventDoc in eventsSnapshot.docs) {
                final eventData = eventDoc.data();
                final registrations = eventRegistrationsMap[eventDoc.id] ?? [];
                final price = (eventData['price'] as num?)?.toInt() ?? 0;
                totalRegistrations += registrations.length;
                totalRevenue += price * registrations.length;

                for (var reg in registrations) {
                    if (reg['college'] != null) uniqueColleges.add(reg['college']);
                    if (reg['department'] != null) uniqueDepartments.add(reg['department']);
                }
            }

            // Create PDF
            pdf.addPage(
                pw.MultiPage(
                    pageFormat: PdfPageFormat.a4,
                    margin: pw.EdgeInsets.all(40),
                    header: (context) {
                        return pw.Container(
                            padding: pw.EdgeInsets.only(bottom: 20),
                            decoration: pw.BoxDecoration(
                                border: pw.Border(bottom: pw.BorderSide(color: PdfColors.blue200))
                            ),
                            child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                children: [
                                    pw.Text(
                                        'Events Report',
                                        style: titleStyle
                                    ),
                                    pw.Text(
                                        DateTime.now().toString().split('.')[0],
                                        style: baseStyle.copyWith(color: PdfColors.grey700)
                                    ),
                                ]
                            )
                        );
                    },
                    footer: (context) {
                        return pw.Container(
                            alignment: pw.Alignment.centerRight,
                            margin: pw.EdgeInsets.only(top: 10),
                            child: pw.Text(
                                'Page ${context.pageNumber} of ${context.pagesCount}',
                                style: baseStyle.copyWith(color: PdfColors.grey700)
                            )
                        );
                    },
                    build: (context) {
                        return [
                            // Executive Summary
                            pw.Container(
                                padding: pw.EdgeInsets.all(15),
                                margin: pw.EdgeInsets.only(bottom: 20),
                                decoration: pw.BoxDecoration(
                                    color: PdfColors.blue50,
                                    borderRadius: pw.BorderRadius.circular(8)
                                ),
                                child: pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    children: [
                                        pw.Text('Executive Summary', style: headerStyle),
                                        pw.SizedBox(height: 10),
                                        pw.Row(
                                            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                                            children: [
                                                _buildSummaryItem('Total Events', '${eventsSnapshot.docs.length}', normalStyle, emphasisStyle),
                                                _buildSummaryItem('Total Registrations', '$totalRegistrations', normalStyle, emphasisStyle),
                                                _buildSummaryItem('Total Revenue', 'Rs. ${totalRevenue.toStringAsFixed(2)}', normalStyle, emphasisStyle),
                                                _buildSummaryItem('Unique Colleges', '${uniqueColleges.length}', normalStyle, emphasisStyle),
                                            ]
                                        ),
                                    ]
                                )
                            ),

                            // Events Details
                            ...eventsSnapshot.docs.map((eventDoc) {
                                final eventData = eventDoc.data();
                                final eventId = eventDoc.id;
                                final registrations = eventRegistrationsMap[eventId] ?? [];
                                final eventDate = (eventData['date'] as Timestamp).toDate();

                                return [
                                    pw.Container(
                                        margin: pw.EdgeInsets.only(bottom: 20),
                                        decoration: pw.BoxDecoration(
                                            border: pw.Border.all(color: PdfColors.blue200),
                                            borderRadius: pw.BorderRadius.circular(8)
                                        ),
                                        child: pw.Column(
                                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                                            children: [
                                                // Event Header
                                                pw.Container(
                                                    padding: pw.EdgeInsets.all(10),
                                                    decoration: pw.BoxDecoration(
                                                        color: PdfColors.blue100,
                                                        borderRadius: pw.BorderRadius.vertical(
                                                            top: pw.Radius.circular(8)
                                                        )
                                                    ),
                                                    child: pw.Row(
                                                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                                        children: [
                                                            pw.Text(
                                                                eventData['title'] ?? 'Untitled Event',
                                                                style: subHeaderStyle
                                                            ),
                                                            pw.Text(
                                                                'Type: ${eventData['type'] ?? 'N/A'}',
                                                                style: normalStyle.copyWith(color: PdfColors.blue700)
                                                            ),
                                                        ]
                                                    )
                                                ),

                                                pw.Padding(
                                                    padding: pw.EdgeInsets.all(10),
                                                    child: pw.Column(
                                                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                                                        children: [
                                                            // Event Details Grid
                                                            pw.Row(
                                                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                    _buildEventDetail('Date', eventDate.toString().split('.')[0], normalStyle),
                                                                    _buildEventDetail('Price', 'Rs. ${eventData['price'] ?? 0}', normalStyle),
                                                                    _buildEventDetail('Points', '${eventData['points'] ?? 0}', normalStyle),
                                                                ]
                                                            ),
                                                            pw.SizedBox(height: 10),
                                                            pw.Row(
                                                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                    _buildEventDetail('Location', eventData['location'] ?? 'N/A', normalStyle),
                                                                    _buildEventDetail('Capacity', '${eventData['capacity'] ?? 0}', normalStyle),
                                                                    _buildEventDetail('Registrations', '${registrations.length}', normalStyle),
                                                                ]
                                                            ),

                                                            // Registrations Section
                                                            if (registrations.isNotEmpty) ...[
                                                                pw.SizedBox(height: 15),
                                                                pw.Divider(color: PdfColors.blue200),
                                                                pw.SizedBox(height: 10),
                                                                pw.Text('Registrations', style: subHeaderStyle),
                                                                pw.SizedBox(height: 10),
                                                                pw.Table(
                                                                    border: pw.TableBorder.all(color: PdfColors.blue200),
                                                                    children: [
                                                                        // Table Header
                                                                        pw.TableRow(
                                                                            decoration: pw.BoxDecoration(color: PdfColors.blue50),
                                                                            children: [
                                                                                _buildTableCell('Name', isHeader: true),
                                                                                _buildTableCell('Email', isHeader: true),
                                                                                _buildTableCell('Phone', isHeader: true),
                                                                                _buildTableCell('College', isHeader: true),
                                                                                _buildTableCell('Department', isHeader: true),
                                                                                _buildTableCell('Year', isHeader: true),
                                                                                if (eventData['hasSpecialPrices'] == true)
                                                                                    _buildTableCell('Price Category', isHeader: true),
                                                                                if (eventData['hasReferralId'] == true)
                                                                                    _buildTableCell('Referral ID', isHeader: true),
                                                                                _buildTableCell('Transaction ID', isHeader: true),
                                                                                _buildTableCell('Accommodation', isHeader: true),
                                                                                _buildTableCell('Registration Date', isHeader: true),
                                                                            ]
                                                                        ),
                                                                        // Table Rows
                                                                        ...registrations.map((reg) => pw.TableRow(
                                                                            children: [
                                                                                _buildTableCell(reg['name'] ?? 'N/A'),
                                                                                _buildTableCell(reg['email'] ?? 'N/A'),
                                                                                _buildTableCell(reg['phone'] ?? 'N/A'),
                                                                                _buildTableCell(reg['college'] ?? 'N/A'),
                                                                                _buildTableCell(reg['department'] ?? 'N/A'),
                                                                                _buildTableCell(reg['year'] ?? 'N/A'),
                                                                                if (eventData['hasSpecialPrices'] == true)
                                                                                    _buildTableCell(reg['priceCategory']?['name'] ?? 'N/A'),
                                                                                if (eventData['hasReferralId'] == true)
                                                                                    _buildTableCell(reg['referralId'] ?? 'N/A'),
                                                                                _buildTableCell(reg['transaction_id'] ?? 'N/A'),
                                                                                _buildTableCell(reg['needsAccommodation'] == true ? 'Yes' : 'No'),
                                                                                _buildTableCell(_formatTimestamp(reg['registeredAt'])),
                                                                            ]
                                                                        )).toList(),
                                                                    ]
                                                                ),
                                                            ],
                                                        ]
                                                    )
                                                ),
                                            ]
                                        )
                                    ),
                                    pw.SizedBox(height: 20),
                                ];
                            }).expand((x) => x).toList(),
                        ];
                    }
                )
            );

            final bytes = await pdf.save();
            Navigator.pop(context); // Close loading dialog

            if (kIsWeb) {
                final blob = html.Blob([bytes], 'application/pdf');
                final url = html.Url.createObjectUrlFromBlob(blob);
                html.window.open(url, '_blank');
                html.Url.revokeObjectUrl(url);
            } else {
                final directory = await getApplicationDocumentsDirectory();
                final file = File('${directory.path}/events_report.pdf');
                await file.writeAsBytes(bytes);
                await OpenFile.open(file.path);
            }

        } catch (e) {
            print('Error generating PDF: $e');
            Navigator.pop(context); // Close loading dialog
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error generating PDF: $e'))
            );
        }
    }

    // Helper methods for PDF generation
    pw.Widget _buildSummaryItem(String label, String value, pw.TextStyle normalStyle, pw.TextStyle emphasisStyle) {
        return pw.Container(
            padding: pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius: pw.BorderRadius.circular(4),
                border: pw.Border.all(color: PdfColors.blue200)
            ),
            child: pw.Column(
                children: [
                    pw.Text(value, style: emphasisStyle.copyWith(fontSize: 16)),
                    pw.SizedBox(height: 4),
                    pw.Text(label, style: normalStyle),
                ],
            ),
        );
    }

    pw.Widget _buildEventDetail(String label, String value, pw.TextStyle style) {
        return pw.Container(
            width: 150,
            padding: pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(4)
            ),
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                    pw.Text(
                        label,
                        style: style.copyWith(color: PdfColors.grey700)
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                        value,
                        style: style.copyWith(fontWeight: pw.FontWeight.bold)
                    ),
                ]
            )
        );
    }

    pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
        return pw.Container(
            padding: pw.EdgeInsets.all(6),
            child: pw.Text(
                text,
                style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
                    color: isHeader ? PdfColors.blue900 : PdfColors.black
                )
            )
        );
    }

    void _showEditEventDialog(BuildContext context, Map<String, dynamic> eventData) {
        final _formKey = GlobalKey<FormState>();
        final _titleController = TextEditingController(text: eventData['title']);
        final _descriptionController = TextEditingController(text: eventData['description']);
        final _locationController = TextEditingController(text: eventData['location']);
        final _priceController = TextEditingController(text: eventData['price'].toString());
        final _pointsController = TextEditingController(text: eventData['points'].toString());
        final _capacityController = TextEditingController(text: eventData['capacity'].toString());
        String _selectedType = eventData['type'];
        DateTime _selectedDate = (eventData['date'] as Timestamp).toDate();
        bool _hasSpecialPrices = eventData['hasSpecialPrices'] ?? false;
        List<Map<String, dynamic>> _specialPrices = List<Map<String, dynamic>>.from(
            eventData['specialPrices'] ?? [
                {'name': 'IEEE Member', 'amount': 0},
                {'name': 'Non IEEE Member', 'amount': 0}
            ]
        );

        showDialog(
            context: context,
            builder: (context) {
                return StatefulBuilder(
                    builder: (context, setState) {
                        return Dialog(
                            backgroundColor: isDarkMode ? Color(0xFF252542) : Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                constraints: BoxConstraints(maxWidth: 600),
                                child: SingleChildScrollView(
                                    padding: EdgeInsets.all(24),
                                    child: Form(
                                        key: _formKey,
                child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                    children: [
                                                // Header
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Text(
                                                            'Edit Event',
                                                            style: TextStyle(
                                                                fontSize: 24,
                                                                fontWeight: FontWeight.bold,
                                                                color: isDarkMode ? Colors.white : Colors.black,
                                                            ),
                                                        ),
                                                        IconButton(
                                                            icon: Icon(Icons.close),
                                                            onPressed: () => Navigator.pop(context),
                                                            color: isDarkMode ? Colors.white60 : Colors.grey[600],
                                                        ),
                                                    ],
                                                ),
                                                SizedBox(height: 24),

                                                // Basic Details Section
                                                Text(
                                                    'Basic Details',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: isDarkMode ? Colors.white : Colors.black,
                                                    ),
                                                ),
                                                SizedBox(height: 16),
                                                _buildFormField(
                                                    controller: _titleController,
                                                    label: 'Event Title',
                                                    icon: Icons.title,
                                                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                                                    isDarkMode: isDarkMode,
                                                ),
                                                SizedBox(height: 16),
                                                _buildFormField(
                                                    controller: _descriptionController,
                                                    label: 'Description',
                                                    icon: Icons.description,
                                                    maxLines: 3,
                                                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                                                    isDarkMode: isDarkMode,
                                                ),
                                                SizedBox(height: 16),
                                                _buildDropdownField(
                                                    label: 'Event Type',
                                                    value: _selectedType,
                                                    items: ['Workshop', 'Seminar', 'Conference', 'Hackathon'],
                                                    onChanged: (value) => setState(() => _selectedType = value!),
                                                    icon: Icons.category,
                                                    isDarkMode: isDarkMode,
                                                ),
                                                SizedBox(height: 16),
                                                _buildDatePicker(
                                                    context: context,
                                                    selectedDate: _selectedDate,
                                                    onDateSelected: (date) => setState(() => _selectedDate = date),
                                                    isDarkMode: isDarkMode,
                                                ),

                                                SizedBox(height: 24),
                                                // Location and Capacity Section
                                                Text(
                                                    'Location & Capacity',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: isDarkMode ? Colors.white : Colors.black,
                                                    ),
                                                ),
                                                SizedBox(height: 16),
                                                _buildFormField(
                                                    controller: _locationController,
                                                    label: 'Location',
                                                    icon: Icons.location_on,
                                                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                                                    isDarkMode: isDarkMode,
                                                ),
                                                SizedBox(height: 16),
                                                _buildFormField(
                                                    controller: _capacityController,
                                                    label: 'Capacity',
                                                    icon: Icons.people,
                                                    keyboardType: TextInputType.number,
                                                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                                                    isDarkMode: isDarkMode,
                                                ),

                                                SizedBox(height: 24),
                                                // Price and Points Section
                                                Text(
                                                    'Price & Points',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: isDarkMode ? Colors.white : Colors.black,
                                                    ),
                                                ),
                                                SizedBox(height: 16),
                                                Row(
                                                    children: [
                                                        Expanded(
                                                            child: _buildFormField(
                                                                controller: _priceController,
                                                                label: 'Price (₹)',
                                                                icon: Icons.currency_rupee,
                                                                keyboardType: TextInputType.number,
                                                                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                                                                isDarkMode: isDarkMode,
                                                            ),
                                                        ),
                                                        SizedBox(width: 16),
                                                        Expanded(
                                                            child: _buildFormField(
                                                                controller: _pointsController,
                                                                label: 'Points',
                                                                icon: Icons.star,
                                                                keyboardType: TextInputType.number,
                                                                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                                                                isDarkMode: isDarkMode,
                                                            ),
                                                        ),
                                                    ],
                                                ),

                                                // Special Prices Section
                                                SizedBox(height: 24),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Text(
                                                            'Special Prices',
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.bold,
                                                                color: isDarkMode ? Colors.white : Colors.black,
                                                            ),
                                                        ),
                                                        Switch(
                                                            value: _hasSpecialPrices,
                                                            onChanged: (value) {
                                                                setState(() {
                                                                    _hasSpecialPrices = value;
                                                                });
                                                            },
                                                            activeColor: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                                                        ),
                                                    ],
                                                ),
                                                if (_hasSpecialPrices) ...[
                                                    SizedBox(height: 16),
                                                    ..._specialPrices.asMap().entries.map((entry) {
                                                        int index = entry.key;
                                                        Map<String, dynamic> price = entry.value;
                                                        return Card(
                                                            margin: EdgeInsets.only(bottom: 16),
                                                            color: isDarkMode ? Color(0xFF1A1A2E) : Colors.grey[100],
                                                            child: Padding(
                                                                padding: EdgeInsets.all(16),
                                                                child: Column(
                                                                    children: [
                                                                        Row(
                                                                            children: [
                                                                                Expanded(
                                                                                    child: _buildFormField(
                                                                                        controller: TextEditingController(text: price['name']),
                                                                                        label: 'Category Name',
                                                                                        icon: Icons.label,
                                                                                        onChanged: (value) {
                                                                                            setState(() {
                                                                                                _specialPrices[index]['name'] = value;
                                                                                            });
                                                                                        },
                                                                                        isDarkMode: isDarkMode,
                                                                                    ),
                                                                                ),
                                                                                SizedBox(width: 8),
                                                                                IconButton(
                                                                                    icon: Icon(
                                                                                        Icons.delete,
                                                                                        color: Colors.red[400],
                                                                                    ),
                                                                                    onPressed: () {
                                                                                        setState(() {
                                                                                            _specialPrices.removeAt(index);
                                                                                        });
                                                                                    },
                                                                                ),
                                                                            ],
                                                                        ),
                                                                        SizedBox(height: 8),
                                                                        _buildFormField(
                                                                            controller: TextEditingController(text: price['amount'].toString()),
                                                                            label: 'Amount',
                                                                            icon: Icons.currency_rupee,
                                                                            keyboardType: TextInputType.number,
                                                                            onChanged: (value) {
                                                                                setState(() {
                                                                                    _specialPrices[index]['amount'] = int.tryParse(value) ?? 0;
                                                                                });
                                                                            },
                                                                            isDarkMode: isDarkMode,
                                                                        ),
                                                                    ],
                                                                ),
                                                            ),
                                                        );
                                                    }).toList(),
                                                    SizedBox(height: 16),
                                                    Center(
                                                        child: TextButton.icon(
                                                            onPressed: () {
                                                                setState(() {
                                                                    _specialPrices.add({
                                                                        'name': 'New Category',
                                                                        'amount': 0
                                                                    });
                                                                });
                                                            },
                                                            icon: Icon(Icons.add),
                                                            label: Text('Add Price Category'),
                                                        ),
                                                    ),
                                                ],

                                                // Action Buttons
                                                SizedBox(height: 32),
                                                Row(
                                                    children: [
                                                        Expanded(
                                                            child: TextButton(
                                                                onPressed: () => Navigator.pop(context),
                                                                style: TextButton.styleFrom(
                                                                    padding: EdgeInsets.symmetric(vertical: 16),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(12),
                                                                    ),
                                                                ),
                                                                child: Text(
                                                                    'Cancel',
                                                                    style: TextStyle(
                                                                        fontSize: 16,
                                                                        color: isDarkMode ? Colors.white70 : Colors.grey[700],
                                                                    ),
                                                                ),
                                                            ),
                                                        ),
                                                        SizedBox(width: 16),
                                                        Expanded(
                                                            child: ElevatedButton(
                                                                onPressed: () async {
                                                                    if (_formKey.currentState!.validate()) {
                                                                        try {
                                                                            // Show loading
                                                                            showDialog(
                                                                                context: context,
                                                                                barrierDismissible: false,
                                                                                builder: (context) => Center(
                                                                                    child: CircularProgressIndicator(),
                                                                                ),
                                                                            );

                                                                            // Update event data
                                                                            await FirebaseFirestore.instance
                                                                                .collection('events')
                                                                                .doc(eventData['id'])
                                                                                .update({
                                                                                    'title': _titleController.text,
                                                                                    'description': _descriptionController.text,
                                                                                    'type': _selectedType,
                                                                                    'date': Timestamp.fromDate(_selectedDate),
                                                                                    'location': _locationController.text,
                                                                                    'price': int.parse(_priceController.text),
                                                                                    'points': int.parse(_pointsController.text),
                                                                                    'capacity': int.parse(_capacityController.text),
                                                                                    'hasSpecialPrices': _hasSpecialPrices,
                                                                                    'specialPrices': _hasSpecialPrices ? _specialPrices : null,
                                                                                });

                                                                            // Close dialogs and show success
                                                                            Navigator.pop(context); // Close loading
                                                                            Navigator.pop(context); // Close edit form
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                                SnackBar(
                                                                                    content: Text('Event updated successfully'),
                                                                                    backgroundColor: Colors.green,
                                                                                ),
                                                                            );
                                                                        } catch (e) {
                                                                            Navigator.pop(context); // Close loading
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                                SnackBar(
                                                                                    content: Text('Error updating event: $e'),
                                                                                    backgroundColor: Colors.red,
                                                                                ),
                                                                            );
                                                                        }
                                                                    }
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                    backgroundColor: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                                                                    padding: EdgeInsets.symmetric(vertical: 16),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(12),
                                                                    ),
                                                                ),
                                                                child: Text(
                                                                    'Save Changes',
                                                                    style: TextStyle(
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.white,
                                                                    ),
                                                                ),
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                            ],
                                        ),
                                    ),
                                ),
                            ),
                        );
                    },
                );
            },
        );
    }

    Widget _buildFormField({
        required TextEditingController controller,
        required String label,
        required IconData icon,
        TextInputType? keyboardType,
        String? Function(String?)? validator,
        void Function(String)? onChanged,
        int maxLines = 1,
        required bool isDarkMode,
    }) {
        return TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            validator: validator,
            onChanged: onChanged,
            style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.grey[700],
                ),
                prefixIcon: Icon(
                    icon,
                    color: isDarkMode ? Colors.white38 : Colors.grey[600],
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: isDarkMode ? Colors.white24 : Colors.grey[300]!,
                    ),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                        width: 2,
                    ),
                ),
                filled: true,
                fillColor: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[100],
            ),
        );
    }

    Widget _buildDropdownField({
        required String label,
        required String value,
        required List<String> items,
        required void Function(String?) onChanged,
        required IconData icon,
        required bool isDarkMode,
    }) {
        return DropdownButtonFormField<String>(
            value: value,
            items: items.map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
            )).toList(),
            onChanged: onChanged,
            style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
            ),
            dropdownColor: isDarkMode ? Color(0xFF1A1A2E) : Colors.white,
            decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.grey[700],
                ),
                prefixIcon: Icon(
                    icon,
                    color: isDarkMode ? Colors.white38 : Colors.grey[600],
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: isDarkMode ? Colors.white24 : Colors.grey[300]!,
                    ),
                ),
                filled: true,
                fillColor: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[100],
            ),
        );
    }

    Widget _buildDatePicker({
        required BuildContext context,
        required DateTime selectedDate,
        required Function(DateTime) onDateSelected,
        required bool isDarkMode,
    }) {
        return InkWell(
            onTap: () async {
                final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (picked != null) {
                    onDateSelected(picked);
                }
            },
            child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: isDarkMode ? Colors.white24 : Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[100],
                ),
                child: Row(
                    children: [
                        Icon(
                            Icons.calendar_today,
                            color: isDarkMode ? Colors.white38 : Colors.grey[600],
                        ),
                        SizedBox(width: 12),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                    'Event Date',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: isDarkMode ? Colors.white70 : Colors.grey[700],
                                    ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: isDarkMode ? Colors.white : Colors.black,
                                    ),
                                ),
                            ],
                        ),
                    ],
                ),
            ),
        );
    }

    // Add this function to check if user is an organizer
    Future<bool> _isUserOrganizer() async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null || user.email == null) return false;

        try {
            final organizerSnapshot = await FirebaseFirestore.instance
                .collection('organizers')
                .where('email', isEqualTo: user.email)
                .get();

            return organizerSnapshot.docs.isNotEmpty;
        } catch (e) {
            print('Error checking organizer status: $e');
            return false;
        }
    }

    // Add this function to handle adding new organizers
    void _showAddOrganizerDialog() {
        final _nameController = TextEditingController();
        final _emailController = TextEditingController();
        final _formKey = GlobalKey<FormState>();

        showDialog(
            context: context,
            builder: (context) => Dialog(
                backgroundColor: isDarkMode ? Color(0xFF252542) : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Container(
                    padding: EdgeInsets.all(24),
                    child: Form(
                        key: _formKey,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                                // Header
                                Row(
                                    children: [
                                        Icon(Icons.admin_panel_settings, 
                                            color: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                            'Add New Organizer',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: isDarkMode ? Colors.white : Colors.black,
                                            ),
                                        ),
                                    ],
                                ),
                                SizedBox(height: 24),

                                // Name Field
                                TextFormField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                        labelText: 'Organizer Name',
                                        prefixIcon: Icon(Icons.person),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                        ),
                                    ),
                                    validator: (value) => 
                                        value?.isEmpty ?? true ? 'Please enter organizer name' : null,
                                ),
                                SizedBox(height: 16),

                                // Email Field
                                TextFormField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                        labelText: 'Organizer Email',
                                        prefixIcon: Icon(Icons.email),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                        ),
                                    ),
                                    validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                            return 'Please enter organizer email';
                                        }
                                        if (!value!.contains('@')) {
                                            return 'Please enter a valid email';
                                        }
                                        return null;
                                    },
                                ),
                                SizedBox(height: 24),

                                // Buttons
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                        TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text('Cancel'),
                                        ),
                                        SizedBox(width: 12),
                                        ElevatedButton(
                                            onPressed: () async {
                                                if (_formKey.currentState!.validate()) {
                                                    try {
                                                        // Add organizer to Firestore
                                                        await FirebaseFirestore.instance
                                                            .collection('organizers')
                                                            .add({
                                                                'name': _nameController.text.trim(),
                                                                'email': _emailController.text.trim(),
                                                                'addedAt': FieldValue.serverTimestamp(),
                                                                'addedBy': FirebaseAuth.instance.currentUser?.email,
                                                            });

                                                        Navigator.pop(context);
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                                content: Text('Organizer added successfully!'),
                                                                backgroundColor: Colors.green,
                                                            ),
                                                        );
                                                    } catch (e) {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                                content: Text('Error adding organizer: $e'),
                                                                backgroundColor: Colors.red,
                                                            ),
                                                        );
                                                    }
                                                }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                ),
                                            ),
                                            child: Text('Add Organizer'),
                                        ),
                                    ],
                                ),
                            ],
                        ),
                    ),
                ),
            ),
        );
    }

    Widget _buildOrganizerManagementSection() {
        return Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
                color: isDarkMode ? Color(0xFF252542) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                    ),
                ],
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text(
                                    'Organizer Management',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode ? Colors.white : Colors.black,
                                    ),
                                ),
                                IconButton(
                                    icon: Icon(Icons.person_add),
                                    onPressed: _showAddOrganizerDialog,
                                    tooltip: 'Add New Organizer',
                                ),
                            ],
                        ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('organizers')
                            .snapshots(),
                        builder: (context, snapshot) {
                            if (snapshot.hasError) {
                                return Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text('Error loading organizers'),
                                );
                            }

                            if (!snapshot.hasData) {
                                return Center(child: CircularProgressIndicator());
                            }

                            final organizers = snapshot.data!.docs;

                            return Column(
                                children: [
                                    Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Text(
                                            'Current Organizers',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: isDarkMode ? Colors.white70 : Colors.grey[700],
                                            ),
                                        ),
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: organizers.length,
                                        itemBuilder: (context, index) {
                                            final organizer = organizers[index].data() as Map<String, dynamic>;
                                            return ListTile(
                                                leading: CircleAvatar(
                                                    backgroundColor: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                                                    child: Text(
                                                        organizer['name']?[0].toUpperCase() ?? 'O',
                                                        style: TextStyle(color: Colors.white),
                                                    ),
                                                ),
                                                title: Text(
                                                    organizer['name'] ?? 'Unknown',
                                                    style: TextStyle(
                                                        color: isDarkMode ? Colors.white : Colors.black,
                                                    ),
                                                ),
                                                subtitle: Text(
                                                    organizer['email'] ?? '',
                                                    style: TextStyle(
                                                        color: isDarkMode ? Colors.white70 : Colors.grey[600],
                                                    ),
                                                ),
                                            );
                                        },
                                    ),
                                ],
                            );
                        },
                    ),
                ],
            ),
        );
    }

    // Add this function to check if user is an admin
    Future<bool> _isUserAdmin() async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null || user.email == null) return false;

        try {
            print('Checking admin status for email: ${user.email}'); // Debug print
            final adminSnapshot = await FirebaseFirestore.instance
                .collection('admin')  // Changed from 'admins' to 'admin'
                .where('email', isEqualTo: user.email)
                .get();

            print('Admin docs found: ${adminSnapshot.docs.length}'); // Debug print
            return adminSnapshot.docs.isNotEmpty;
        } catch (e) {
            print('Error checking admin status: $e');
            return false;
        }
    }

    // Add this function to handle adding new admins
    void _showAddAdminDialog() {
        final _emailController = TextEditingController();
        final _formKey = GlobalKey<FormState>();

        showDialog(
            context: context,
            builder: (context) => Dialog(
                backgroundColor: isDarkMode ? Color(0xFF252542) : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Container(
                    padding: EdgeInsets.all(24),
                    child: Form(
                        key: _formKey,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                                // Header
                                Row(
                                    children: [
                                        Icon(Icons.admin_panel_settings, 
                                            color: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                            'Add New Admin',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: isDarkMode ? Colors.white : Colors.black,
                                            ),
                                        ),
                                    ],
                                ),
                                SizedBox(height: 24),

                                // Email Field
                                TextFormField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                        labelText: 'Admin Email',
                                        prefixIcon: Icon(Icons.email),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                        ),
                                    ),
                                    validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                            return 'Please enter admin email';
                                        }
                                        if (!value!.contains('@')) {
                                            return 'Please enter a valid email';
                                        }
                                        return null;
                                    },
                                ),
                                SizedBox(height: 24),

                                // Buttons
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                        TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text('Cancel'),
                                        ),
                                        SizedBox(width: 12),
                                        ElevatedButton(
                                            onPressed: () async {
                                                if (_formKey.currentState!.validate()) {
                                                    try {
                                                        // Add admin to Firestore with just email
                                                        await FirebaseFirestore.instance
                                                            .collection('admin')  // Changed from 'admins' to 'admin'
                                                            .add({
                                                                'email': _emailController.text.trim(),
                                                            });

                                                        Navigator.pop(context);
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                                content: Text('Admin added successfully!'),
                                                                backgroundColor: Colors.green,
                                                            ),
                                                        );
                                                    } catch (e) {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                                content: Text('Error adding admin: $e'),
                                                                backgroundColor: Colors.red,
                                                            ),
                                                        );
                                                    }
                                                }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                ),
                                            ),
                                            child: Text('Add Admin'),
                                        ),
                                    ],
                                ),
                            ],
                        ),
                    ),
                ),
            ),
        );
    }

    Widget _buildAdminManagementSection() {
        return Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
                color: isDarkMode ? Color(0xFF252542) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                    ),
                ],
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text(
                                    'Admin Management',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode ? Colors.white : Colors.black,
                                    ),
                                ),
                                IconButton(
                                    icon: Icon(Icons.person_add),
                                    onPressed: _showAddAdminDialog,
                                    tooltip: 'Add New Admin',
                                ),
                            ],
                        ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('admin')  // Changed from 'admins' to 'admin'
                            .snapshots(),
                        builder: (context, snapshot) {
                            if (snapshot.hasError) {
                                return Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text('Error loading admins'),
                                );
                            }

                            if (!snapshot.hasData) {
                                return Center(child: CircularProgressIndicator());
                            }

                            final admins = snapshot.data!.docs;

                            return Column(
                                children: [
                                    Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Text(
                                            'Current Admins',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: isDarkMode ? Colors.white70 : Colors.grey[700],
                                            ),
                                        ),
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: admins.length,
                                        itemBuilder: (context, index) {
                                            final adminEmail = admins[index].get('email') as String;
                                            return ListTile(
                                                leading: CircleAvatar(
                                                    backgroundColor: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                                                    child: Text(
                                                        adminEmail[0].toUpperCase(),
                                                        style: TextStyle(color: Colors.white),
                                                    ),
                                                ),
                                                title: Text(
                                                    adminEmail,
                                                    style: TextStyle(
                                                        color: isDarkMode ? Colors.white : Colors.black,
                                                    ),
                                                ),
                                            );
                                        },
                                    ),
                                ],
                            );
                        },
                    ),
                ],
            ),
        );
    }

    // Add superadmin check function
    Future<bool> _isUserSuperAdmin() async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null || user.email == null) return false;

        try {
            print('Checking superadmin status for email: ${user.email}'); // Debug print
            final superAdminSnapshot = await FirebaseFirestore.instance
                .collection('superadmin')
                .where('email', isEqualTo: user.email)
                .get();

            print('SuperAdmin docs found: ${superAdminSnapshot.docs.length}'); // Debug print
            return superAdminSnapshot.docs.isNotEmpty;
        } catch (e) {
            print('Error checking superadmin status: $e');
            return false;
        }
    }

    // Add SuperAdmin Section Widget
    Widget _buildSuperAdminSection() {
        return Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
                color: isDarkMode ? Color(0xFF252542) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                    ),
                ],
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text(
                                    'Super Admin Dashboard',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode ? Colors.white : Colors.black,
                                    ),
                                ),
                            ],
                        ),
                    ),
                    // All Events Section with Edit Capability
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('events')
                            .snapshots(),
                        builder: (context, snapshot) {
                            if (snapshot.hasError) {
                                return Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text('Error loading events'),
                                );
                            }

                            if (!snapshot.hasData) {
                                return Center(child: CircularProgressIndicator());
                            }

                            final events = snapshot.data!.docs;

                            return Column(
                                children: [
                                    Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Text(
                                            'All Events (${events.length})',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: isDarkMode ? Colors.white70 : Colors.grey[700],
                                            ),
                                        ),
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: events.length,
                                        itemBuilder: (context, index) {
                                            final event = events[index].data() as Map<String, dynamic>;
                                            event['id'] = events[index].id;
                                            return _buildEventListTile(event);
                                        },
                                    ),
                                ],
                            );
                        },
                    ),
                ],
            ),
        );
    }

    // Add helper method to show event edit dialog
    void _showEventEditDialog(Map<String, dynamic> event) {
        // Navigate to EventDetailsScreen with edit mode
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EventDetailsScreen(
                    eventData: event,
                    isCreated: true,
                    isDarkMode: isDarkMode,
                ),
            ),
        );
    }

    // Add helper method to show delete confirmation
    void _showDeleteEventConfirmation(Map<String, dynamic> event) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: Text('Delete Event'),
                content: Text('Are you sure you want to delete "${event['title']}"? This action cannot be undone.'),
                actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                            try {
                                await FirebaseFirestore.instance
                                    .collection('events')
                                    .doc(event['id'])
                                    .delete();
                                
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Event deleted successfully'),
                                        backgroundColor: Colors.green,
                                    ),
                                );
                            } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Error deleting event: $e'),
                                        backgroundColor: Colors.red,
                                    ),
                                );
                            }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                        ),
                        child: Text('Delete'),
                    ),
                ],
            ),
        );
    }

    // Add this method to toggle featured status
    Future<void> _toggleFeaturedStatus(Map<String, dynamic> event) async {
        try {
            final bool currentStatus = event['isFeatured'] ?? false;
            await FirebaseFirestore.instance
                .collection('events')
                .doc(event['id'])
                .update({
                    'isFeatured': !currentStatus,
                });

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(currentStatus ? 'Event removed from featured' : 'Event marked as featured'),
                    backgroundColor: Colors.green,
                ),
            );
        } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Error updating featured status: $e'),
                    backgroundColor: Colors.red,
                ),
            );
        }
    }

    // Add this method to build event list tile
    Widget _buildEventListTile(Map<String, dynamic> event) {
        final bool isFeatured = event['isFeatured'] ?? false;
        final String title = event['title'] ?? 'Untitled Event';
        final String creatorEmail = event['creatorInfo']?['email'] ?? 'Unknown';
        final Timestamp timestamp = event['date'] as Timestamp;
        final String date = '${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year}';
        
        return ListTile(
            leading: CircleAvatar(
                backgroundColor: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                        Icon(Icons.event, color: Colors.white),
                        if (isFeatured)
                            Positioned(
                                right: -4,
                                bottom: -4,
                                child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: isDarkMode ? Color(0xFF252542) : Colors.white,
                                            width: 1.5,
                                        ),
                                    ),
                                    child: Icon(
                                        Icons.star,
                                        size: 10,
                                        color: Colors.black,
                                    ),
                                ),
                            ),
                    ],
                ),
            ),
            title: Text(
                title,
                style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                        'Created by: $creatorEmail',
                        style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.grey[600],
                            fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                        'Date: $date',
                        style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.grey[600],
                            fontSize: 12,
                        ),
                    ),
                ],
            ),
            trailing: Container(
                width: 100,  // Reduced from 120 to 100
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        SizedBox(
                            width: 32,  // Fixed width for each button container
                            height: 32,
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                                icon: Icon(
                                    isFeatured ? Icons.star : Icons.star_border,
                                    color: isFeatured 
                                        ? Colors.yellow[700]
                                        : (isDarkMode ? Colors.white70 : Colors.grey[600]),
                                    size: 18,  // Reduced from 20 to 18
                                ),
                                onPressed: () => _toggleFeaturedStatus(event),
                                tooltip: isFeatured ? 'Remove from featured' : 'Mark as featured',
                            ),
                        ),
                        SizedBox(
                            width: 32,  // Fixed width for each button container
                            height: 32,
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                                icon: Icon(
                                    Icons.edit,
                                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                                    size: 18,  // Reduced from 20 to 18
                                ),
                                onPressed: () => _showEventEditDialog(event),
                            ),
                        ),
                        SizedBox(
                            width: 32,  // Fixed width for each button container
                            height: 32,
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                                icon: Icon(
                                    Icons.delete,
                                    color: Colors.red[400],
                                    size: 18,  // Reduced from 20 to 18
                                ),
                                onPressed: () => _showDeleteEventConfirmation(event),
                            ),
                        ),
                    ],
                ),
            ),
            onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventDetailsScreen(
                            eventData: event,
                            isCreated: true,
                            isDarkMode: isDarkMode,
                        ),
                    ),
                );
            },
        );
    }
}

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

class EventDetailsScreen extends StatelessWidget {
    final Map<String, dynamic> eventData;
    final bool isCreated;
    final bool isDarkMode;

    EventDetailsScreen({
        required this.eventData,
        required this.isCreated,
        required this.isDarkMode,
    });

    static void _showEditEventDialog(BuildContext context, Map<String, dynamic> eventData) {
        final _formKey = GlobalKey<FormState>();
        final _titleController = TextEditingController(text: eventData['title']);
        final _descriptionController = TextEditingController(text: eventData['description']);
        final _locationController = TextEditingController(text: eventData['location']);
        final _priceController = TextEditingController(text: eventData['price'].toString());
        final _pointsController = TextEditingController(text: eventData['points'].toString());
        final _capacityController = TextEditingController(text: eventData['capacity'].toString());
        String _selectedType = eventData['type'];
        DateTime _selectedDate = (eventData['date'] as Timestamp).toDate();
        bool _hasSpecialPrices = eventData['hasSpecialPrices'] ?? false;
        List<Map<String, dynamic>> _specialPrices = List<Map<String, dynamic>>.from(
            eventData['specialPrices'] ?? [
                {'name': 'IEEE Member', 'amount': 0},
                {'name': 'Non IEEE Member', 'amount': 0}
            ]
        );

        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        showDialog(
            context: context,
            builder: (context) {
                return StatefulBuilder(
                    builder: (context, setState) {
                        return Dialog(
                            backgroundColor: isDarkMode ? Color(0xFF252542) : Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                constraints: BoxConstraints(maxWidth: 600),
                                child: SingleChildScrollView(
                                    padding: EdgeInsets.all(24),
                                    child: Form(
                                        key: _formKey,
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                children: [
                                                // Header
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Text(
                                                            'Edit Event',
                                                            style: TextStyle(
                                                                fontSize: 24,
                                                                fontWeight: FontWeight.bold,
                                                                color: isDarkMode ? Colors.white : Colors.black,
                                                            ),
                                                        ),
                                                        IconButton(
                                                            icon: Icon(Icons.close),
                                                            onPressed: () => Navigator.pop(context),
                                                            color: isDarkMode ? Colors.white60 : Colors.grey[600],
                                                        ),
                                                    ],
                                                ),
                                                SizedBox(height: 24),

                                                // Basic Details Section
                                                Text(
                                                    'Basic Details',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: isDarkMode ? Colors.white : Colors.black,
                                                    ),
                                                ),
                                                SizedBox(height: 16),
                                                _buildFormField(
                                                    controller: _titleController,
                                                    label: 'Event Title',
                                                    icon: Icons.title,
                                                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                                                    isDarkMode: isDarkMode,
                                                ),
                                                SizedBox(height: 16),
                                                _buildFormField(
                                                    controller: _descriptionController,
                                                    label: 'Description',
                                                    icon: Icons.description,
                                                    maxLines: 3,
                                                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                                                    isDarkMode: isDarkMode,
                                                ),
                                                SizedBox(height: 16),
                                                _buildDropdownField(
                                                    label: 'Event Type',
                                                    value: _selectedType,
                                                    items: ['Workshop', 'Seminar', 'Conference', 'Hackathon'],
                                                    onChanged: (value) => setState(() => _selectedType = value!),
                                                    icon: Icons.category,
                                                    isDarkMode: isDarkMode,
                                                ),
                                                SizedBox(height: 16),
                                                _buildDatePicker(
                                                    context: context,
                                                    selectedDate: _selectedDate,
                                                    onDateSelected: (date) => setState(() => _selectedDate = date),
                                                    isDarkMode: isDarkMode,
                                                ),

                                                SizedBox(height: 24),
                                                // Location and Capacity Section
                                                Text(
                                                    'Location & Capacity',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: isDarkMode ? Colors.white : Colors.black,
                                                    ),
                                                ),
                                                SizedBox(height: 16),
                                                _buildFormField(
                                                    controller: _locationController,
                                                    label: 'Location',
                                                    icon: Icons.location_on,
                                                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                                                    isDarkMode: isDarkMode,
                                                ),
                                                SizedBox(height: 16),
                                                _buildFormField(
                                                    controller: _capacityController,
                                                    label: 'Capacity',
                                                    icon: Icons.people,
                                                    keyboardType: TextInputType.number,
                                                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                                                    isDarkMode: isDarkMode,
                                                ),

                                                SizedBox(height: 24),
                                                // Price and Points Section
                                                Text(
                                                    'Price & Points',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: isDarkMode ? Colors.white : Colors.black,
                                                    ),
                                                ),
                                                SizedBox(height: 16),
                                                Row(
                                                    children: [
                                                        Expanded(
                                                            child: _buildFormField(
                                                                controller: _priceController,
                                                                label: 'Price (₹)',
                                                                icon: Icons.currency_rupee,
                                                                keyboardType: TextInputType.number,
                                                                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                                                                isDarkMode: isDarkMode,
                                                            ),
                                                        ),
                                                        SizedBox(width: 16),
                                                        Expanded(
                                                            child: _buildFormField(
                                                                controller: _pointsController,
                                                                label: 'Points',
                                                                icon: Icons.star,
                                                                keyboardType: TextInputType.number,
                                                                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                                                                isDarkMode: isDarkMode,
                                                            ),
                                                        ),
                                                    ],
                                                ),

                                                // Special Prices Section
                                                SizedBox(height: 24),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Text(
                                                            'Special Prices',
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.bold,
                                                                color: isDarkMode ? Colors.white : Colors.black,
                                                            ),
                                                        ),
                                                        Switch(
                                                            value: _hasSpecialPrices,
                                                            onChanged: (value) {
                                                                setState(() {
                                                                    _hasSpecialPrices = value;
                                                                });
                                                            },
                                                            activeColor: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                                                        ),
                                                    ],
                                                ),
                                                if (_hasSpecialPrices) ...[
                                                    SizedBox(height: 16),
                                                    ..._specialPrices.asMap().entries.map((entry) {
                                                        int index = entry.key;
                                                        Map<String, dynamic> price = entry.value;
                                                        return Card(
                                                            margin: EdgeInsets.only(bottom: 16),
                                                            color: isDarkMode ? Color(0xFF1A1A2E) : Colors.grey[100],
                                                            child: Padding(
                                                                padding: EdgeInsets.all(16),
                                                                child: Column(
                                                                    children: [
                                                                        Row(
                                                                            children: [
                                                                                Expanded(
                                                                                    child: _buildFormField(
                                                                                        controller: TextEditingController(text: price['name']),
                                                                                        label: 'Category Name',
                                                                                        icon: Icons.label,
                                                                                        onChanged: (value) {
                                                                                            setState(() {
                                                                                                _specialPrices[index]['name'] = value;
                                                                                            });
                                                                                        },
                                                                                        isDarkMode: isDarkMode,
                                                                                    ),
                                                                                ),
                                                                                SizedBox(width: 8),
                                                                                IconButton(
                                                                                    icon: Icon(
                                                                                        Icons.delete,
                                                                                        color: Colors.red[400],
                                                                                    ),
                                                                                    onPressed: () {
                                                                                        setState(() {
                                                                                            _specialPrices.removeAt(index);
                                                                                        });
                                                                                    },
                                                                                ),
                                                                            ],
                                                                        ),
                                                                        SizedBox(height: 8),
                                                                        _buildFormField(
                                                                            controller: TextEditingController(text: price['amount'].toString()),
                                                                            label: 'Amount',
                                                                            icon: Icons.currency_rupee,
                                                                            keyboardType: TextInputType.number,
                                                                            onChanged: (value) {
                                                                                setState(() {
                                                                                    _specialPrices[index]['amount'] = int.tryParse(value) ?? 0;
                                                                                });
                                                                            },
                                                                            isDarkMode: isDarkMode,
                                                                        ),
                                                                    ],
                                                                ),
                                                            ),
                                                        );
                                                    }).toList(),
                                                    SizedBox(height: 16),
                                                    Center(
                                                        child: TextButton.icon(
                                                            onPressed: () {
                                                                setState(() {
                                                                    _specialPrices.add({
                                                                        'name': 'New Category',
                                                                        'amount': 0
                                                                    });
                                                                });
                                                            },
                                                            icon: Icon(Icons.add),
                                                            label: Text('Add Price Category'),
                                                        ),
                                                    ),
                                                ],

                                                // Action Buttons
                                                SizedBox(height: 32),
                                                Row(
                                                    children: [
                                                        Expanded(
                                                            child: TextButton(
                                                                onPressed: () => Navigator.pop(context),
                                                                style: TextButton.styleFrom(
                                                                    padding: EdgeInsets.symmetric(vertical: 16),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(12),
                                                                    ),
                                                    ),
                                                    child: Text(
                                                                    'Cancel',
                                                        style: TextStyle(
                                                                        fontSize: 16,
                                                                        color: isDarkMode ? Colors.white70 : Colors.grey[700],
                                                                    ),
                                                                ),
                                                            ),
                                                        ),
                                                        SizedBox(width: 16),
                                                        Expanded(
                                                            child: ElevatedButton(
                                                                onPressed: () async {
                                                                    if (_formKey.currentState!.validate()) {
                                                                        try {
                                                                            // Show loading
                                                                            showDialog(
                                                                                context: context,
                                                                                barrierDismissible: false,
                                                                                builder: (context) => Center(
                                                                                    child: CircularProgressIndicator(),
                                                                                ),
                                                                            );

                                                                            // Create updated event data
                                                                            Map<String, dynamic> updatedEventData = {
                                                                                'title': _titleController.text,
                                                                                'description': _descriptionController.text,
                                                                                'type': _selectedType,
                                                                                'date': Timestamp.fromDate(_selectedDate),
                                                                                'location': _locationController.text,
                                                                                'price': int.parse(_priceController.text),
                                                                                'points': int.parse(_pointsController.text),
                                                                                'capacity': int.parse(_capacityController.text),
                                                                                'hasSpecialPrices': _hasSpecialPrices,
                                                                                'specialPrices': _hasSpecialPrices ? _specialPrices : null,
                                                                                'lastUpdated': FieldValue.serverTimestamp(),
                                                                            };

                                                                            // Update event in Firestore
                                                                            await FirebaseFirestore.instance
                                                                                .collection('events')
                                                                                .doc(eventData['id'])
                                                                                .update(updatedEventData);

                                                                            // Update local event data
                                                                            eventData.addAll(updatedEventData);

                                                                            // Close dialogs
                                                                            Navigator.pop(context); // Close loading
                                                                            Navigator.pop(context); // Close edit form

                                                                            // Refresh the event details screen
                                                                            Navigator.pushReplacement(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) => EventDetailsScreen(
                                                                                        eventData: eventData,
                                                                                        isCreated: true,
                                                                                        isDarkMode: isDarkMode,
                                                                                    ),
                                                                                ),
                                                                            );

                                                                            // Show success message
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                                SnackBar(
                                                                                    content: Text('Event updated successfully'),
                                                                                    backgroundColor: Colors.green,
                                                                                ),
                                                                            );
                                                                        } catch (e) {
                                                                            Navigator.pop(context); // Close loading
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                                SnackBar(
                                                                                    content: Text('Error updating event: $e'),
                                                                                    backgroundColor: Colors.red,
                                                                                ),
                                                                            );
                                                                        }
                                                                    }
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                    backgroundColor: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                                                                    padding: EdgeInsets.symmetric(vertical: 16),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(12),
                                                                    ),
                                                                ),
                                                                child: Text(
                                                                    'Save Changes',
                                                                    style: TextStyle(
                                                                        fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                                        color: Colors.white,
                                                        ),
                                                    ),
                                                ),
                                                        ),
                                                    ],
                                                ),
                                            ],
                                        ),
                                    ),
                                ),
                            ),
                        );
                    },
                );
            },
        );
    }

    static Widget _buildFormField({
        required TextEditingController controller,
        required String label,
        required IconData icon,
        TextInputType? keyboardType,
        String? Function(String?)? validator,
        void Function(String)? onChanged,
        int maxLines = 1,
        required bool isDarkMode,
    }) {
        return TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            validator: validator,
            onChanged: onChanged,
            style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.grey[700],
                ),
                prefixIcon: Icon(
                    icon,
                    color: isDarkMode ? Colors.white38 : Colors.grey[600],
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: isDarkMode ? Colors.white24 : Colors.grey[300]!,
                    ),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                        width: 2,
                    ),
                ),
                filled: true,
                fillColor: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[100],
            ),
        );
    }

    static Widget _buildDropdownField({
        required String label,
        required String value,
        required List<String> items,
        required void Function(String?) onChanged,
        required IconData icon,
        required bool isDarkMode,
    }) {
        return DropdownButtonFormField<String>(
            value: value,
            items: items.map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
            )).toList(),
            onChanged: onChanged,
            style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
            ),
            dropdownColor: isDarkMode ? Color(0xFF1A1A2E) : Colors.white,
            decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.grey[700],
                ),
                prefixIcon: Icon(
                    icon,
                    color: isDarkMode ? Colors.white38 : Colors.grey[600],
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: isDarkMode ? Colors.white24 : Colors.grey[300]!,
                    ),
                ),
                filled: true,
                fillColor: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[100],
            ),
        );
    }

    static Widget _buildDatePicker({
        required BuildContext context,
        required DateTime selectedDate,
        required Function(DateTime) onDateSelected,
        required bool isDarkMode,
    }) {
        return InkWell(
            onTap: () async {
                final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (picked != null) {
                    onDateSelected(picked);
                }
            },
            child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: isDarkMode ? Colors.white24 : Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[100],
                ),
                child: Row(
                    children: [
                        Icon(
                            Icons.calendar_today,
                            color: isDarkMode ? Colors.white38 : Colors.grey[600],
                        ),
                        SizedBox(width: 12),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                                Text(
                                    'Event Date',
                                                    style: TextStyle(
                                        fontSize: 12,
                                        color: isDarkMode ? Colors.white70 : Colors.grey[700],
                                    ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: isDarkMode ? Colors.white : Colors.black,
                                                    ),
                                                ),
                                            ],
                                        ),
                    ],
                ),
            ),
        );
    }

    pw.Widget _buildSummaryItem(String label, String value, pw.TextStyle normalStyle, pw.TextStyle emphasisStyle) {
        return pw.Container(
            padding: pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius: pw.BorderRadius.circular(4),
                border: pw.Border.all(color: PdfColors.blue200)
            ),
            child: pw.Column(
                children: [
                    pw.Text(value, style: emphasisStyle.copyWith(fontSize: 16)),
                    pw.SizedBox(height: 4),
                    pw.Text(label, style: normalStyle),
                ],
            ),
        );
    }

    pw.Widget _buildEventDetail(String label, String value, pw.TextStyle style) {
        return pw.Container(
            width: 150,
            padding: pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(4)
            ),
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                    pw.Text(
                        label,
                        style: style.copyWith(color: PdfColors.grey700)
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                        value,
                        style: style.copyWith(fontWeight: pw.FontWeight.bold)
                    ),
                ]
            )
        );
    }

    @override
    Widget build(BuildContext context) {
        String title = eventData['title'] ?? 'Untitled Event';
        DateTime date = (eventData['date'] as Timestamp).toDate();
        String location = eventData['location'] ?? 'No location';
        int registeredCount = (eventData['registeredUsers'] as List?)?.length ?? 0;
        int capacity = eventData['capacity'] ?? 0;
        bool isFull = registeredCount >= capacity;
        String type = eventData['type'] ?? 'Event';
        int points = eventData['points'] ?? 0;
        int price = eventData['price'] ?? 0;

        return Scaffold(
            backgroundColor: isDarkMode ? Color(0xFF1A1A2E) : Colors.blue[50],
            appBar: AppBar(
                title: Text(title),
                        actions: isCreated ? [
                    IconButton(
                        icon: Icon(Icons.download),
                        onPressed: () => _downloadEventReport(context, eventData),
                        tooltip: 'Download Event Report',
                    ),
                            IconButton(
                                icon: Icon(Icons.edit),
                        onPressed: () => _showEditEventDialog(context, eventData),
                            ),
                            IconButton(
                                icon: Icon(Icons.delete),
                        onPressed: () => _showDeleteConfirmation(context, eventData),
                            ),
                        ] : null,
                    ),
            body: SingleChildScrollView(
                child: Column(
                                children: [
                        // Event Image
                        AspectRatio(
                            aspectRatio: 16/9,
                            child: Image.network(
                                        eventData['image'] ?? 'https://images.unsplash.com/photo-1505373877841-8d25f7d46678',
                                        fit: BoxFit.cover,
                                    ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    // Event Type Badge
                                                Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                            color: _getEventTypeColor(type).withOpacity(0.1),
                                                        borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Text(
                                                        type,
                                                        style: TextStyle(
                                                color: _getEventTypeColor(type),
                                                            fontWeight: FontWeight.bold,
                                                        ),
                                                    ),
                                                ),
                                    SizedBox(height: 16),
                                    // Event Details
                                    _buildInfoCard(
                                        isDarkMode: isDarkMode,
                                        title: 'Event Details',
                                        content: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                _buildDetailRow(
                                                    icon: Icons.calendar_today,
                                                    label: 'Date',
                                                    value: '${date.day}/${date.month}/${date.year}',
                                                    isDarkMode: isDarkMode,
                                                ),
                                                _buildDetailRow(
                                                    icon: Icons.location_on,
                                                    label: 'Location',
                                                    value: location,
                                                    isDarkMode: isDarkMode,
                                                ),
                                                _buildDetailRow(
                                                    icon: Icons.star,
                                                    label: 'Points',
                                                    value: '$points pts',
                                                    isDarkMode: isDarkMode,
                                                ),
                                                // Price Section with Toggle
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                        Text(
                                                            'Special Price Mode',
                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold,
                                                                color: isDarkMode ? Colors.white : Colors.black,
                                                            ),
                                                        ),
                                                        Switch(
                                                            value: (eventData['hasSpecialPrices'] as bool?) ?? false,
                                                            onChanged: isCreated ? (bool value) async {
                                                                try {
                                                                    await FirebaseFirestore.instance
                                                    .collection('events')
                                                    .doc(eventData['id'])
                                                                        .update({
                                                                            'hasSpecialPrices': value,
                                                                            'specialPrices': value ? [
                                                                                {'name': 'IEEE Member', 'amount': 0},
                                                                                {'name': 'Non IEEE Member', 'amount': 0}
                                                                            ] : null,
                                                                        });
                                                                    
                                                                    if (value) {
                                                                        // Show edit dialog when enabling special prices
                                                                        _showEditEventDialog(context, {
                                                                            ...eventData,
                                                                            'hasSpecialPrices': true,
                                                                            'specialPrices': [
                                                                                {'name': 'IEEE Member', 'amount': 0},
                                                                                {'name': 'Non IEEE Member', 'amount': 0}
                                                                            ]
                                                                        });
                                                                    }
                                                                } catch (e) {
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                        SnackBar(content: Text('Error updating special prices: $e')),
                                                                    );
                                                                }
                                                            } : null,
                                                            activeColor: Colors.blue,
                                                        ),
                                                    ],
                                                ),
                                                if (!(eventData['hasSpecialPrices'] as bool? ?? false))
                                                _buildDetailRow(
                                                    icon: Icons.currency_rupee,
                                                    label: 'Price',
                                                        value: 'Rs. $price',
                                                    isDarkMode: isDarkMode,
                                                ),
                                                // Special Prices Section
                                                if ((eventData['hasSpecialPrices'] as bool? ?? false) && 
                                                    eventData['specialPrices'] != null && 
                                                    (eventData['specialPrices'] as List).isNotEmpty) ...[
                                                    Divider(
                                                        color: isDarkMode ? Colors.white24 : Colors.grey[300],
                                                        height: 24,
                                                    ),
                                                    Row(
                                                        children: [
                                                            Container(
                                                                padding: EdgeInsets.all(8),
                                                                decoration: BoxDecoration(
                                                                    color: isDarkMode 
                                                                        ? Colors.blue[900]!.withOpacity(0.2) 
                                                                        : Colors.blue[50],
                                                                    borderRadius: BorderRadius.circular(8),
                                                                ),
                                                                child: Icon(
                                                                    Icons.sell_outlined,
                                                                    size: 20,
                                                                    color: isDarkMode ? Colors.blue[400] : Colors.blue[800],
                                                                ),
                                                            ),
                                                            SizedBox(width: 16),
                                                            Text(
                                                                'Special Prices',
                                                                style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: isDarkMode ? Colors.white : Colors.black,
                                                                ),
                                                            ),
                                                            if (isCreated) ...[
                                                                Spacer(),
                                                                IconButton(
                                                                    icon: Icon(Icons.edit),
                                                                    onPressed: () => _showEditEventDialog(context, eventData),
                                                                    color: isDarkMode ? Colors.blue[400] : Colors.blue[800],
                                                                ),
                                                            ],
                                                        ],
                                                    ),
                                                    SizedBox(height: 12),
                                                    ...(eventData['specialPrices'] as List).map((price) => 
                                                        Padding(
                                                            padding: EdgeInsets.only(left: 48, bottom: 8),
                                                            child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                    Text(
                                                                        price['name'] ?? 'Category',
                                                                                style: TextStyle(
                                                                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                                                                ),
                                                                            ),
                                                                    Text(
                                                                        'Rs. ${price['amount'] ?? 0}',
                                                                    style: TextStyle(
                                                                        color: isDarkMode ? Colors.white : Colors.black,
                                                                                fontWeight: FontWeight.bold,
                                                                    ),
                                                                ),
                                                                ],
                                                            ),
                                                        ),
                                                    ).toList(),
                                                ],
                                            ],
                                        ),
                                    ),
                                    SizedBox(height: 16),
                                    // Event Description
                                    _buildInfoCard(
                                        isDarkMode: isDarkMode,
                                        title: 'Description',
                                        content: Text(
                                            eventData['description'] ?? 'No description available',
                                            style: TextStyle(
                                                color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                                                height: 1.5,
                                            ),
                                        ),
                                    ),
                                        SizedBox(height: 16),
                                    // Registered Users Section
                                    StreamBuilder<QuerySnapshot>(
                                                stream: FirebaseFirestore.instance
                                                    .collection('events')
                                                    .doc(eventData['id'])
                                                    .collection('registrations')
                                                    .where(FieldPath.documentId, isNotEqualTo: '_info')  // Exclude _info document
                                                    .snapshots(),
                                                builder: (context, registrationsSnapshot) {
                                                    if (registrationsSnapshot.hasError) {
                                                        return _buildInfoCard(
                                                            isDarkMode: isDarkMode,
                                                            title: 'Registered Users',
                                                            content: Text(
                                                                'Error loading registrations',
                                                                style: TextStyle(color: Colors.red),
                                                            ),
                                                        );
                                                    }

                                                    if (!registrationsSnapshot.hasData) {
                                                        return _buildInfoCard(
                                                            isDarkMode: isDarkMode,
                                                            title: 'Registered Users',
                                                            content: Center(child: CircularProgressIndicator()),
                                                        );
                                                    }

                                                    final registrations = registrationsSnapshot.data!.docs;

                                                    if (registrations.isEmpty) {
                                                        return _buildInfoCard(
                                                            isDarkMode: isDarkMode,
                                                            title: 'Registered Users',
                                                            content: Text(
                                                                'No registrations yet',
                                                                style: TextStyle(
                                                                    color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                                                                    fontStyle: FontStyle.italic,
                                                                ),
                                                            ),
                                                        );
                                                    }

                                                    return _buildInfoCard(
                                                        isDarkMode: isDarkMode,
                                                        title: 'Registered Users',
                                                        content: Column(
                                                            children: registrations.map((reg) {
                                                                return _buildRegistrationTile(reg.data() as Map<String, dynamic>, isDarkMode);
                                                            }).toList(),
                                                        ),
                                                    );
                                                },
                                    ),
                                ],
                            ),
                                                                        ),
                                                                    ],
                                                                ),
                                                            ),
        );
    }

    Widget _buildRegistrationTile(Map<String, dynamic> registration, bool isDarkMode) {
        return ExpansionTile(
            title: Text(
                registration['name'] ?? 'Unknown User',
                style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
                registration['email'] ?? 'No email',
                style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
                overflow: TextOverflow.ellipsis,
            ),
            leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: isDarkMode 
                        ? Colors.blue[900]!.withOpacity(0.2)
                        : Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                    Icons.person,
                    color: isDarkMode ? Colors.blue[400] : Colors.blue[800],
                ),
            ),
            children: [
                Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                        color: isDarkMode 
                            ? Colors.black.withOpacity(0.2)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: isDarkMode 
                                ? Colors.white24 
                                : Colors.grey[300]!,
                        ),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            _buildDetailItem(
                                'Phone',
                                registration['phone'] ?? 'Not provided',
                                Icons.phone,
                                isDarkMode,
                            ),
                            _buildDetailItem(
                                'College',
                                registration['college'] ?? 'Not provided',
                                Icons.school,
                                isDarkMode,
                            ),
                            _buildDetailItem(
                                'Department',
                                registration['department'] ?? 'Not provided',
                                Icons.business,
                                isDarkMode,
                            ),
                            _buildDetailItem(
                                'Year',
                                registration['year'] ?? 'Not provided',
                                Icons.calendar_today,
                                isDarkMode,
                            ),
                            _buildDetailItem(
                                'Transaction ID',
                                registration['transaction_id'] ?? 'Not provided',
                                Icons.receipt_long,
                                isDarkMode,
                            ),
                            _buildDetailItem(
                                'Accommodation',
                                registration['needsAccommodation'] == true ? 'Yes' : 'No',
                                Icons.hotel,
                                isDarkMode,
                            ),
                            _buildDetailItem(
                                'Registration Date',
                                _formatTimestamp(registration['registeredAt']),
                                Icons.access_time,
                                isDarkMode,
                            ),
                            if (registration['priceCategory'] != null)
                                _buildDetailItem(
                                    'Price Category',
                                    registration['priceCategory']['name'] ?? 'Not provided',
                                    Icons.sell,
                                    isDarkMode,
                                ),
                            if (registration['referralId'] != null)
                                _buildDetailItem(
                                    'Referral ID',
                                    registration['referralId'],
                                    Icons.person_add,
                                    isDarkMode,
                                ),
                        ],
                    ),
                ),
            ],
        );
    }

    Widget _buildDetailItem(String label, String value, IconData icon, bool isDarkMode) {
        return Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: isDarkMode 
                                ? Colors.blue[900]!.withOpacity(0.2)
                                : Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                            icon,
                            size: 16,
                            color: isDarkMode ? Colors.blue[400] : Colors.blue[800],
                        ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                    label,
                                    style: TextStyle(
                                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                        fontSize: 12,
                                    ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                    value,
                                    style: TextStyle(
                                        color: isDarkMode ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.w500,
                                    ),
                                    softWrap: true,
                                ),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }

    Color _getEventTypeColor(String type) {
        switch (type.toLowerCase()) {
            case 'workshop':
                return Colors.orange;
            case 'seminar':
                return Colors.green;
            case 'conference':
                return Colors.purple;
            case 'hackathon':
                return Colors.red;
            default:
                return Colors.blue;
        }
    }

    Widget _buildInfoCard({
        required bool isDarkMode,
        required String title,
        required Widget content,
    }) {
        return Container(
            decoration: BoxDecoration(
                color: isDarkMode ? Color(0xFF252542) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                    ),
                ],
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                            title,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                            ),
                        ),
                    ),
                    Divider(
                        color: isDarkMode ? Colors.white24 : Colors.grey[300],
                        height: 1,
                    ),
                    Padding(
                        padding: EdgeInsets.all(16),
                        child: content,
                    ),
                ],
            ),
        );
    }

    Widget _buildDetailRow({
        required IconData icon,
        required String label,
        required String value,
        required bool isDarkMode,
        bool isCapacity = false,
        bool isFull = false,
    }) {
        return Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
                children: [
                    Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: isDarkMode 
                                ? Colors.blue[900]!.withOpacity(0.2)
                                : Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                            icon,
                            size: 20,
                            color: isDarkMode ? Colors.blue[400] : Colors.blue[800],
                        ),
                    ),
                    SizedBox(width: 16),
                    Text(
                        label,
                        style: TextStyle(
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                    ),
                    Spacer(),
                    Text(
                        value,
                        style: TextStyle(
                            color: isCapacity
                                ? (isFull
                                    ? Colors.red
                                    : Colors.green)
                                : (isDarkMode ? Colors.white : Colors.black),
                            fontWeight: FontWeight.bold,
                        ),
                    ),
                ],
            ),
        );
    }

    void _showDeleteConfirmation(BuildContext context, Map<String, dynamic> eventData) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: Text('Delete Event'),
                content: Text('Are you sure you want to delete this event? This action cannot be undone.'),
                actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                            try {
                                await FirebaseFirestore.instance
                                    .collection('events')
                                    .doc(eventData['id'])
                                    .delete();
                                
                                Navigator.pop(context); // Close dialog
                                Navigator.pop(context); // Go back to profile
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Event deleted successfully')),
                                );
                            } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error deleting event: $e')),
                                );
                            }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                        ),
                        child: Text('Delete'),
                    ),
                ],
            ),
        );
    }

    Future<void> _downloadEventReport(BuildContext context, Map<String, dynamic> eventData) async {
        try {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                    return Center(child: CircularProgressIndicator());
                },
            );

            // Fetch registrations for this event
            final registrationsSnapshot = await FirebaseFirestore.instance
                .collection('events')
                .doc(eventData['id'])
                .collection('registrations')
                .where(FieldPath.documentId, isNotEqualTo: '_info')  // Exclude _info document
                .get();

            final registrations = registrationsSnapshot.docs
                .map((doc) => doc.data())
                .toList();

            final pdf = pw.Document();

            // Define styles
            final baseStyle = pw.TextStyle(
                font: pw.Font.helvetica(),
                fontSize: 10,
                color: PdfColors.black
            );

            final titleStyle = baseStyle.copyWith(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue900
            );

            final headerStyle = baseStyle.copyWith(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800
            );

            final subHeaderStyle = baseStyle.copyWith(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue700
            );

            final normalStyle = baseStyle;
            final emphasisStyle = baseStyle.copyWith(fontWeight: pw.FontWeight.bold);

            // Calculate statistics
            Set<String> uniqueColleges = {};
            Set<String> uniqueDepartments = {};
            final price = (eventData['price'] as num?)?.toInt() ?? 0;
            final totalRevenue = registrations.length * price;

            for (var reg in registrations) {
                if (reg['college'] != null) uniqueColleges.add(reg['college']);
                if (reg['department'] != null) uniqueDepartments.add(reg['department']);
            }

            // Create PDF
            pdf.addPage(
                pw.MultiPage(
                    pageFormat: PdfPageFormat.a4,
                    margin: pw.EdgeInsets.all(40),
                    header: (context) {
                        return pw.Container(
                            padding: pw.EdgeInsets.only(bottom: 20),
                            decoration: pw.BoxDecoration(
                                border: pw.Border(bottom: pw.BorderSide(color: PdfColors.blue200))
                            ),
                            child: pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
                                    pw.Text(
                                        'Event Report: ${eventData['title']}',
                                        style: titleStyle
                                    ),
                                    pw.Text(
                                        DateTime.now().toString().split('.')[0],
                                        style: baseStyle.copyWith(color: PdfColors.grey700)
                                    ),
                                ]
                            )
                        );
                    },
                    footer: (context) {
                        return pw.Container(
                            alignment: pw.Alignment.centerRight,
                            margin: pw.EdgeInsets.only(top: 10),
                            child: pw.Text(
                                'Page ${context.pageNumber} of ${context.pagesCount}',
                                style: baseStyle.copyWith(color: PdfColors.grey700)
                            )
                        );
                    },
                    build: (context) {
                        return [
                            // Event Summary
                            pw.Container(
                                padding: pw.EdgeInsets.all(15),
                                margin: pw.EdgeInsets.only(bottom: 20),
                                decoration: pw.BoxDecoration(
                                    color: PdfColors.blue50,
                                    borderRadius: pw.BorderRadius.circular(8)
                                ),
                                child: pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    children: [
                                        pw.Text('Event Summary', style: headerStyle),
                                        pw.SizedBox(height: 10),
                                        pw.Row(
                                            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                                            children: [
                                                _buildSummaryItem('Total Registrations', '${registrations.length}', normalStyle, emphasisStyle),
                                                _buildSummaryItem('Total Revenue', 'Rs. $totalRevenue', normalStyle, emphasisStyle),
                                                _buildSummaryItem('Unique Colleges', '${uniqueColleges.length}', normalStyle, emphasisStyle),
                                                _buildSummaryItem('Unique Departments', '${uniqueDepartments.length}', normalStyle, emphasisStyle),
                                            ]
                                        ),
                                    ]
                                )
                            ),

                            // Event Details
                            pw.Container(
                                margin: pw.EdgeInsets.only(bottom: 20),
                                padding: pw.EdgeInsets.all(15),
                                decoration: pw.BoxDecoration(
                                    border: pw.Border.all(color: PdfColors.blue200),
                                    borderRadius: pw.BorderRadius.circular(8)
                                ),
                                child: pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    children: [
                                        pw.Text('Event Details', style: subHeaderStyle),
                                        pw.SizedBox(height: 10),
                                        _buildEventDetail('Type', eventData['type'] ?? 'N/A', normalStyle),
                                        _buildEventDetail('Date', (eventData['date'] as Timestamp).toDate().toString().split('.')[0], normalStyle),
                                        _buildEventDetail('Location', eventData['location'] ?? 'N/A', normalStyle),
                                        _buildEventDetail('Price', 'Rs. ${eventData['price'] ?? 0}', normalStyle),
                                        _buildEventDetail('Points', '${eventData['points'] ?? 0}', normalStyle),
                                        _buildEventDetail('Capacity', '${eventData['capacity'] ?? 0}', normalStyle),
                                    ]
                                )
                            ),

                            // Registrations
                            if (registrations.isNotEmpty) ...[
                                pw.Text('Registrations', style: headerStyle),
                                pw.SizedBox(height: 10),
                                pw.Table(
                                    border: pw.TableBorder.all(color: PdfColors.blue200),
                                    children: [
                                        pw.TableRow(
                                            decoration: pw.BoxDecoration(color: PdfColors.blue50),
                                            children: [
                                                _buildTableCell('Name', isHeader: true),
                                                _buildTableCell('Email', isHeader: true),
                                                _buildTableCell('Phone', isHeader: true),
                                                _buildTableCell('College', isHeader: true),
                                                _buildTableCell('Department', isHeader: true),
                                                _buildTableCell('Year', isHeader: true),
                                                if (eventData['hasSpecialPrices'] == true)
                                                    _buildTableCell('Price Category', isHeader: true),
                                                if (eventData['hasReferralId'] == true)
                                                    _buildTableCell('Referral ID', isHeader: true),
                                                _buildTableCell('Transaction ID', isHeader: true),
                                                _buildTableCell('Accommodation', isHeader: true),
                                                _buildTableCell('Registration Date', isHeader: true),
                                            ]
                                        ),
                                        ...registrations.map((reg) => pw.TableRow(
                                            children: [
                                                _buildTableCell(reg['name'] ?? 'N/A'),
                                                _buildTableCell(reg['email'] ?? 'N/A'),
                                                _buildTableCell(reg['phone'] ?? 'N/A'),
                                                _buildTableCell(reg['college'] ?? 'N/A'),
                                                _buildTableCell(reg['department'] ?? 'N/A'),
                                                _buildTableCell(reg['year'] ?? 'N/A'),
                                                if (eventData['hasSpecialPrices'] == true)
                                                    _buildTableCell(reg['priceCategory']?['name'] ?? 'N/A'),
                                                if (eventData['hasReferralId'] == true)
                                                    _buildTableCell(reg['referralId'] ?? 'N/A'),
                                                _buildTableCell(reg['transaction_id'] ?? 'N/A'),  // Use consistent field name
                                                _buildTableCell(reg['needsAccommodation'] == true ? 'Yes' : 'No'),
                                                _buildTableCell(_formatTimestamp(reg['registeredAt'])),
                                            ]
                                        )).toList(),
                                    ]
                                ),
                            ],
                        ];
                    }
                )
            );

            final bytes = await pdf.save();
            Navigator.pop(context); // Close loading dialog

            if (kIsWeb) {
                final blob = html.Blob([bytes], 'application/pdf');
                final url = html.Url.createObjectUrlFromBlob(blob);
                html.window.open(url, '_blank');
                html.Url.revokeObjectUrl(url);
            } else {
                final directory = await getApplicationDocumentsDirectory();
                final file = File('${directory.path}/${eventData['title']}_report.pdf');
                await file.writeAsBytes(bytes);
                await OpenFile.open(file.path);
            }

        } catch (e) {
            print('Error generating PDF: $e');
            Navigator.pop(context); // Close loading dialog
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error generating PDF: $e'))
            );
        }
    }

    pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
        return pw.Container(
            padding: pw.EdgeInsets.all(6),
            child: pw.Text(
                text,
                style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
                    color: isHeader ? PdfColors.blue900 : PdfColors.black
                )
            )
        );
    }

    String _formatTimestamp(dynamic timestamp) {
        if (timestamp == null) return 'Not available';
        DateTime dateTime = (timestamp as Timestamp).toDate();
        return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
}
