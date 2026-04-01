import 'package:get/get.dart';

class Signupcontroller extends GetxController {
  var name = "".obs;
  var email = "".obs;
  var password = "".obs;
  var confirmPassword = "".obs;

  var passwordVisible = false.obs;
  var confirmPasswordVisible = false.obs;

  bool signup(
      String userName, String userEmail, String pass, String confirmPass) {
    name.value = userName;
    email.value = userEmail;
    password.value = pass;
    confirmPassword.value = confirmPass;

    if (name.value.isEmpty ||
        email.value.isEmpty ||
        password.value.isEmpty ||
        confirmPassword.value.isEmpty) {
      return false;
    }

    if (password.value != confirmPassword.value) {
      return false;
    }

    return true; // success
  }

  void togglePassword() {
    passwordVisible.value = !passwordVisible.value;
  }

  void toggleConfirmPassword() {
    confirmPasswordVisible.value = !confirmPasswordVisible.value;
  }
}
