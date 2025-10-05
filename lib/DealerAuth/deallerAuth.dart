import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Widgets/uiHelper.dart';
import 'HomeScreenDealer.dart';
import 'SignUp.dart';

class DealerAuthLogin extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
              height: 20,
            ),
            UiHelper.CustomTextField(
                controller: emailController,text: "Email", tohide: false),
            SizedBox(
              height: 15,
            ),
            UiHelper.CustomTextField(
                controller: passwordController, text: "Password", tohide: true),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: UiHelper.CustomTextButton(
                      text: "Forgot password?", callback: () {}),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            UiHelper.CustomButton(callback: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AdminPanel()));
            }, buttonname: "Log In"),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "OR",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Color(0XFFAECCDD)),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?",style: TextStyle(fontSize: 14,color: Colors.white),),
                UiHelper.CustomTextButton(text: "Sign Up", callback: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> DealerSignUpScreen()));
                })
              ],)
          ],
        ),
      ),
    );
  }
}