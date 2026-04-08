import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_acs315/cart.dart';
import 'package:flutter_application_acs315/views/clothes.dart';
import 'package:flutter_application_acs315/views/orders.dart';
import 'package:flutter_application_acs315/views/profile.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [
    const Clothes(),
    const Orders(),
    const Profile(),
  ];

  String _getTitle() {
    switch (currentIndex) {
      case 0:
        return "Clothes";
      case 1:
        return "My Orders";
      case 2:
        return "Profile";
      default:
        return "Home";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        backgroundColor: Colors.pink,
        automaticallyImplyLeading: false,
        actions: [
          // Cart icon — visible on all tabs
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () => Get.to(() => const CartScreen()),
          ),
        ],
      ),
      body: screens[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.pink,
        buttonBackgroundColor: Colors.pink,
        animationDuration: const Duration(milliseconds: 300),
        index: currentIndex,
        items: const <Widget>[
          Icon(Icons.checkroom, size: 30, color: Colors.white),
          Icon(Icons.shopping_bag, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
