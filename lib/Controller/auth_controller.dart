import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Profile/RegisterationProfile.dart';
import '../auth/otpScreen.dart';

class PhoneAuthController {
  static final _auth = FirebaseAuth.instance;
  static Future<void> sendOtp(BuildContext context, String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) {},
        verificationFailed: (error) {
          if (error.code == "invalid-phone-number") {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text("Invalid Phone number")));
          }
          if (error.code == "too-many-requests") {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text("Too many requests")));
          } else {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text("Something went wrong")));
          }
        },
        codeSent: (verificationId, forceResendingToken) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                phoneNumber: phoneNumber,
                verificationId: verificationId,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(error.message ?? "Something went wrong")),
        );
    } catch (e) {
      print(e);
    }finally {}
  }


  static Future<void> verifyOtp(BuildContext context, String verificationId, String smsCode) async {
    try {

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      if(!context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RegistrationProfile(),
        ),
      );
    }on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(error.message ?? "Something went wrong")),
        );
    } catch (e) {
      print(e);
    }
  }
}



