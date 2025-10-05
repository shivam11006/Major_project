import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:majorproject/Controller/auth_controller.dart';
import 'package:majorproject/Screen/onBoardingScreen.dart';
import 'package:majorproject/auth/otpScreen.dart';

class AuthScreen extends StatefulWidget {



  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  bool enableButton = false;
  String phonenumber = "";


  getOtp() {
    PhoneAuthController.sendOtp(context, phonenumber);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff030A0E),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xff030A0E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OnBoardingScreen()),
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
                          "assets/number.png",
                          height: 250,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Phone Number Label
                      Text(
                        "Your Phone Number",
                        style: TextStyle(
                          color: Color(0xffAECCDD),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Phone Number Field
                      InternationalPhoneNumberInput(
                        onInputValidated: (value) {
                          setState(() {
                            enableButton = value;

                          });
                        },
                          onInputChanged: (value) {
                          phonenumber = value.phoneNumber!;

                          },
                        selectorConfig: const SelectorConfig(
                          useEmoji: true,
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,

                        ),
                        inputDecoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder()
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Section (Indicators + Button)
            SizedBox(
              width: double.infinity,
                child: FilledButton(
                    onPressed: enableButton ? getOtp:null,
                    child: Text("Get Otp"))),

            SizedBox(height: 30,),
            Text("Hello World")

          ],
        ),
      ),
    );
  }
}
