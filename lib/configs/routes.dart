import 'package:flutter_application_acs315/cart.dart';
import 'package:flutter_application_acs315/views/homescreen.dart';
import 'package:flutter_application_acs315/views/login.dart';
import 'package:flutter_application_acs315/views/signup.dart';
import 'package:get/get.dart';

var routes = [
  GetPage(name: "/", page: () => const LoginScreen()),
  GetPage(name: "/signup", page: () => const SignupScreen()),
  GetPage(name: "/homescreen", page: () => const HomeScreen()),
  GetPage(name: "/cart", page: () => const CartScreen()),
];
