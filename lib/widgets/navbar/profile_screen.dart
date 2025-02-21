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
import 'dart:ui';

class ProfileScreen extends StatefulWidget {
    @override
    _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
    final TextEditingController usernameController = TextEditingController(); // Controller for username
    final TextEditingController emailController = TextEditingController(); // Controller for email
    final TextEditingController passwordController = TextEditingController(); // Controller for password
    final TextEditingController phoneController = TextEditingController(); // Controller for phone number
    final TextEditingController addressController = TextEditingController(); // Controller for address
    final TextEditingController majorController = TextEditingController(); // Controller for major
    final TextEditingController universityController = TextEditingController(); // Controller for university
    final TextEditingController yearController = TextEditingController(); // Controller for year of study
    final TextEditingController bioController = TextEditingController(); // Controller for bio
    final TextEditingController interestsController = TextEditingController(); // Controller for interests
    final TextEditingController socialMediaController = TextEditingController(); // Controller for social media links
    final TextEditingController departmentController = TextEditingController(); // Controller for department

    bool isSignUp = true; // Toggle between sign-up and sign-in
    String? username; // Store username
    String? email; // Store email
    String? phone; // Store phone number
    String? address; // Store address
    String? major; // Store major
    String? university; // Store university
    String? year; // Store year of study
    String? bio; // Store bio
    String? interests; // Store interests
    String? socialMedia; // Store social media links
    String? selectedCollege; // Variable to hold the selected college
    String? selectedDepartment; // Variable to hold the selected department
    String? selectedYear; // Variable to hold the selected year of study
    String? department; // Store department
    bool isDarkMode = false; // Variable to hold the theme mode

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
    'Royal College of Engineering and Technology, Thrissur',
    'SB College of Engineering, Bangalore',
    'SCMS School of Engineering and Technology, Ernakulam',
    'SNG College of Engineering, Kolenchery',
    'SNM Institute of Management and Technology, Ernakulam',
    'SNS College of Engineering, Coimbatore',
    'Sahrdaya College of Engineering and Technology, Thrissur',
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
    'Thejus Engineering College, Thrissur',
    'Travancore Engineering College, Kollam',
    'UKF College of Engineering and Technology, Kollam',
    'University College of Engineering, Kariavattom',
    'Vidya Academy of Science and Technology, Thrissur',
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
            isDarkMode = prefs.getBool('isDarkMode') ?? false; // Default to false if not set
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
                address = null;
                major = null;
                university = null;
                department = null;
                year = null;
                bio = null;
                interests = null;
                socialMedia = null;
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
                    address = data['address'];
                    major = data['major'];
                    university = data['university'];
                    department = data['department'];
                    year = data['year'];
                    bio = data['bio'];
                    interests = data['interests'];
                    socialMedia = data['socialMedia'];

                    // Update controllers
                    phoneController.text = phone ?? '';
                    addressController.text = address ?? '';
                    majorController.text = major ?? '';
                    selectedCollege = university;
                    selectedDepartment = department;
                    selectedYear = year;
                    bioController.text = bio ?? '';
                    interestsController.text = interests ?? '';
                    socialMediaController.text = socialMedia ?? '';
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
                'address': addressController.text.trim(),
                'major': majorController.text.trim(),
                'university': selectedCollege,
                'department': selectedDepartment,
                'year': selectedYear,
                'bio': bioController.text.trim(),
                'interests': interestsController.text.trim(),
                'socialMedia': socialMediaController.text.trim(),
            });

            // Fetch updated data
            DocumentSnapshot updatedData = await userDoc.get();
            Map<String, dynamic> data = updatedData.data() as Map<String, dynamic>;

            // Update state with new values
            setState(() {
                phone = data['phone'];
                address = data['address'];
                major = data['major'];
                university = data['university'];
                department = data['department'];
                year = data['year'];
                bio = data['bio'];
                interests = data['interests'];
                socialMedia = data['socialMedia'];
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
                                                _buildBioSection()
                                                    .animate()
                                                    .fadeIn(delay: 600.ms)
                                                    .slideX(begin: -0.2),
                                                SizedBox(height: 16),
                                                _buildInterestsSection()
                                                    .animate()
                                                    .fadeIn(delay: 800.ms)
                                                    .slideX(begin: 0.2),
                                                SizedBox(height: 16),
                                                _buildContactSection()
                                                    .animate()
                                                    .fadeIn(delay: 1000.ms)
                                                    .slideX(begin: -0.2),
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
                _buildInfoTile(Icons.location_on, 'Address', address ?? 'Not provided'),
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
                _buildInfoTile(
                    Icons.book, 
                    'Major', 
                    major ?? 'Not provided'
                ),
            ],
        );
    }

    Widget _buildBioSection() {
        return _buildSection(
            'About Me',
            Icons.info_outline,
            [
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                        bio ?? 'No bio provided',
                        style: TextStyle(
                            fontSize: 16,
                            color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                        ),
                    ),
                ),
            ],
        );
    }

    Widget _buildInterestsSection() {
        List<String> interestsList = (interests ?? '')
            .split(',')
            .where((interest) => interest.trim().isNotEmpty)
            .toList();

        return _buildSection(
            'Interests',
            Icons.favorite_outline,
            [
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: interestsList.isEmpty
                        ? Text(
                            'No interests added',
                            style: TextStyle(
                                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            ),
                        )
                        : Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                            children: interestsList
                            .map((interest) => Chip(
                                    label: Text(
                                        interest.trim(),
                                        style: TextStyle(
                                            color: isDarkMode 
                                                ? Colors.white 
                                                : Colors.blue[800],
                                        ),
                                    ),
                                    backgroundColor: isDarkMode 
                                        ? Colors.blue[900]!.withOpacity(0.2)
                                        : Colors.blue[50],
                                ))
                            .toList(),
                    ),
                ),
            ],
        );
    }

    Widget _buildContactSection() {
        return _buildSection(
            'Social Media',
            Icons.link,
            [
                _buildInfoTile(Icons.link, 'Social Links', socialMedia ?? 'Not provided'),
            ],
        );
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
                                _buildEditField('Major', majorController, Icons.book),
                                _buildCollegeDropdown(),
                                _buildDepartmentDropdown(),
                                _buildYearDropdown(),
                                _buildEditField('Bio', bioController, Icons.info_outline, maxLines: 3),
                                _buildEditField('Interests (comma-separated)', interestsController, Icons.favorite_outline),
                                _buildEditField('Social Media Links', socialMediaController, Icons.link),
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

    Widget _buildEditField(String label, TextEditingController controller, IconData icon, {int maxLines = 1}) {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
                controller: controller,
                maxLines: maxLines,
                decoration: InputDecoration(
                    labelText: label,
                    prefixIcon: Icon(icon),
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
