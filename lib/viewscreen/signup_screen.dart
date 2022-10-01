// ignore_for_file: avoid_print

import 'package:cap_project/controller/firestore_controller.dart';
import 'package:cap_project/View_Model/auth_viewModel.dart';
import 'package:cap_project/viewscreen/ForgotSignIn_screen.dart';
import 'package:cap_project/viewscreen/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/auth_controller.dart';
import '../model/constant.dart';
import '../model/user.dart';
import 'view/view_util.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/SignUpScreen';

  const SignUpScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUpScreen> {
  //late _Controller con;
  late AuthViewModel authViewModel;
  var formKey = GlobalKey<FormState>();
  late UserProfile userProf;
  bool obsecureText = true;
  bool obsecureText2 = true;

  @override
  void initState() {
    super.initState();
    //con = _Controller(this);
    userProf = UserProfile();
  }

  @override
  Widget build(BuildContext context) {
    authViewModel = Provider.of<AuthViewModel>(context);
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
                  validator: (value) => authViewModel.validateEmail(value),
                  controller: authViewModel.emailCon,
                  //onSaved: con.saveEmail,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter Phone Number',
                  ),
                  keyboardType: TextInputType.phone,
                  autocorrect: false,
                  validator: (value) => authViewModel.validatePhone(value),
                  controller: authViewModel.phoneCon,
                  //validator: con.validatePhone,
                  //onSaved: con.savePhone,
                ),
                TextFormField(
                  obscureText: obsecureText,
                  decoration: InputDecoration(
                    hintText: 'Enter password(At least 6 digits)',
                    suffixIcon: IconButton(
                      icon: Icon(obsecureText
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          obsecureText = !obsecureText;
                        });
                      },
                    ),
                  ),
                  autocorrect: false,
                  //obscureText: true,
                  validator: (value) => authViewModel.validatePass(value),
                  controller: authViewModel.passCon,
                  // validator: con.validatePassword,
                  //  onSaved: con.savePassword,
                ),
                TextFormField(
                  obscureText: obsecureText2,
                  decoration: InputDecoration(
                    hintText: 'Confirm password',
                    suffixIcon: IconButton(
                      icon: Icon(obsecureText2
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(
                          () {
                            obsecureText2 = !obsecureText2;
                          },
                        );
                      },
                    ),
                  ),
                  autocorrect: false,

                  controller: authViewModel.confPassCon,
                  validator: (value) => authViewModel.confirmPassword(value),
                  // onSaved: con.saveConfirmPassword,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        authViewModel.signupUser(context);
                      }
                    },
                    child: authViewModel.load
                        ? const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Sign Up',
                            style: Theme.of(context).textTheme.button,
                          )),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, SignInScreen.routeName);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Already a user? Sign In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

