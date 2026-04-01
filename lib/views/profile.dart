import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.pink,
      ),
      body: const Center(
        child: Text(
          "This is Profile Page",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
