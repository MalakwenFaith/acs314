import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool oldVisible = false;
  bool newVisible = false;
  bool confirmVisible = false;
  bool isLoading = false;

  Future<void> changePassword() async {
    final oldPass = oldPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    // VALIDATION
    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      Get.snackbar("Error", "All fields are required",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (newPass.length < 6) {
      Get.snackbar("Error", "New password must be at least 6 characters",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (newPass != confirmPass) {
      Get.snackbar("Error", "New passwords do not match",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (newPass == oldPass) {
      Get.snackbar("Error", "New password cannot be the same as old password",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';

    final response = await http.post(
      Uri.parse("http://localhost/flutter_api/change_password.php"),
      body: {
        "email": email,
        "old_password": oldPass,
        "new_password": newPass,
      },
    );

    setState(() => isLoading = false);

    final data = jsonDecode(response.body);

    if (data['success'] == 1) {
      Get.snackbar(
        "Success",
        "Password changed successfully",
        backgroundColor: Colors.pink,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back(); // go back to profile
    } else {
      Get.snackbar("Error", data['message'],
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // LOCK ICON
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.pink,
              child: Icon(Icons.lock_outline, size: 40, color: Colors.white),
            ),

            const SizedBox(height: 30),

            // OLD PASSWORD
            _buildPasswordField(
              controller: oldPasswordController,
              label: "Current Password",
              isVisible: oldVisible,
              onToggle: () => setState(() => oldVisible = !oldVisible),
            ),

            const SizedBox(height: 16),

            // NEW PASSWORD
            _buildPasswordField(
              controller: newPasswordController,
              label: "New Password",
              isVisible: newVisible,
              onToggle: () => setState(() => newVisible = !newVisible),
            ),

            const SizedBox(height: 16),

            // CONFIRM PASSWORD
            _buildPasswordField(
              controller: confirmPasswordController,
              label: "Confirm New Password",
              isVisible: confirmVisible,
              onToggle: () => setState(() => confirmVisible = !confirmVisible),
            ),

            const SizedBox(height: 30),

            // SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Update Password",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock, color: Colors.pink),
        suffixIcon: GestureDetector(
          onTap: onToggle,
          child: Icon(
            isVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.pink, width: 1.5),
        ),
      ),
    );
  }
}
