import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  String? validateEmail(String? input) {
    final emailRegex =
        RegExp(r'^[0-9A-Za-z]+[.]*[A-Za-z0-9]*@[A-Za-z]+.[A-Za-z]+');

    return emailRegex.hasMatch(input!) ? null : "Email Is not Valid";
  }

  String? validatePhone(String? input) {
    final phoneRegex =
        RegExp(r'^[0-9]+');

    return phoneRegex.hasMatch(input!) && input.length == 10 ? null : "Phone Number Is not Valid";
  }
  String? validatePass(String? input) {
   

    return input!.length > 6 ? null : "Password Is not Valid";
  }
}
