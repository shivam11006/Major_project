import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../BottomNavigation/BottomNavigation.dart';
import '../DealerAuth/HomeScreen.dart';
import '../DealerAuth/HomeScreenDealer.dart';
import 'IntroScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  // ✅ Check if logged in and determine role (Farmer or Dealer)
  Future<void> _checkUser() async {
    await Future.delayed(const Duration(seconds: 3)); // Splash delay
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      // 🚫 Not logged in → IntroScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IntroScreen()),
      );
      return;
    }

    try {
      // Check in Dealer collection first
      DocumentSnapshot dealerDoc =
      await _firestore.collection('Dealer').doc(currentUser.email).get();

      if (dealerDoc.exists) {
        // 🧑‍💼 Dealer found
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPanel()),
        );
        return;
      }

      // Otherwise, check in User (Farmer) collection
      DocumentSnapshot userDoc =
      await _firestore.collection('User').doc(currentUser.email).get();

      if (userDoc.exists) {
        // 👨‍🌾 Farmer found
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavigation()),
        );
        return;
      }

      // If not found in either → treat as logged out
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IntroScreen()),
      );
    } catch (e) {
      print("Error checking user role: $e");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IntroScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          "assets/app_logo.png", // Your app logo
          height: 150,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
