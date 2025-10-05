import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Widgets/uiHelper.dart';
import 'DealerProfileScreen.dart';
import 'deallerAuth.dart';

class DealerSignUpScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0E363E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/app_logo.png"),
            SizedBox(
              height: 30,
            ),
            UiHelper.CustomTextField(
              controller: emailController,
              text: "Email",
              tohide: false,
            ),
            SizedBox(
              height: 10,
            ),
            UiHelper.CustomTextField(
              controller: passwordController,
              text: "Password",
              tohide: true,
            ),
            SizedBox(
              height: 10,
            ),
            UiHelper.CustomTextField(
              controller: usernameController,
              text: "Username",
              tohide: false,
            ),
            SizedBox(
              height: 30,
            ),
            UiHelper.CustomButton(callback: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> DealerProfileScreen()));
            }, buttonname: "Sign Up"),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> DealerProfileScreen()));
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: const Color(0xff57B427),
            //       padding: const EdgeInsets.symmetric(vertical: 16),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //     ),
            //     child: const Text(
            //       'Next',
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 18,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an Account?",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                UiHelper.CustomTextButton(
                    callback: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DealerAuthLogin()));
                    },
                    text: "Sign In")
              ],
            )
          ],
        ),
      ),
    );
  }
}