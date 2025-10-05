import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:majorproject/HomeScreen/homeScreen.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color(0xff030A0E),
      appBar: AppBar(
        backgroundColor: const Color(0xff030A0E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
          },
        ),
        actions: [
          Image.asset("assets/app_logo.png")
        ],
        centerTitle: true,
      ),
    );
  }

}