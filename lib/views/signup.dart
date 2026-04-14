import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_acs315/controllerss/signupcontroller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

Signupcontroller signupController = Get.put(Signupcontroller());

// Controllers
TextEditingController phoneController = TextEditingController(); // ID
TextEditingController firstnameController = TextEditingController();
TextEditingController lastnameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.asset("assets/images/logo.png", width: 200),
              const SizedBox(height: 70),

              // (ID)
              const Padding(
                padding: EdgeInsets.fromLTRB(25, 0, 20, 5),
                child: Row(
                  children: [
                    Text("Enter Phone Number",
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // FIRST NAME
              const Padding(
                padding: EdgeInsets.fromLTRB(25, 0, 20, 5),
                child: Row(
                  children: [
                    Text("First Name",
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  controller: firstnameController,
                  decoration: InputDecoration(
                    hintText: "First Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // LAST NAME
              const Padding(
                padding: EdgeInsets.fromLTRB(25, 0, 20, 5),
                child: Row(
                  children: [
                    Text("Last Name",
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  controller: lastnameController,
                  decoration: InputDecoration(
                    hintText: "Last Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // EMAIL
              const Padding(
                padding: EdgeInsets.fromLTRB(25, 0, 20, 5),
                child: Row(
                  children: [
                    Text("Enter Email",
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email Address",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // PASSWORD
              const Padding(
                padding: EdgeInsets.fromLTRB(25, 0, 20, 5),
                child: Row(
                  children: [
                    Text("Create Password",
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Obx(
                  () => TextField(
                    controller: passwordController,
                    obscureText: !signupController.passwordVisible.value,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          signupController.passwordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          signupController.togglePassword();
                        },
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // CONFIRM PASSWORD
              const Padding(
                padding: EdgeInsets.fromLTRB(25, 0, 20, 5),
                child: Row(
                  children: [
                    Text("Confirm Password",
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Obx(
                  () => TextField(
                    controller: confirmPasswordController,
                    obscureText: !signupController.confirmPasswordVisible.value,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          signupController.confirmPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          signupController.toggleConfirmPassword();
                        },
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // SIGN UP BUTTON
              GestureDetector(
                onTap: () {},
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
                    child: MaterialButton(
                      onPressed: () async {
                        if (firstnameController.text.isEmpty) {
                          Get.snackbar("Error", "Please enter first name");
                        } else if (lastnameController.text.isEmpty) {
                          Get.snackbar("Error", "Please enter last name");
                        } else if (phoneController.text.isEmpty) {
                          Get.snackbar("Error", "Please enter phone number");
                        } else if (emailController.text.isEmpty) {
                          Get.snackbar("Error", "Please enter email address");
                        } else if (passwordController.text.isEmpty) {
                          Get.snackbar("Error", "Please enter password");
                        } else if (confirmPasswordController.text.isEmpty) {
                          Get.snackbar("Error", "Please confirm password");
                        }
                        if (passwordController.text !=
                            confirmPasswordController.text) {
                          Get.snackbar("Error", "Passwords do not match");
                          return;
                        }

                        final response = await http.get(Uri.parse(
                            "http://localhost/flutter_api/create.php?phonenumber=${phoneController.text}&firstname=${firstnameController.text}&lastname=${lastnameController.text}&email=${emailController.text}&password=${passwordController.text}"));

                        if (response.statusCode == 200) {
                          final serverData = jsonDecode(response.body);
                          if (serverData['success'] == 1) {
                            Get.snackbar("success", "You are registered");
                            Get.offAndToNamed("/");
                          }
                        } else {
                          Get.snackbar("Error", "Signup Failed");
                        }
                      },
                      child: const Text("Sign Up"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
