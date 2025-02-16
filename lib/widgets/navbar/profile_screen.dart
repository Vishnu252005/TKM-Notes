import 'package:flutter/material.dart'; // Import Flutter Material
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:flutter_animate/flutter_animate.dart'; // Import the flutter_animate package
import 'package:flutter/rendering.dart'; // Import flutter rendering
import 'package:flutter/services.dart'; // Add this import for HapticFeedback

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
        String usernameInput = usernameController.text; // Get username from controller
        String emailInput = emailController.text; // Get email from controller
        String password = passwordController.text; // Get password from controller

        try {
            UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: emailInput,
                password: password,
            );

            // Add user data to Firestore
            await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
                'username': usernameInput,
                'email': emailInput,
                'phone': null, // Initialize phone as null
                'address': null, // Initialize address as null
                'major': null, // Initialize major as null
                'university': null, // Initialize university as null
                'year': null, // Initialize year as null
                'bio': null, // Initialize bio as null
                'interests': null, // Initialize interests as null
                'socialMedia': null, // Initialize social media as null
            });

            // Update state with user data
            setState(() {
                username = usernameInput;
                email = emailInput;
                phone = null; // Set to null initially
                address = null; // Set to null initially
                major = null; // Set to null initially
                university = null; // Set to null initially
                year = null; // Set to null initially
                bio = null; // Set to null initially
                interests = null; // Set to null initially
                socialMedia = null; // Set to null initially
            });
        } on FirebaseAuthException catch (e) {
            // Handle sign-up error (e.g., show error message)
        }
    }

    // Method to handle sign-in
    Future<void> signIn() async {
        String emailInput = emailController.text;
        String password = passwordController.text;

        try {
            await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: emailInput,
                password: password,
            );

            // Save user credentials to SharedPreferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('email', emailInput);
            await prefs.setString('password', password);

            // Fetch user data from Firestore
            DocumentSnapshot userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .get();

            // Update state with all user data
            setState(() {
                username = userDoc.get('username') ?? '';
                email = userDoc.get('email') ?? '';
                phone = userDoc.get('phone') ?? 'Not provided';
                address = userDoc.get('address') ?? 'Not provided';
                major = userDoc.get('major') ?? 'Not provided';
                university = userDoc.get('university') ?? 'Not provided';
                year = userDoc.get('year') ?? 'Not provided';
                department = userDoc.get('department') ?? 'Not provided';
                bio = userDoc.get('bio') ?? 'No bio provided';
                interests = userDoc.get('interests') ?? 'No interests added';
                socialMedia = userDoc.get('socialMedia') ?? 'Not provided';
                
                // Update the controllers for edit profile dialog
                phoneController.text = phone ?? '';
                addressController.text = address ?? '';
                majorController.text = major ?? '';
                selectedCollege = university;
                selectedYear = year;
                selectedDepartment = department;
                bioController.text = bio ?? '';
                interestsController.text = interests ?? '';
                socialMediaController.text = socialMedia ?? '';
            });
        } on FirebaseAuthException catch (e) {
            // Handle sign-in error
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error signing in: ${e.message}")),
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
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Password reset email sent! Check your inbox.")),
                );
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
        String phoneInput = phoneController.text; // Get phone number from controller
        String addressInput = addressController.text; // Get address from controller
        String majorInput = majorController.text; // Get major from controller
        String universityInput = selectedCollege ?? ''; // Provide default value if null
        String yearInput = selectedYear ?? ''; // Provide default value if null
        String departmentInput = selectedDepartment ?? ''; // Provide default value if null
        String bioInput = bioController.text; // Get bio from controller
        String interestsInput = interestsController.text; // Get interests from controller
        String socialMediaInput = socialMediaController.text; // Get social media from controller

        try {
            await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).update({
                'phone': phoneInput,
                'address': addressInput,
                'major': majorInput,
                'university': universityInput, // Update university
                'year': yearInput, // Update year
                'department': departmentInput, // Update department
                'bio': bioInput,
                'interests': interestsInput,
                'socialMedia': socialMediaInput,
            });

            // Update state with new values
            setState(() {
                phone = phoneInput;
                address = addressInput;
                major = majorInput;
                university = universityInput; // Update state for university
                year = yearInput; // Update state for year
                department = departmentInput; // Update state for department
                bio = bioInput;
                interests = interestsInput;
                socialMedia = socialMediaInput;
            });
        } catch (e) {
            // Handle error (e.g., show error message)
            print("Error updating profile: $e");
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
        return MaterialApp(
            theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
            home: Scaffold(
                body: Stack(  // Wrap with Stack to overlay the theme button
                    children: [
                        // Main content
                        username == null
                    ? _buildAuthScreen()
                            : SingleChildScrollView(
                        child: Column(
                            children: [
                                        // Top profile section with animation
                                Container(
                                            width: double.infinity,
                                    height: 200.0,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                                    colors: isDarkMode 
                                                        ? [Color(0xFF1A1A2E), Color(0xFF16213E)]
                                                        : [Colors.blue[800]!, Colors.blue[500]!],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                        ),
                                    ),
                                            child: SafeArea(
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            CircleAvatar(
                                                radius: 50,
                                                backgroundColor: Colors.white,
                                                child: Icon(Icons.person, size: 50, color: Colors.blue[800]),
                                                        )
                                                            .animate()
                                                            .fadeIn(duration: 600.ms)
                                                            .scale(delay: 200.ms)
                                                            .then()
                                                            .shimmer(duration: 1200.ms),
                                            SizedBox(height: 10),
                                            Text(
                                                username ?? '',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                                shadows: [
                                                                    Shadow(
                                                                        offset: Offset(0, 2),
                                                                        blurRadius: 4,
                                                                        color: Colors.black.withOpacity(0.3),
                                                                    ),
                                                                ],
                                                            ),
                                                        )
                                                            .animate()
                                                            .fadeIn(delay: 400.ms)
                                                            .slideY(begin: 0.3),
                                            SizedBox(height: 10),
                                            Text(
                                                'Welcome to Your Profile',
                                                style: TextStyle(
                                                                color: Colors.white.withOpacity(0.9),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                ),
                                                        )
                                                            .animate()
                                                            .fadeIn(delay: 600.ms)
                                                            .slideY(begin: 0.3),
                                        ],
                                    ),
                                ),
                                        )
                                            .animate()
                                            .fadeIn()
                                            .slide(),

                                        // Profile sections with staggered animations
                                        Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 16),
                                            child: Column(
                                                children: [
                                SizedBox(height: 20),
                                                    _buildProfileSection()
                                                        .animate()
                                                        .fadeIn(delay: 200.ms)
                                                        .slideX(begin: -0.2),
                                                    
                                                    _buildEducationSection()
                                                        .animate()
                                                        .fadeIn(delay: 400.ms)
                                                        .slideX(begin: 0.2),
                                                    
                                                    _buildBioSection()
                                                        .animate()
                                                        .fadeIn(delay: 600.ms)
                                                        .slideX(begin: -0.2),
                                                    
                                                    _buildInterestsSection()
                                                        .animate()
                                                        .fadeIn(delay: 800.ms)
                                                        .slideX(begin: 0.2),
                                                    
                                                    _buildContactSection()
                                                        .animate()
                                                        .fadeIn(delay: 1000.ms)
                                                        .slideX(begin: -0.2),
                                                    
                                SizedBox(height: 20),
                                                    
                                                    // Animated logout button
                                ElevatedButton(
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
                                                                Icon(Icons.logout),
                                                                SizedBox(width: 8),
                                                                Text(
                                                                    'Logout',
                                                                    style: TextStyle(
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.bold,
                                                                    ),
                                                                ),
                                                            ],
                                                        ),
                                                    )
                                                        .animate()
                                                        .fadeIn(delay: 1200.ms)
                                                        .scale(delay: 1200.ms)
                                                        .shimmer(delay: 1200.ms),
                                                    
                                SizedBox(height: 20),
                            ],
                        ),
                                        ),
                                    ],
                                ),
                            ),
                        
                        // Theme toggle button - positioned at top right
                        Positioned(
                            top: MediaQuery.of(context).padding.top + 10,  // Account for status bar
                            right: 16,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: isDarkMode 
                                        ? Colors.white.withOpacity(0.1)
                                        : Colors.black.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                    icon: Icon(
                                        isDarkMode ? Icons.wb_sunny : Icons.nights_stay,
                                        color: isDarkMode ? Colors.white : Colors.black,
                                    ),
                                    onPressed: () {
                                        _toggleTheme();
                                        HapticFeedback.lightImpact();
                                    },
                                ),
                            )
                                .animate()
                                .scale(
                                    duration: 200.ms,
                                    curve: Curves.easeInOut,
                                ),
                        ),
                    ],
                    ),
                floatingActionButton: username != null
                    ? FloatingActionButton(
                        onPressed: _showEditProfileDialog,
                        child: Icon(Icons.edit),
                        backgroundColor: Colors.blue[800],
                    )
                    : null,
            ),
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
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
                elevation: isDarkMode ? 8 : 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                        color: isDarkMode 
                            ? Colors.blue[700]!.withOpacity(0.2)
                            : Colors.grey[300]!,
                        width: 1,
                    ),
                ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                        Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: isDarkMode
                                        ? [Color(0xFF1E1E30), Color(0xFF2A2A40)]
                                        : [Colors.blue[50]!, Colors.white],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                ),
                            ),
                            padding: EdgeInsets.all(16),
                        child: Row(
                            children: [
                                    Icon(
                                        icon,
                                        color: isDarkMode ? Colors.blue[400] : Colors.blue[800],
                                        size: 24,
                                    )
                                        .animate()
                                        .scale(duration: 300.ms)
                                        .then()
                                        .shimmer(duration: 1200.ms),
                                    SizedBox(width: 12),
                                Text(
                                    title,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                            color: isDarkMode ? Colors.white : Colors.blue[800],
                                    ),
                                    )
                                        .animate()
                                        .fadeIn(duration: 400.ms)
                                        .slideX(begin: 0.2),
                            ],
                        ),
                    ),
                    Divider(height: 1),
                        ...children.map((child) => 
                            child
                                .animate()
                                .fadeIn(duration: 400.ms)
                                .slideY(begin: 0.1)
                        ).toList(),
                    ],
                ),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(delay: 200.ms),
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
        // Define better dark mode colors
        final darkBgGradient = [
            Color(0xFF1A1A2E),  // Deep blue-black
            Color(0xFF16213E),  // Rich dark blue
        ];
        
        final darkCardColor = Color(0xFF1E1E30);  // Slightly lighter than background
        final darkPrimaryColor = Colors.blue[400]!;  // Brighter blue for dark mode
        final darkTextColor = Colors.grey[100]!;
        final darkSecondaryTextColor = Colors.grey[300]!;
        final darkInputBgColor = Color(0xFF2A2A40);  // Slightly lighter than card

        return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: isDarkMode 
                        ? darkBgGradient
                        : [Colors.blue[100]!, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                ),
            ),
            child: Center(
                child: SingleChildScrollView(
                child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                            children: [
                                // Logo/Icon Section with improved dark mode color
                                Icon(
                                    Icons.person_outline,
                                    size: 80,
                                    color: isDarkMode ? darkPrimaryColor : Colors.blue[800],
                                )
                                    .animate()
                                    .scale(duration: 600.ms, curve: Curves.easeOut)
                                    .then()
                                    .shimmer(duration: 1200.ms),
                                
                                SizedBox(height: 30),
                                
                                // Main Card with improved dark mode styling
                                Card(
                                    elevation: isDarkMode ? 20 : 12,  // Higher elevation in dark mode
                        shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: isDarkMode 
                                            ? BorderSide(color: darkPrimaryColor.withOpacity(0.1), width: 1)
                                            : BorderSide.none,
                        ),
                                    color: isDarkMode ? darkCardColor : Colors.white,
                        child: Padding(
                                        padding: const EdgeInsets.all(24.0),
                            child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                                // Title with improved dark mode color
                                    Text(
                                                    isSignUp ? 'Create Account' : 'Welcome Back',
                                        style: TextStyle(
                                                        fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                                        color: isDarkMode ? darkTextColor : Colors.blue[800],
                                                    ),
                                                    textAlign: TextAlign.center,
                                                )
                                                    .animate()
                                                    .fadeIn(duration: 500.ms)
                                                    .slideY(begin: -0.2),
                                                
                                                SizedBox(height: 8),
                                                
                                                // Subtitle with improved dark mode color
                                                Text(
                                                    isSignUp 
                                                        ? 'Join our community today!'
                                                        : 'Sign in to continue',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: isDarkMode ? darkSecondaryTextColor : Colors.grey[600],
                                                    ),
                                                    textAlign: TextAlign.center,
                                                )
                                                    .animate()
                                                    .fadeIn(duration: 500.ms, delay: 200.ms)
                                                    .slideY(begin: -0.2),
                                                
                                                SizedBox(height: 32),
                                                
                                                // Form Fields
                                    if (isSignUp)
                                                    _buildAnimatedTextField(
                                            controller: usernameController,
                                                        icon: Icons.person,
                                                        label: 'Username',
                                                        delay: 0,
                                                    ),
                                                
                                                SizedBox(height: isSignUp ? 16 : 0),
                                                
                                                _buildAnimatedTextField(
                                        controller: emailController,
                                                    icon: Icons.email,
                                                    label: 'Email',
                                                    delay: isSignUp ? 200 : 0,
                                                ),
                                                
                                    SizedBox(height: 16),
                                                
                                                _buildAnimatedTextField(
                                        controller: passwordController,
                                                    icon: Icons.lock,
                                                    label: 'Password',
                                                    isPassword: true,
                                                    delay: isSignUp ? 400 : 200,
                                                ),
                                                
                                                SizedBox(height: 24),
                                                
                                                // Toggle Sign In/Sign Up - Moved up
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
                                                                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                                                    ),
                                                                ),
                                                                TextSpan(
                                                                    text: isSignUp ? 'Sign In' : 'Sign Up',
                                                                    style: TextStyle(
                                                                        color: isDarkMode ? Colors.blue[300] : Colors.blue[700],
                                                                        fontWeight: FontWeight.bold,
                                                                    ),
                                                                ),
                                                            ],
                                                        ),
                                                    ),
                                                )
                                                    .animate()
                                                    .fadeIn(duration: 500.ms, delay: 600.ms),
                                                
                                                SizedBox(height: 16),
                                                
                                                // Main Button
                                                ElevatedButton(
                                        onPressed: () {
                                            if (isSignUp) {
                                                signUp();
                                            } else {
                                                signIn();
                                            }
                                        },
                                        style: ElevatedButton.styleFrom(
                                                        backgroundColor: isDarkMode ? darkPrimaryColor : Colors.blue[600],
                                                        padding: EdgeInsets.symmetric(vertical: 16),
                                                        elevation: isDarkMode ? 8 : 4,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(12),
                                                        ),
                                                    ),
                                                    child: Text(
                                                        isSignUp ? 'Create Account' : 'Sign In',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                            color: isDarkMode ? Colors.white : Colors.white,
                                                        ),
                                                    ),
                                                )
                                                    .animate()
                                                    .fadeIn(duration: 500.ms, delay: 800.ms)
                                                    .slideY(begin: 0.2),
                                                
                                                // Forgot Password - Only show in sign in mode
                                                if (!isSignUp) ...[
                                                    SizedBox(height: 16),
                                    TextButton(
                                                        onPressed: resetPassword,
                                                        child: Text(
                                                            'Forgot Password?',
                                                            style: TextStyle(
                                                                color: isDarkMode ? Colors.blue[300] : Colors.blue[700],
                                                            ),
                                                        ),
                                                    )
                                                        .animate()
                                                        .fadeIn(duration: 500.ms, delay: 1000.ms),
                                                ],
                                            ],
                                        ),
                                    ),
                                )
                                    .animate()
                                    .fadeIn(duration: 600.ms)
                                    .scaleXY(begin: 0.8),
                                
                                SizedBox(height: 24),
                            ],
                        ),
                    ),
                ),
            ),
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
