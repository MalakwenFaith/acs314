import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_acs315/views/clothes.dart';
import 'package:flutter_application_acs315/views/orders.dart';
import 'package:flutter_application_acs315/views/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // This keeps track of which page is currently shown
  int currentIndex = 0;

  // List of screens to display
  final List<Widget> screens = [
    const Clothes(),
    const Orders(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex], // show the current screen

      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.purpleAccent,
        index: currentIndex, // highlight the current icon
        items: const <Widget>[
          Icon(Icons.dashboard, size: 30, color: Colors.pinkAccent),
          Icon(Icons.category, size: 30, color: Colors.orangeAccent),
          Icon(Icons.person, size: 30, color: Colors.blueAccent),
        ],

        onTap: (index) {
          setState(() {
            currentIndex = index; // update the screen when icon is tapped
          });
        },
      ),
    );
  }
}
