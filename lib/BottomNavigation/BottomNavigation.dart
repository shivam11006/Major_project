import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:majorproject/DealerAuth/PostScreen.dart';
import 'package:majorproject/Profile/profile.dart';

import '../HomeScreen/homeScreen.dart';
import '../Services/ServicesScreen.dart';

class BottomNavigation extends StatefulWidget {
  @override
  State<BottomNavigation> createState() => _BottomNavigationState();

}

class _BottomNavigationState extends State<BottomNavigation> {

  int index = 0;

  final screens = [
    HomeScreen(),
    ServicesScreen(),
    PostScreen(),
    ProfileScreen()
  ];

  final items = <Widget>[
    Icon(Icons.home, size: 30),
    Icon(Icons.calculate,size: 30,),
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