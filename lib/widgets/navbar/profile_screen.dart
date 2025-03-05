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
                                                _buildManagementSection()
                                                    .animate()
                                                    .fadeIn(delay: 600.ms)
                                                    .slideX(begin: -0.2),
                                                SizedBox(height: 16),
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
                color: Colors.white,
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
                                    'Management',
                        style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                    ),
                                ),
                                IconButton(
                                    icon: Icon(Icons.download),
                                    onPressed: _downloadEventData,
                                    tooltip: 'Download Report',
                                ),
                            ],
                        ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('events')
                            .where('creatorId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                            if (snapshot.hasError) {
                                return _buildSection(
                                    'Event Management',
                                    Icons.manage_accounts,
                                    [Text('Error loading management data')],
                                );
                            }

                            if (!snapshot.hasData) {
                                return _buildSection(
                                    'Event Management',
                                    Icons.manage_accounts,
                                    [Center(child: CircularProgressIndicator())],
                                );
                            }

                            List<DocumentSnapshot> createdEvents = snapshot.data!.docs;
                            int totalEvents = createdEvents.length;
                            int totalRegistrations = 0;
                            int totalRevenue = 0;
                            DateTime now = DateTime.now();

                            // Calculate statistics
                            for (var event in createdEvents) {
                                Map<String, dynamic> eventData = event.data() as Map<String, dynamic>;
                                List<dynamic> registeredUsers = eventData['registeredUsers'] ?? [];
                                int price = eventData['price'] ?? 0;
                                totalRegistrations += registeredUsers.length;
                                totalRevenue += registeredUsers.length * price;
                            }

        return _buildSection(
                                'Event Management',
                                Icons.manage_accounts,
            [
                                    // Statistics Cards
                Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Row(
                                            children: [
                                                Expanded(
                                                    child: _buildStatCard(
                                                        'Total Events',
                                                        totalEvents.toString(),
                                                        Icons.event,
                                                        Colors.blue,
                                                    ),
                                                ),
                                                SizedBox(width: 16),
                                                Expanded(
                                                    child: _buildStatCard(
                                                        'Total Registrations',
                                                        totalRegistrations.toString(),
                                                        Icons.people,
                                                        Colors.green,
                                                    ),
                                                ),
                                                SizedBox(width: 16),
                                                Expanded(
                                                    child: _buildStatCard(
                                                        'Total Revenue',
                                                        '₹$totalRevenue',
                                                        Icons.currency_rupee,
                                                        Colors.orange,
                                                    ),
                                                ),
                                            ],
                                        ),
                                    ),
                                    Divider(color: isDarkMode ? Colors.white24 : Colors.grey[300]),
                                    // Created Events List
                                    Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Text(
                                                    'Created Events',
                                        style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: isDarkMode ? Colors.white : Colors.black,
                                                    ),
                                                ),
                                                SizedBox(height: 8),
                                                ...createdEvents.map((event) {
                                                    Map<String, dynamic> eventData = event.data() as Map<String, dynamic>;
                                                    eventData['id'] = event.id;
                                                    return _buildEventTile(
                                                        eventData,
                                                        isCreated: true,
                                                    );
                                                }).toList(),
                                            ],
                    ),
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
                                                '$price',
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
                color: isDarkMode ? Color(0xFF2A2A40) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isDarkMode ? Colors.white24 : Colors.grey[300]!,
                ),
            ),
            child: Column(
                children: [
                    Icon(icon, color: color, size: 24),
                    SizedBox(height: 8),
                    Text(
                        value,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                        ),
                    ),
                    Text(
                        title,
                        style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                    ),
                ],
            ),
        );
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

            // Fetch all events
            final eventsSnapshot = await FirebaseFirestore.instance
                .collection('events')
                .get();

            print('Found ${eventsSnapshot.docs.length} total events');

            // Fetch all creators' details
            Map<String, Map<String, dynamic>> creatorDetailsMap = {};
            for (var doc in eventsSnapshot.docs) {
                String creatorId = doc.data()['creatorId'] ?? '';
                if (creatorId.isNotEmpty && !creatorDetailsMap.containsKey(creatorId)) {
                    try {
                        var creatorDoc = await FirebaseFirestore.instance
                            .collection('users')
                            .where('userId', isEqualTo: creatorId)
                            .get();

                        if (creatorDoc.docs.isNotEmpty) {
                            creatorDetailsMap[creatorId] = creatorDoc.docs.first.data();
                            print('Found creator data: ${creatorDetailsMap[creatorId]}');
                        }
                    } catch (e) {
                        print('Error fetching creator data for $creatorId: $e');
                    }
                }
            }

            // Fetch registration details for each event
            Map<String, List<Map<String, dynamic>>> eventRegistrationsMap = {};
            for (var eventDoc in eventsSnapshot.docs) {
                String eventId = eventDoc.id;
                try {
                    final registrationsSnapshot = await FirebaseFirestore.instance
                        .collection('events')
                        .doc(eventId)
                        .collection('registrations')
                        .get();

                    eventRegistrationsMap[eventId] = registrationsSnapshot.docs
                        .map((doc) => doc.data())
                        .toList();
                    
                    print('Event ID: $eventId');
                    print('Registration data example:');
                    if (eventRegistrationsMap[eventId]?.isNotEmpty ?? false) {
                        print(eventRegistrationsMap[eventId]?.first);
                    }
                } catch (e) {
                    print('Error fetching registrations for event $eventId: $e');
                    eventRegistrationsMap[eventId] = [];
                }
            }

            final pdf = pw.Document();

            final baseStyle = pw.TextStyle(
                font: pw.Font.helvetica(),
                fontFallback: [pw.Font.courier(), pw.Font.helveticaBold()]
            );

            final titleStyle = baseStyle.copyWith(fontSize: 24, fontWeight: pw.FontWeight.bold);
            final headerStyle = baseStyle.copyWith(fontSize: 18, fontWeight: pw.FontWeight.bold);
            final subHeaderStyle = baseStyle.copyWith(fontSize: 14, fontWeight: pw.FontWeight.bold);
            final normalStyle = baseStyle.copyWith(fontSize: 12);

            pdf.addPage(
                pw.MultiPage(
                    pageFormat: PdfPageFormat.a4,
                    build: (pw.Context context) {
                        return [
                            pw.Center(child: pw.Text('Complete Events Report', style: titleStyle)),
                            pw.SizedBox(height: 20),
                            pw.Text('Total Events: ${eventsSnapshot.docs.length}', style: headerStyle),
                            pw.SizedBox(height: 20),
                            ...eventsSnapshot.docs.map((eventDoc) {
                                final eventData = eventDoc.data();
                                final eventId = eventDoc.id;
                                final creatorId = eventData['creatorId'] ?? '';
                                final creatorData = creatorDetailsMap[creatorId] ?? {};
                                final registrations = eventRegistrationsMap[eventId] ?? [];
                                final capacity = eventData['capacity'] ?? 0;
                                final price = eventData['price'] ?? 0;
                                final totalRevenue = price * registrations.length;
                                final eventDate = (eventData['date'] as Timestamp).toDate();

                                return [
                                    pw.Container(
                                        decoration: pw.BoxDecoration(
                                            color: PdfColors.grey200,
                                            borderRadius: pw.BorderRadius.circular(8)
                                        ),
                                        padding: pw.EdgeInsets.all(15),
                                        margin: pw.EdgeInsets.symmetric(vertical: 10),
                                        child: pw.Column(
                                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                                            children: [
                                                // Event Header
                                                pw.Container(
                                                    color: PdfColors.blue100,
                                                    padding: pw.EdgeInsets.all(10),
                                                    child: pw.Row(
                                                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                                        children: [
                                                            pw.Text(eventData['title'] ?? 'Untitled Event', 
                                                                style: headerStyle.copyWith(color: PdfColors.blue900)),
                                                            pw.Text('Rs. $totalRevenue', 
                                                                style: subHeaderStyle.copyWith(color: PdfColors.green700))
                                                        ]
                                                    )
                                                ),
                                                pw.SizedBox(height: 10),

                                                // Event Details
                                                pw.Text('Event Details:', style: subHeaderStyle),
                                                pw.SizedBox(height: 5),
                                                pw.Text('Type: ${eventData['type'] ?? 'N/A'}', style: normalStyle),
                                                pw.Text('Date: ${eventDate.toString().split('.')[0]}', style: normalStyle),
                                                pw.Text('Location: ${eventData['location'] ?? 'N/A'}', style: normalStyle),
                                                pw.Text('Price: Rs.${eventData['price'] ?? 0}', style: normalStyle),
                                                pw.Text('Points: ${eventData['points'] ?? 0}', style: normalStyle),
                                                pw.Text('Capacity: $capacity', style: normalStyle),
                                                pw.Text('Current Registrations: ${registrations.length}', style: normalStyle),
                                                pw.SizedBox(height: 10),

                                                // Creator Details
                                                pw.Text('Created By:', style: subHeaderStyle),
                                                pw.SizedBox(height: 5),
                                                pw.Text('Name: ${creatorData['username'] ?? creatorData['userName'] ?? 'Unknown'}', style: normalStyle),
                                                pw.Text('Email: ${creatorData['email'] ?? creatorData['userEmail'] ?? 'N/A'}', style: normalStyle),
                                                pw.SizedBox(height: 10),

                                                // Description
                                                pw.Text('Description:', style: subHeaderStyle),
                                                pw.SizedBox(height: 5),
                                                pw.Text(eventData['description'] ?? 'No description available', style: normalStyle),
                                                pw.SizedBox(height: 10),

                                                // Registered Users
                                                pw.Text('Registered Users (${registrations.length}/${eventData['capacity'] ?? 0}):', 
                                                    style: subHeaderStyle.copyWith(color: PdfColors.blue900)),
                                                pw.SizedBox(height: 10),
                                                if (registrations.isEmpty)
                                                    pw.Text('No users registered yet', style: normalStyle)
                                                else
                                                    ...registrations.map((regData) {
                                                        // Debug print for registration data
                                                        print('Registration Data: $regData');
                                                        
                                                        return pw.Container(
                                                            margin: pw.EdgeInsets.only(bottom: 8),
                                                            decoration: pw.BoxDecoration(
                                                                color: PdfColors.grey50,
                                                                borderRadius: pw.BorderRadius.circular(4)
                                                            ),
                                                            padding: pw.EdgeInsets.all(8),
                                                            child: pw.Column(
                                                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                                                children: [
                                                                    // Name and Email
                                                                    pw.Row(
                                                                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                            pw.Text(
                                                                                regData['userName'] ?? regData['name'] ?? regData['fullName'] ?? '',
                                                                                style: normalStyle.copyWith(
                                                                                    fontWeight: pw.FontWeight.bold,
                                                                                    color: PdfColors.blue900
                                                                                )
                                                                            ),
                                                                            pw.Text(
                                                                                regData['userEmail'] ?? regData['email'] ?? regData['emailId'] ?? '',
                                                                                style: normalStyle.copyWith(
                                                                                    color: PdfColors.blue800
                                                                                )
                                                                            ),
                                                                        ]
                                                                    ),
                                                                    pw.SizedBox(height: 4),
                                                                    // Phone and College
                                                                    pw.Row(
                                                                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                            pw.Text(
                                                                                regData['phoneNumber'] ?? regData['phone'] ?? regData['mobile'] ?? '',
                                                                                style: normalStyle
                                                                            ),
                                                                            pw.Text(
                                                                                regData['collegeName'] ?? regData['college'] ?? regData['university'] ?? '',
                                                                                style: normalStyle
                                                                            ),
                                                                        ]
                                                                    ),
                                                                    pw.SizedBox(height: 4),
                                                                    // Department and Year
                                                                    pw.Row(
                                                                        children: [
                                                                            pw.Expanded(
                                                                                child: pw.Text(
                                                                                    '${regData['departmentName'] ?? regData['department'] ?? ''} | ${regData['yearOfStudy'] ?? regData['year'] ?? ''}',
                                                                                    style: normalStyle
                                                                                )
                                                                            ),
                                                                        ]
                                                                    ),
                                                                ]
                                                            )
                                                        );
                                                    }).toList(),
                                                pw.SizedBox(height: 10),
                                            ]
                                        )
                                    ),
                                    pw.SizedBox(height: 10),
                                ];
                            }).expand((x) => x).toList(),
                        ];
                    }
                )
            );

            final bytes = await pdf.save();
            Navigator.pop(context);

            if (kIsWeb) {
                final blob = html.Blob([bytes], 'application/pdf');
                final url = html.Url.createObjectUrlFromBlob(blob);
                html.window.open(url, '_blank');
                html.Url.revokeObjectUrl(url);
            } else {
                final directory = await getApplicationDocumentsDirectory();
                final file = File('${directory.path}/all_events_report.pdf');
                await file.writeAsBytes(bytes);
                await OpenFile.open(file.path);
            }

        } catch (e) {
            print('Error generating PDF: $e');
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error generating PDF: $e'))
            );
        }
    }

    // Helper methods for PDF generation
    pw.Widget _buildSummaryItem(String label, String value, pw.TextStyle normalStyle, pw.TextStyle boldStyle) {
        return pw.Container(
            padding: pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius: pw.BorderRadius.circular(5),
            ),
            child: pw.Column(
                children: [
                    pw.Text(
                        value,
                        style: boldStyle,
                    ),
                    pw.Text(
                        label,
                        style: normalStyle,
                    ),
                ],
            ),
        );
    }

    pw.Widget _buildEventDetail(String label, String value, pw.TextStyle style) {
        return pw.Container(
            padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(5),
            ),
            child: pw.Text(
                '$label: $value',
                style: style,
            ),
        );
    }

    int _calculateTotalRevenue(List<QueryDocumentSnapshot> events) {
        int total = 0;
        for (var event in events) {
            final data = event.data() as Map<String, dynamic>;
            List<dynamic> registeredUsers = data['registeredUsers'] ?? [];
            int price = data['price'] ?? 0;
            total += registeredUsers.length * price;
        }
        return total;
    }

    int _calculateTotalRegistrations(List<QueryDocumentSnapshot> events) {
        int total = 0;
        for (var event in events) {
            final data = event.data() as Map<String, dynamic>;
            List<dynamic> registeredUsers = data['registeredUsers'] ?? [];
            total += registeredUsers.length;
        }
        return total;
    }

    // Helper method for profile details
    pw.Widget _buildProfileDetail(String label, String value) {
        return pw.Container(
            padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: pw.Column(
                children: [
                    pw.Text(
                        label,
                        style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey700,
                            font: pw.Font.helvetica(),
                        ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                        value,
                        style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blue900,
                            font: pw.Font.helvetica(),
                        ),
                    ),
                ],
            ),
        );
    }

    // Helper method for PDF event type colors
    PdfColor _getPdfEventTypeColor(String type, {bool isBackground = false}) {
        switch (type.toLowerCase()) {
            case 'workshop':
                return isBackground ? PdfColors.orange100 : PdfColors.orange;
            case 'seminar':
                return isBackground ? PdfColors.green100 : PdfColors.green;
            case 'conference':
                return isBackground ? PdfColors.purple100 : PdfColors.purple;
            case 'hackathon':
                return isBackground ? PdfColors.red100 : PdfColors.red;
            default:
                return isBackground ? PdfColors.blue100 : PdfColors.blue;
        }
    }
}

// New UserProfileScreen to display user information
class UserProfileScreen extends StatelessWidget {
    final String username;
    final String email;

    UserProfileScreen({required this.username, required this.email});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Profile'),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        CircleAvatar(
                            radius: 50,
                            child: Icon(Icons.person, size: 50), // Profile icon
                        ),
                        SizedBox(height: 20),
                        Text('Hey $username', style: TextStyle(fontSize: 24)),
                        SizedBox(height: 10),
                        Text('Email: $email', style: TextStyle(fontSize: 18)),
                    ],
                ),
            ),
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
            body: CustomScrollView(
                slivers: [
                    SliverAppBar(
                        expandedHeight: 200,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                            background: Stack(
                                fit: StackFit.expand,
                                children: [
                                    Image.network(
                                        eventData['image'] ?? 'https://images.unsplash.com/photo-1505373877841-8d25f7d46678',
                                        fit: BoxFit.cover,
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                    Colors.transparent,
                                                    Colors.black.withOpacity(0.7),
                                                ],
                                            ),
                                        ),
                                    ),
                                    Positioned(
                                        bottom: 16,
                                        left: 16,
                                        right: 16,
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                        color: _getEventTypeColor(type).withOpacity(0.2),
                                                        borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Text(
                                                        type,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                        ),
                                                    ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                    title,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                        fontWeight: FontWeight.bold,
                                                    ),
                                                ),
                                            ],
                                        ),
                                    ),
                                ],
                            ),
                        ),
                        actions: isCreated ? [
                            IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                    // Show edit dialog
                                    _showEditEventDialog(context, eventData);
                                },
                            ),
                            IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                    // Show delete confirmation
                                    _showDeleteConfirmation(context, eventData);
                                },
                            ),
                        ] : null,
                    ),
                    SliverToBoxAdapter(
                        child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    _buildInfoCard(
                                        isDarkMode: isDarkMode,
                                        title: 'Event Details',
                                        content: Column(
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
                                                _buildDetailRow(
                                                    icon: Icons.currency_rupee,
                                                    label: 'Price',
                                                    value: '₹$price',
                                                    isDarkMode: isDarkMode,
                                                ),
                                                _buildDetailRow(
                                                    icon: Icons.people,
                                                    label: 'Capacity',
                                                    value: '$registeredCount/$capacity',
                                                    isDarkMode: isDarkMode,
                                                    isCapacity: true,
                                                    isFull: isFull,
                                                ),
                                            ],
                                        ),
                                    ),
                                    SizedBox(height: 16),
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
                                    if (isCreated) ...[
                                        SizedBox(height: 16),
                                        _buildInfoCard(
                                            isDarkMode: isDarkMode,
                                            title: 'Registrations',
                                            content: StreamBuilder<QuerySnapshot>(
                                                stream: FirebaseFirestore.instance
                                                    .collection('events')
                                                    .doc(eventData['id'])
                                                    .collection('registrations')
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                    if (snapshot.hasError) {
                                                        return Text('Error loading registrations');
                                                    }

                                                    if (!snapshot.hasData) {
                                                        return Center(child: CircularProgressIndicator());
                                                    }

                                                    List<DocumentSnapshot> registrations = snapshot.data!.docs;
                                                    
                                                    // Filter out the '_info' document
                                                    registrations = registrations.where((doc) => doc.id != '_info').toList();
                                                    
                                                    if (registrations.isEmpty) {
                                                        return Center(
                                                            child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                    Icon(
                                                                        Icons.person_off_outlined,
                                                                        size: 48,
                                                                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                                                    ),
                                                                    SizedBox(height: 16),
                                                                    Text(
                                                            'No registrations yet',
                                                            style: TextStyle(
                                                                            fontSize: 16,
                                                                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                                                        ),
                                                                    ),
                                                                ],
                                                            ),
                                                        );
                                                    }

                                                    return Column(
                                                        children: [
                                                            // Registration Stats
                                                            Container(
                                                                padding: EdgeInsets.all(16),
                                                                decoration: BoxDecoration(
                                                                    color: isDarkMode 
                                                                        ? Colors.blue[900]!.withOpacity(0.2) 
                                                                        : Colors.blue[50],
                                                                    borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                    children: [
                                                                        _buildStatItem(
                                                                            icon: Icons.people,
                                                                            label: 'Total',
                                                                            value: '${registrations.length}',
                                                                            isDarkMode: isDarkMode,
                                                                        ),
                                                                        Container(
                                                                            height: 40,
                                                                            width: 1,
                                                                            color: isDarkMode 
                                                                                ? Colors.white24 
                                                                                : Colors.black12,
                                                                        ),
                                                                        _buildStatItem(
                                                                            icon: Icons.school,
                                                                            label: 'Colleges',
                                                                            value: '${_getUniqueColleges(registrations).length}',
                                                                            isDarkMode: isDarkMode,
                                                                        ),
                                                                        Container(
                                                                            height: 40,
                                                                            width: 1,
                                                                            color: isDarkMode 
                                                                                ? Colors.white24 
                                                                                : Colors.black12,
                                                                        ),
                                                                        _buildStatItem(
                                                                            icon: Icons.category,
                                                                            label: 'Departments',
                                                                            value: '${_getUniqueDepartments(registrations).length}',
                                                                            isDarkMode: isDarkMode,
                                                                        ),
                                                                    ],
                                                                ),
                                                            ),
                                                            SizedBox(height: 16),
                                                            // Registration List
                                                            ...registrations.map((reg) {
                                                            Map<String, dynamic> data = reg.data() as Map<String, dynamic>;
                                                                return Container(
                                                                    margin: EdgeInsets.only(bottom: 12),
                                                                    decoration: BoxDecoration(
                                                                        color: isDarkMode 
                                                                            ? Colors.grey[900]!.withOpacity(0.5) 
                                                                            : Colors.white,
                                                                        borderRadius: BorderRadius.circular(12),
                                                                        border: Border.all(
                                                                            color: isDarkMode 
                                                                                ? Colors.grey[800]! 
                                                                                : Colors.grey[300]!,
                                                                            width: 1,
                                                                        ),
                                                                    ),
                                                                    child: ExpansionTile(
                                                                        leading: CircleAvatar(
                                                                            backgroundColor: isDarkMode 
                                                                                ? Colors.blue[900]!.withOpacity(0.2) 
                                                                                : Colors.blue[50],
                                                                            child: Text(
                                                                                data['userName']?[0].toUpperCase() ?? 'U',
                                                                                style: TextStyle(
                                                                                    color: isDarkMode 
                                                                                        ? Colors.blue[400] 
                                                                                        : Colors.blue[800],
                                                                                    fontWeight: FontWeight.bold,
                                                                                ),
                                                                            ),
                                                                        ),
                                                                title: Text(
                                                                    data['userName'] ?? 'Unknown User',
                                                                    style: TextStyle(
                                                                        color: isDarkMode ? Colors.white : Colors.black,
                                                                                fontWeight: FontWeight.bold,
                                                                    ),
                                                                ),
                                                                subtitle: Text(
                                                                            data['college'] ?? 'No College',
                                                                    style: TextStyle(
                                                                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                                                    ),
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow.ellipsis,
                                                                        ),
                                                                        children: [
                                                                            Padding(
                                                                                padding: EdgeInsets.all(16),
                                                                                child: Column(
                                                                                    children: [
                                                                                        _buildRegistrationDetailRow(
                                                                                            icon: Icons.school,
                                                                                            label: 'Department',
                                                                                            value: data['department'] ?? 'Not specified',
                                                                                            isDarkMode: isDarkMode,
                                                                                        ),
                                                                                        SizedBox(height: 8),
                                                                                        _buildRegistrationDetailRow(
                                                                                            icon: Icons.calendar_today,
                                                                                            label: 'Year',
                                                                                            value: data['year'] ?? 'Not specified',
                                                                                            isDarkMode: isDarkMode,
                                                                                        ),
                                                                                        SizedBox(height: 8),
                                                                                        _buildRegistrationDetailRow(
                                                                                            icon: Icons.phone,
                                                                                            label: 'Phone',
                                                                                            value: data['phone'] ?? 'Not provided',
                                                                                            isDarkMode: isDarkMode,
                                                                                        ),
                                                                                        SizedBox(height: 8),
                                                                                        _buildRegistrationDetailRow(
                                                                                            icon: Icons.access_time,
                                                                                            label: 'Registered On',
                                                                                            value: _formatTimestamp(data['registeredAt']),
                                                                                            isDarkMode: isDarkMode,
                                                                                        ),
                                                                                    ],
                                                                                ),
                                                                            ),
                                                                        ],
                                                                ),
                                                            );
                                                        }).toList(),
                                                        ],
                                                    );
                                                },
                                            ),
                                        ),
                                    ],
                                ],
                            ),
                        ),
                    ),
                ],
            ),
        );
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

    void _showEditEventDialog(BuildContext context, Map<String, dynamic> eventData) {
        // Implement edit dialog similar to the one in event_screen.dart
        // You can reuse the _showEditEventForm method from there
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

    // Helper methods for registration stats
    Set<String> _getUniqueColleges(List<DocumentSnapshot> registrations) {
        return registrations
            .map((reg) => (reg.data() as Map<String, dynamic>)['college'] as String?)
            .where((college) => college != null)
            .map((college) => college!)  // Convert String? to String
            .toSet();
    }

    Set<String> _getUniqueDepartments(List<DocumentSnapshot> registrations) {
        return registrations
            .map((reg) => (reg.data() as Map<String, dynamic>)['department'] as String?)
            .where((dept) => dept != null)
            .map((dept) => dept!)  // Convert String? to String
            .toSet();
    }

    Widget _buildStatItem({
        required IconData icon,
        required String label,
        required String value,
        required bool isDarkMode,
    }) {
        return Column(
            children: [
                Icon(icon,
                    color: isDarkMode ? Colors.blue[400] : Colors.blue[800],
                    size: 24,
                ),
                SizedBox(height: 4),
                Text(
                    value,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                    ),
                ),
                Text(
                    label,
                    style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                ),
            ],
        );
    }

    Widget _buildRegistrationDetailRow({
        required IconData icon,
        required String label,
        required String value,
        required bool isDarkMode,
    }) {
        return Row(
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
                Text(
                    '$label:',
                    style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                ),
                SizedBox(width: 8),
                Expanded(
                    child: Text(
                        value,
                        style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                    ),
                ),
            ],
        );
    }

    String _formatTimestamp(dynamic timestamp) {
        if (timestamp == null) return 'Not available';
        DateTime dateTime = (timestamp as Timestamp).toDate();
        return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
    }
}
