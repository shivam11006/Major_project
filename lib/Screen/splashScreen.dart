import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../BottomNavigation/BottomNavigation.dart';
import '../DealerAuth/HomeScreenDealer.dart'; // AdminPanel screen for Dealer
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

  /// ✅ Checks whether user/dealer is logged in and routes accordingly
  Future<void> _checkUser() async {
    await Future.delayed(const Duration(seconds: 3)); // Splash delay

    User? currentUser = _auth.currentUser;

    // 🚫 If no user logged in → go to IntroScreen
    if (currentUser == null) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IntroScreen()),
      );
      return;
    }

    try {
      String? userEmail = currentUser.email;
      String? userPhone = currentUser.phoneNumber;

      // 1. Check Dealer Role (MUST use query on 'Email' field due to auto doc IDs)
      if (userEmail != null) {
        QuerySnapshot dealerQuery = await _firestore
            .collection('Dealer')
            .where('Email', isEqualTo: userEmail)
            .limit(1)
            .get();

        if (dealerQuery.docs.isNotEmpty) {
          // Dealer found → navigate to Dealer Home Screen (AdminPanel)
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminPanel()),
          );
          return;
        }
      }

      // 2. Check User Role (Assuming User document ID is the phone number, based on previous context)
      if (userPhone != null) {
        DocumentSnapshot userDoc = await _firestore
            .collection('User')
            .doc(userPhone) // Document ID is the phone number
            .get();

        if (userDoc.exists) {
          // User found → navigate to Bottom Navigation
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigation()),
          );
          return;
        }
      }

      // 🚫 If user is logged in but not found in either Dealer or User collection
      // (or if required identifiers like email/phone are missing) → log out and go to IntroScreen
      await _auth.signOut();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IntroScreen()),
      );
    } catch (e) {
      debugPrint("Error checking user role: $e");
      // Fallback on error
      if (!mounted) return;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/app_logo.png",
              height: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Colors.green,
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}
