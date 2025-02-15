import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth if needed
import 'package:flutter_animate/flutter_animate.dart'; // Import the flutter_animate package
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class SignInScreen extends StatefulWidget {
    @override
    _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    bool isSignUp = false; // Toggle between sign-up and sign-in
    bool isDarkMode = false; // Variable to hold the theme mode

    @override
    void initState() {
        super.initState();
        _loadThemePreference(); // Load theme preference
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

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            theme: isDarkMode ? ThemeData.dark() : ThemeData.light(), // Set theme based on preference
            home: Scaffold(
                appBar: AppBar(
                    title: Text('Sign In'),
                    actions: [
                        IconButton(
                            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
                            onPressed: _toggleTheme, // Toggle theme on button press
                        ),
                    ],
                ),
                body: Center(
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Text(
                                    isSignUp ? 'Create Your Account' : 'Welcome Back!',
                                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                                ).animate().fadeIn(duration: 500.ms), // Animate the heading
                                SizedBox(height: 20),
                                Card(
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                                TextField(
                                                    controller: emailController,
                                                    decoration: InputDecoration(
                                                        labelText: 'Email',
                                                        border: OutlineInputBorder(),
                                                    ),
                                                ).animate().fadeIn(duration: 500.ms), // Animate the email field
                                                SizedBox(height: 16),
                                                TextField(
                                                    controller: passwordController,
                                                    decoration: InputDecoration(
                                                        labelText: 'Password',
                                                        border: OutlineInputBorder(),
                                                    ),
                                                    obscureText: true,
                                                ).animate().fadeIn(duration: 500.ms), // Animate the password field
                                                SizedBox(height: 20),
                                                ElevatedButton(
                                                    onPressed: () {
                                                        if (isSignUp) {
                                                            signUp();
                                                        } else {
                                                            signIn();
                                                        }
                                                    },
                                                    child: Text(isSignUp ? 'Sign Up' : 'Sign In'),
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.blueAccent,
                                                        padding: EdgeInsets.symmetric(vertical: 15),
                                                    ),
                                                ).animate().scale().fadeIn(duration: 500.ms), // Animate the button
                                                SizedBox(height: 20),
                                                if (!isSignUp)
                                                    TextButton(
                                                        onPressed: resetPassword,
                                                        child: Text('Forgot Password?'),
                                                    ).animate().fadeIn(duration: 500.ms), // Animate the forgot password button
                                                TextButton(
                                                    onPressed: () {
                                                        setState(() {
                                                            isSignUp = !isSignUp; // Toggle between sign-up and sign-in
                                                        });
                                                    },
                                                    child: Text(isSignUp ? 'Already have an account? Sign In' : 'Don\'t have an account? Sign Up'),
                                                ).animate().fadeIn(duration: 500.ms), // Animate the toggle button
                                            ],
                                        ),
                                    ),
                                ),
                            ],
                        ),
                    ),
                ),
            ),
        );
    }

    Future<void> signIn() async {
        // Implement your sign-in logic here
        String email = emailController.text;
        String password = passwordController.text;

        try {
            await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
            // Navigate to the profile screen or home screen after successful sign-in
            Navigator.of(context).pushReplacementNamed('/profile');
        } catch (e) {
            print("Error signing in: $e");
            // Handle sign-in error (e.g., show a message)
        }
    }

    Future<void> signUp() async {
        // Implement your sign-up logic here
        String email = emailController.text;
        String password = passwordController.text;

        try {
            await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
            // Navigate to the profile screen or home screen after successful sign-up
            Navigator.of(context).pushReplacementNamed('/profile');
        } catch (e) {
            print("Error signing up: $e");
            // Handle sign-up error (e.g., show a message)
        }
    }

    Future<void> resetPassword() async {
        // Implement the reset password logic here
        // This is a placeholder and should be replaced with the actual implementation
        print("Reset password method called");
    }
} 