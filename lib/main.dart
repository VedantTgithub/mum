import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Add this import for Firebase
import 'package:mumbaihacksfinal/loginpage.dart';
import 'package:mumbaihacksfinal/registrationcorp.dart';
import 'registration.dart';

// Initialize Firebase asynchronously
Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that widget binding is initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MumbaiHacks',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // Set the initial screen to LoginPage
    );
  }
}
