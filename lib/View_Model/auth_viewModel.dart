import 'package:cap_project/controller/auth_controller.dart' as auth;
import 'package:cap_project/model/user.dart';
import 'package:cap_project/viewscreen/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class AuthViewModel extends ChangeNotifier {
  TextEditingController emailCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  TextEditingController confPassCon = TextEditingController();
  TextEditingController phoneCon = TextEditingController();
  var formKeySignup = GlobalKey<FormState>();
  bool load = false;
  bool load_forget_password = false;
  late Userprof userprof;
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
    return input.length >= 6 ? null : "Password Is not Valid";
  }

  String? confirmPassword(String? input) {
    if (input == null || input.isEmpty) {
      return "No password provided";
    }
    return input == passCon.text ? null : "Passwords do not match";
  }



  signupUser()async{
    try{
      userprof = Userprof.set(emailCon.text.trim(), passCon.text.trim());
      load = true;
      notifyListeners();
      await auth.AuthController.createAccountTest(password: passCon.text.trim(), userProf: userprof);
      load = false;
      emailCon.clear();
      passCon.clear();
      phoneCon.clear();
      confPassCon.clear();

      notifyListeners();

      showToast("Sign up successfull");
    }catch(e){
      load = false;
      notifyListeners();
      showToast(e.toString());
    }

  }

  void resetPassword(context) async{
    try{
      load_forget_password = true;
      notifyListeners();
     await  auth.AuthController.resetPassword(email: emailCon.text.trim());
      load_forget_password = false;
      emailCon.clear();
      notifyListeners();
      showToast("Please check your email to reset the account");
      Navigator.pushNamed(context, SignInScreen.routeName);
    }catch(e){
      load_forget_password = false;
      notifyListeners();
      showToast(e.toString());
    }
  }

}
