import 'package:flutter/material.dart';
import 'package:flutter_application_acs315/configs/routes.dart';
import 'package:get/get.dart';

void main() {
  runApp(
    GetMaterialApp(
      initialRoute: "/",
      getPages: routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}
