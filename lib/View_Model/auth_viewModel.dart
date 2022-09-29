import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  TextEditingController emailCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  TextEditingController confPassCon = TextEditingController();
  TextEditingController phoneCon = TextEditingController();

  String? validateEmail(String? input) {
    print("in validate email");
    if (input == null || input.isEmpty) {
      return "No Email provided";
    }
    final emailRegex =
        RegExp(r'^[0-9A-Za-z]+[.]*[A-Za-z0-9]*@[A-Za-z]+.[A-Za-z]+');

    return emailRegex.hasMatch(input) ? null : "Email Is not Valid";
  }

  String? validatePhone(String? input) {
    if (input == null || input.isEmpty) {
      return "No phone number provided";
    }
    final phoneRegex = RegExp(r'^[0-9]+');

    return phoneRegex.hasMatch(input) && input.length == 10
        ? null
        : "Phone Number Is not Valid";
  }

  String? validatePass(String? input) {
    if (input == null || input.isEmpty) {
      return "No password provided";
    }
    return input.length > 6 ? null : "Password Is not Valid";
  }

  String? confirmPassword(String? input) {
    if (input == null || input.isEmpty) {
      return "No password provided";
    }
    return input == passCon.text ? null : "Passwords do not match";
  }
}
