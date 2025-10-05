import 'dart:async';
import 'package:flutter/material.dart';
import 'package:majorproject/auth/authScreen.dart';
import 'package:pinput/pinput.dart';
import '../Profile/RegisterationProfile.dart';

class OTPScreen extends StatefulWidget{

  const OTPScreen({super.key, required this.phoneNumber,required this.verificationId});

  final String phoneNumber;

  final String verificationId;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  // String otpCode = "";


  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,fontSize: 22
      ),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(6),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Theme.of(context).colorScheme.primary),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration ?.copyWith(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      ),
    );
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AuthScreen()),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Image.asset(
              "assets/app_logo.png",
              height: 40,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Farmer Illustration
                      Center(
                        child: Image.asset(
                          "assets/otpScreen.png",
                          height: 250,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Phone Number Label
                      Text(
                        "Enter Otp",
                        style: TextStyle(
                          // color: Color(0xffAECCDD),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Pinput(
                        length: 6,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        submittedPinTheme: submittedPinTheme,
                        // onChanged: (value){
                        //   setState(() {
                        //     otpCode = value;
                        //   });
                        // },
                        onCompleted: (value){
                          //Validate here

                        },
                      )

                    ],
                  ),
                ),
              ),
            ),

            // Bottom Section (Indicators + Button)


          ],
        ),
      ),
    );
  }
}