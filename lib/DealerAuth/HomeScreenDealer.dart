import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'DealerProfileScreen.dart';
import 'HomeScreen.dart';
import 'PostScreen.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int _selectedIndex = 0;

  final screens = [
    DearHomeScreen(), // ✅ Make sure this class exists
    PostScreen(),
    DealerProfileScreen(),
  ];

  final items = <Widget>[
    Icon(Icons.home, size: 30),
    Icon(Icons.add_box, size: 30),
    Icon(Icons.person, size: 30),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: screens[_selectedIndex], // ✅ Display selected screen
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.white,
        height: 60,
        index: _selectedIndex,
        items: items,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
