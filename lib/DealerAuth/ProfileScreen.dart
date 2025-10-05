import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DealerProfileScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0E363E),
      body: Center(
        child: Text(
          "Admin Profile",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
