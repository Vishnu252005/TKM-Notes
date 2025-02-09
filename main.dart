import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'lib/widgets/navbar/profile_screen.dart'; // Import your ProfileScreen
import 'lib/widgets/navbar/sign_in_screen.dart'; // Import your SignInScreen
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core

void main() async {
    WidgetsFlutterBinding.ensureInitialized(); // Ensure binding is initialized
    await Firebase.initializeApp(); // Initialize Firebase
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Your App',
            initialRoute: '/',
            routes: {
                '/': (context) => HomeScreen(), // Your home screen
                '/signin': (context) => SignInScreen(), // Your sign-in screen
                '/signup': (context) => SignUpScreen(), // Your sign-up screen
                '/profile': (context) => ProfileScreen(), // Your profile screen
            },
        );
    }
}

class HomeScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        // Check if the user is signed in
        return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                    // User is signed in
                    if (snapshot.hasData) {
                        return ProfileScreen(); // Navigate to profile if signed in
                    } else {
                        return SignInScreen(); // Navigate to sign-in if not signed in
                    }
                }
                // Show a loading indicator while checking auth state
                return Center(child: CircularProgressIndicator());
            },
        );
    }
} 