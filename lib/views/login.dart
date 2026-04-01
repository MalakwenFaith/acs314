import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_acs315/controllerss/logincontrollers.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

Logincontrollers loginController = Get.put(Logincontrollers());
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // LOGO
            Image.asset(
              "assets/images/logo.png",
              width: 200,
            ),
            const SizedBox(height: 70),
            // USERNAME PADDNG
            const Padding(
              padding: EdgeInsets.fromLTRB(25, 0, 20, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Enter your Email",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // USERNAME FIELD
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email ",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // PASSWORD LABEL
            const Padding(
              padding: EdgeInsets.fromLTRB(25, 0, 20, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Enter Password",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // PASSWORD FIELD
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Obx(
                () => TextField(
                  controller: passwordController,
                  obscureText: !loginController.passwordVisible.value,
                  decoration: InputDecoration(
                    hintText: "PIN or Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: GestureDetector(
                        child: Icon(
                          loginController.passwordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onTap: () {
                          loginController.togglePassword();
                        }),
                  ),
                ),
              ),
            ),

            // SIGN UP TEXT (CLICKABLE)

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () {
                    Get.toNamed("/signup");
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // LOGIN BUTTON
            MaterialButton(
              onPressed: () async {
                print("button");
                if (emailController.text.isEmpty) {
                  Get.snackbar("Error", "Enter your email");
                } else if (passwordController.text.isEmpty) {
                  Get.snackbar("Error", "Enter your password");
                } else {
                  print("button clicked");
                  final response = await http.get(Uri.parse(
                      // "http://localhost/flutter_api/login.php?email=daisyleen@gmail.com&password=123456"
                      "http://localhost/flutter_api/login.php?email=${emailController.text}&password=${passwordController.text}"));
                  print(response.body);
                  if (response.statusCode == 200) {
                    final serverData = jsonDecode(response.body);
                    if (serverData['success'] == 1) {
                      String email = serverData["data"]["email"];
                      print(email); //store in shared preferences
                      Get.toNamed('/homescreen');
                    } else {
                      Get.snackbar("Wrong Credentials", serverData["message"]);
                    }
                  } else {
                    Get.snackbar(
                        "Server Error", "Error occured while logging in");
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
