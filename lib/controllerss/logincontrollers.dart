import 'package:get/get.dart';

class Logincontrollers extends GetxController {
  var email = "".obs;
  var password = "".obs;
  var passwordVisible = false.obs;
  login(user, pass) {
    email.value = user;
    password.value = pass;
    if (email.value == "" && password.value == "") {
      return true;
    } else {
      return false;
    }
  }

  togglePassword() {
    passwordVisible.value = !passwordVisible.value;
  }
}
