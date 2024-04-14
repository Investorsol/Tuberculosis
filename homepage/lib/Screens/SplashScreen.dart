import 'package:flutter/material.dart';
import 'dart:async';
import './LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green, // Set your desired background color here
        child: Center(
            child: SizedBox(
                width: 150,
                height: 130,
                child: Column(
                  children: [
                    Container(
                      child: const ImageIcon(
                    AssetImage("image/link.png",),
                        size: 96,
                        color: Colors.white,
                ),
            ),
                    const Text(
                      'TB CONNECT',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,

                      ),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}