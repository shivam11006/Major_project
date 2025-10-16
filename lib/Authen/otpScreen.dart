import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../BottomNavigation/BottomNavigation.dart';
import '../Profile/RegisterationProfile.dart';
import 'PhoneNumberScreen.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OtpScreen({
    required this.verificationId,
    required this.phoneNumber,
    required bool isExistingUser,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _verifying = false;

  Future<void> _verifyOtp() async {
    if (_otpController.text.trim().length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid 6-digit OTP")),
      );
      return;
    }

    setState(() => _verifying = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _otpController.text.trim(),
      );

      await _auth.signInWithCredential(credential);

      final userDoc =
      await _firestore.collection('User').doc(widget.phoneNumber).get();

      setState(() => _verifying = false);

      if (userDoc.exists) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => BottomNavigation()),
              (route) => false,
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                RegistrationScreen(phoneNumber: widget.phoneNumber),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _verifying = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid OTP: ${e.message}")));
    } catch (e) {
      setState(() => _verifying = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff030A0E),
      resizeToAvoidBottomInset: true, // ✅ Prevent keyboard overlap
      appBar: AppBar(
        backgroundColor: const Color(0xff030A0E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => PhoneNumberScreen()),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              "assets/app_logo 1.png",
              height: 35,
            ),
          ),
        ],
        centerTitle: true,
      ),

      // ✅ Use SafeArea + SingleChildScrollView to handle smaller screens
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.asset("assets/otpScreen.png", height: 180),
                const SizedBox(height: 30),

                Text(
                  "Enter the 6-digit code sent to",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  widget.phoneNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // ✅ OTP Input Box
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white54),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _otpController,
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    style:
                    const TextStyle(color: Colors.white, letterSpacing: 8),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      counterText: "",
                      border: InputBorder.none,
                      hintText: "------",
                      hintStyle: TextStyle(
                          color: Colors.white54,
                          fontSize: 22,
                          letterSpacing: 10),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // ✅ Verify Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _verifying ? null : _verifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _verifying
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Verify & Continue",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Edit Phone Number",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),

                const SizedBox(height: 30), // ✅ Add bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }
}
