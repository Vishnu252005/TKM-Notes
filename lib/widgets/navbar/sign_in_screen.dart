import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth if needed

class SignInScreen extends StatefulWidget {
    @override
    _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    bool isSignUp = false; // Toggle between sign-up and sign-in

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(isSignUp ? 'Sign Up' : 'Sign In'),
            ),
            body: Center(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
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
                                    ElevatedButton(
                                        onPressed: () {
                                            if (isSignUp) {
                                                // Call your sign-up method here
                                                signUp();
                                            } else {
                                                // Call your sign-in method here
                                                signIn();
                                            }
                                        },
                                        child: Text(isSignUp ? 'Sign Up' : 'Sign In'),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blueAccent,
                                            padding: EdgeInsets.symmetric(vertical: 15),
                                        ),
                                    ),
                                    SizedBox(height: 20),
                                    TextButton(
                                        onPressed: resetPassword,
                                        child: Text('Forgot Password?'),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                            setState(() {
                                                isSignUp = !isSignUp; // Toggle between sign-up and sign-in
                                            });
                                        },
                                        child: Text(isSignUp ? 'Already have an account? Sign In' : 'Don\'t have an account? Sign Up'),
                                    ),
                                ],
                            ),
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