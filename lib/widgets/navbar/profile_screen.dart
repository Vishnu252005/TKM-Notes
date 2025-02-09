import 'package:flutter/material.dart'; // Import Flutter Material
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:dropdown_search/dropdown_search.dart';

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
        String emailInput = emailController.text; // Get email from controller
        String password = passwordController.text; // Get password from controller

        try {
            await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: emailInput,
                password: password,
            );

            // Fetch user data from Firestore
            DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get();
            String usernameInput = userDoc['username'];
            String phoneInput = userDoc['phone'];
            String addressInput = userDoc['address'];
            String majorInput = userDoc['major'];
            String universityInput = userDoc['university'];
            String yearInput = userDoc['year'];
            String bioInput = userDoc['bio'];
            String interestsInput = userDoc['interests'];
            String socialMediaInput = userDoc['socialMedia'];

            // Update state with user data
            setState(() {
                username = usernameInput;
                email = emailInput;
                phone = phoneInput;
                address = addressInput;
                major = majorInput;
                university = universityInput;
                year = yearInput;
                bio = bioInput;
                interests = interestsInput;
                socialMedia = socialMediaInput;
            });
        } on FirebaseAuthException catch (e) {
            // Handle sign-in error (e.g., show error message)
        }
    }

    // Method to handle password reset
    Future<void> resetPassword() async {
        String emailInput = emailController.text; // Get email from controller
        if (emailInput.isNotEmpty) {
            try {
                await FirebaseAuth.instance.sendPasswordResetEmail(email: emailInput);
                // Show a message to the user
                print("Password reset email sent!");
            } catch (e) {
                // Handle error (e.g., show error message)
                print("Error sending password reset email: $e");
            }
        } else {
            // Show a message to enter an email
            print("Please enter your email address.");
        }
    }

    // Method to update user profile
    Future<void> updateProfile() async {
        String phoneInput = phoneController.text; // Get phone number from controller
        String addressInput = addressController.text; // Get address from controller
        String majorInput = majorController.text; // Get major from controller
        String universityInput = universityController.text; // Get university from controller
        String yearInput = yearController.text; // Get year from controller
        String bioInput = bioController.text; // Get bio from controller
        String interestsInput = interestsController.text; // Get interests from controller
        String socialMediaInput = socialMediaController.text; // Get social media from controller

        try {
            await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).update({
                'phone': phoneInput,
                'address': addressInput,
                'major': majorInput,
                'university': universityInput,
                'year': yearInput,
                'bio': bioInput,
                'interests': interestsInput,
                'socialMedia': socialMediaInput,
            });

            // Update state with new values
            setState(() {
                phone = phoneInput;
                address = addressInput;
                major = majorInput;
                university = universityInput;
                year = yearInput;
                bio = bioInput;
                interests = interestsInput;
                socialMedia = socialMediaInput;
            });
        } catch (e) {
            // Handle error (e.g., show error message)
            print("Error updating profile: $e");
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: username == null
                ? _buildAuthScreen()
                : CustomScrollView(
                    slivers: [
                        SliverAppBar(
                            expandedHeight: 200.0,
                            floating: false,
                            pinned: true,
                            flexibleSpace: FlexibleSpaceBar(
                                background: Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [Colors.blue[800]!, Colors.blue[500]!],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                        ),
                                    ),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            CircleAvatar(
                                                radius: 50,
                                                backgroundColor: Colors.white,
                                                child: Icon(Icons.person, size: 50, color: Colors.blue[800]),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                                username ?? '',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                ),
                                            ),
                                        ],
                                    ),
                                ),
                            ),
                        ),
                        SliverToBoxAdapter(
                            child: Column(
                                children: [
                                    _buildProfileSection(),
                                    _buildEducationSection(),
                                    _buildBioSection(),
                                    _buildInterestsSection(),
                                    _buildContactSection(),
                                    SizedBox(height: 20),
                                ],
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
                _buildCollegeDropdown(),
                _buildDepartmentDropdown(),
                _buildYearDropdown(),
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
                        style: TextStyle(fontSize: 16),
                    ),
                ),
            ],
        );
    }

    Widget _buildInterestsSection() {
        return _buildSection(
            'Interests',
            Icons.favorite_outline,
            [
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: (interests?.split(',') ?? [])
                            .map((interest) => Chip(
                                    label: Text(interest.trim()),
                                    backgroundColor: Colors.blue[100],
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
        return Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                            children: [
                                Icon(icon, color: Colors.blue[800]),
                                SizedBox(width: 8),
                                Text(
                                    title,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[800],
                                    ),
                                ),
                            ],
                        ),
                    ),
                    Divider(height: 1),
                    ...children,
                ],
            ),
        );
    }

    Widget _buildInfoTile(IconData icon, String label, String value) {
        return ListTile(
            leading: Icon(icon, color: Colors.blue[800]),
            title: Text(
                label,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                ),
            ),
            subtitle: Text(
                value,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                ),
            ),
        );
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
                        selectedCollege = newValue;
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
                        selectedDepartment = newValue;
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
        return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.blue[100]!, Colors.white], // Gradient background
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                ),
            ),
            child: Center(
                child: username == null ? // Check if user is signed in
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                            elevation: 8, // Increased elevation for depth
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15), // Rounded corners
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(20.0),
                        child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                if (isSignUp)
                                    TextField(
                                                controller: usernameController,
                                                decoration: InputDecoration(
                                                    labelText: 'Username',
                                                    border: OutlineInputBorder(),
                                                ),
                                            ),
                                        SizedBox(height: 16),
                                TextField(
                                            controller: emailController,
                                            decoration: InputDecoration(
                                                labelText: 'Email',
                                                border: OutlineInputBorder(),
                                            ),
                                        ),
                                        SizedBox(height: 16),
                                TextField(
                                            controller: passwordController,
                                            decoration: InputDecoration(
                                                labelText: 'Password',
                                                border: OutlineInputBorder(),
                                            ),
                                    obscureText: true,
                                ),
                                SizedBox(height: 20),
                                        ElevatedButton.icon(
                                    onPressed: () {
                                        if (isSignUp) {
                                            signUp();
                                        } else {
                                            signIn();
                                        }
                                    },
                                            icon: Icon(Icons.login),
                                            label: Text(isSignUp ? 'Sign Up' : 'Sign In'),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blueAccent, // Button color
                                                padding: EdgeInsets.symmetric(vertical: 15),
                                            ),
                                        ),
                                TextButton(
                                            onPressed: resetPassword,
                                    child: Text('Forgot Password?'),
                                ),
                                TextButton(
                                    onPressed: () {
                                        setState(() {
                                                    isSignUp = !isSignUp;
                                        });
                                    },
                                    child: Text(isSignUp ? 'Already have an account? Sign In' : 'Don\'t have an account? Sign Up'),
                                ),
                            ],
                                ),
                            ),
                        ),
                    ) :
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                            ),
                                    child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                CircleAvatar(
                                                    radius: 50,
                                            child: Icon(Icons.person, size: 50),
                                                ),
                                                SizedBox(height: 20),
                                                Text('Hey $username', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                                SizedBox(height: 10),
                                        _buildProfileInfo(Icons.email, 'Email: $email'),
                                        _buildProfileInfo(Icons.phone, 'Phone: ${phone ?? "Not provided"}'),
                                        _buildProfileInfo(Icons.school, 'Major: ${major ?? "Not provided"}'),
                                        _buildProfileInfo(Icons.business, 'College: ${selectedCollege ?? "Not provided"}'),
                                        _buildProfileInfo(Icons.calendar_today, 'Year: ${selectedYear ?? "Not provided"}'),
                                        _buildProfileInfo(Icons.info, 'Bio: ${bio ?? "Not provided"}'),
                                        _buildProfileInfo(Icons.star, 'Interests: ${interests ?? "Not provided"}'),
                                        _buildProfileInfo(Icons.link, 'Social Media: ${socialMedia ?? "Not provided"}'),
                                SizedBox(height: 20),
                                ElevatedButton.icon(
                                    onPressed: () {
                                                _showEditProfileDialog();
                                    },
                                    icon: Icon(Icons.edit),
                                    label: Text('Edit Profile'),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blueAccent,
                                                padding: EdgeInsets.symmetric(vertical: 15),
                                            ),
                                        ),
                                    ],
                                ),
                            ),
                        ),
                    ),
            ),
        );
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
