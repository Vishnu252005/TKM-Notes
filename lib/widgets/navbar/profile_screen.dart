import 'package:flutter/material.dart'; // Import Flutter Material
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class ProfileScreen extends StatelessWidget {
    final TextEditingController usernameController = TextEditingController(); // Controller for username
    final TextEditingController emailController = TextEditingController(); // Controller for email
    final TextEditingController passwordController = TextEditingController(); // Controller for password

    // Method to handle sign-up
    Future<void> signUp() async {
        String username = usernameController.text; // Get username from controller
        String email = emailController.text; // Get email from controller
        String password = passwordController.text; // Get password from controller

        try {
            UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: email,
                password: password,
            );

            // Add user data to Firestore
            await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
                'username': username,
                'email': email,
            });

            // Handle successful sign-up (e.g., navigate to another screen)
        } on FirebaseAuthException catch (e) {
            // Handle sign-up error (e.g., show error message)
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Profile'),
            ),
            body: Center(
                child: Column(
                    children: [
                        // Existing UI elements...

                        // Add TextField for username
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
                                // Call signUp method
                                signUp();
                            },
                            child: Text('Sign Up'),
                        ),
                    ],
                ),
            ),
        );
    }
}
