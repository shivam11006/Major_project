import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../HomeScreen/homeScreen.dart';
import '../Profile/profile.dart';
import 'DealerProfileScreen.dart';
import 'HomeScreen.dart';
import 'PostScreen.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int index = 1;

  final screens = [
    DearHomeScreen(),
    PostScreen(),
    DealerProfileScreen()
  ];

  final items = <Widget>[
    Icon(Icons.home, size: 30),
    Icon(Icons.add_box, size: 30),
    Icon(Icons.person, size: 30,)
  ];


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: screens[index],
      extendBody: true,
      backgroundColor: Colors.blueAccent,
      bottomNavigationBar: CurvedNavigationBar(
        // buttonBackgroundColor: Colors.green,
        backgroundColor: Colors.transparent,
        height: 70,
        index: index,
        items: items,
        onTap: (index) => setState(() => this.index = index),
      ),
    );
  }
}
