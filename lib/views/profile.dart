import 'package:flutter/material.dart';
import 'package:flutter_application_acs315/views/change_password.dart';
import 'package:flutter_application_acs315/views/orders.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String firstname = '';
  String lastname = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstname = prefs.getString('firstname') ?? '';
      lastname = prefs.getString('lastname') ?? '';
      email = prefs.getString('email') ?? '';
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // AVATAR
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.pink,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),

            // NAME
            Text(
              "$firstname $lastname",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),

            // EMAIL
            Text(
              email,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 30),
            const Divider(),

            // PROFILE OPTIONS
            _buildProfileOption(
              icon: Icons.shopping_bag_outlined,
              label: "My Orders",
              onTap: () => Get.to(() => const Orders()),
            ),
            _buildProfileOption(
              icon: Icons.lock_outline,
              label: "Change Password",
              onTap: () => Get.to(() => const ChangePasswordScreen()),
            ),
            _buildProfileOption(
              icon: Icons.help_outline,
              label: "Help & Support",
              onTap: () {},
            ),

            const SizedBox(height: 30),

            // LOGOUT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: logout,
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.pink),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
