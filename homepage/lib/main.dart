import 'dart:async';
import 'package:flutter/material.dart';
import 'package:homepage/LoginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App', // Added comma here
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Show splash screen first
      routes: {
        '/login': (context) => LoginScreen(), // Define route for login screen
      },
    );
  }
}


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start a timer for 2 seconds
    Timer(Duration(seconds: 2), () {
      // Navigate to login screen after 2 seconds
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green, // Set your desired background color here
        child: Center(
          child: Text(
            'TB CONNECT',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,

            ),
          ),
        ),
      ),
    );
  }
}