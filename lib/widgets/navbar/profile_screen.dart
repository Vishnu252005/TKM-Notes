import 'package:flutter/material.dart'; // Import Flutter Material
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class ProfileScreen extends StatefulWidget {
    @override
    _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
    final TextEditingController usernameController = TextEditingController(); // Controller for username
    final TextEditingController emailController = TextEditingController(); // Controller for email
    final TextEditingController passwordController = TextEditingController(); // Controller for password

    bool isSignUp = true; // Toggle between sign-up and sign-in
    String? username; // Store username
    String? email; // Store email

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
            });

            // Update state with user data
            setState(() {
                username = usernameInput;
                email = emailInput;
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

            // Update state with user data
            setState(() {
                username = usernameInput;
                email = emailInput;
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

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(username != null ? 'Profile' : (isSignUp ? 'Sign Up' : 'Sign In')),
            ),
            body: Center(
                child: username == null ? // Check if user is signed in
                    Column(
                        children: [
                            // Add TextField for username (only for sign-up)
                            if (isSignUp)
                                TextField(
                                    controller: usernameController, // Use controller
                                    decoration: InputDecoration(labelText: 'Username'),
                                ),
                            // Add TextFields for email and password
                            TextField(
                                controller: emailController, // Use controller
                                decoration: InputDecoration(labelText: 'Email'),
                            ),
                            TextField(
                                controller: passwordController, // Use controller
                                decoration: InputDecoration(labelText: 'Password'),
                                obscureText: true,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                    // Call signUp or signIn method based on the toggle
                                    if (isSignUp) {
                                        signUp();
                                    } else {
                                        signIn();
                                    }
                                },
                                child: Text(isSignUp ? 'Sign Up' : 'Sign In'),
                            ),
                            // Add Forgot Password button
                            TextButton(
                                onPressed: () {
                                    // Call resetPassword method
                                    resetPassword();
                                },
                                child: Text('Forgot Password?'),
                            ),
                            // Toggle between Sign Up and Sign In
                            TextButton(
                                onPressed: () {
                                    setState(() {
                                        isSignUp = !isSignUp; // Toggle the boolean
                                    });
                                },
                                child: Text(isSignUp ? 'Already have an account? Sign In' : 'Don\'t have an account? Sign Up'),
                            ),
                        ],
                    ) :
                    // Profile view
                    Column(
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
