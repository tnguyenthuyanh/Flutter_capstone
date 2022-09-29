// ignore_for_file: avoid_print

import 'package:cap_project/controller/firestore_controller.dart';
import 'package:flutter/material.dart';
import '../controller/auth_controller.dart';
import '../model/constant.dart';
import '../model/user.dart';
import 'view/view_util.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signUpScreen';

  const SignUpScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUpScreen> {
  late _Controller con;
  var formKey = GlobalKey<FormState>();
  late UserProfile userProf;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    userProf = UserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create New Account'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    'Create new account',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: con.validateEmail,
                    onSaved: con.saveEmail,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter password',
                    ),
                    autocorrect: false,
                    obscureText: true,
                    validator: con.validatePassword,
                    onSaved: con.savePassword,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Confirm password',
                    ),
                    autocorrect: false,
                    obscureText: true,
                    validator: con.validatePassword,
                    onSaved: con.saveConfirmPassword,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  ElevatedButton(
                      onPressed: con.signUp,
                      child: Text(
                        'Sign Up',
                        style: Theme.of(context).textTheme.button,
                      ))
                ],
              ),
            ),
          ),
        ));
  }
}

class _Controller {
  _SignUpState state;
  _Controller(this.state);
  String? email;
  String? password;
  String? confirmPassword;

  void signUp() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;

    currentState.save();
    if (password != confirmPassword) {
      showSnackBar(
          context: state.context,
          seconds: 20,
          message: 'passwords do not match');
      return;
    }

    try {
      await AuthController.createAccountTest(
          email: email!, password: password!, userProf: state.userProf);
      FirestoreController.addUser(userProf: state.userProf);
      showSnackBar(
        context: state.context,
        seconds: 20,
        message: 'Account created! Sign In and use the app',
      );
    } catch (e) {
      if (Constant.devMode) print('========= sign up falied: $e');
      showSnackBar(
        context: state.context,
        seconds: 20,
        message: 'Cannot create account: $e',
      );
    }
  }

  // ignore: body_might_complete_normally_nullable
  String? validateEmail(String? value) {
    if (value == null || !(value.contains('@') && value.contains('.'))) {
      return 'Invalid email';
    }
  }

  void saveEmail(String? value) {
    email = value;
    state.userProf.email = value!;
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return 'password too short (min 6 characters)';
    } else {
      return null;
    }
  }

  void savePassword(String? vlaue) {
    password = vlaue;
  }

  void saveConfirmPassword(String? value) {
    confirmPassword = value;
  }
}
