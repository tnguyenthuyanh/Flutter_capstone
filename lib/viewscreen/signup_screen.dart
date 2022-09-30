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
                          authViewModel.signupUser();
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ForgotSignIn.routeName);
                      //formKey.currentState?.validate();
                    },
                    child: Text(
                      'Forgot Password',
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignInScreen.routeName);
                      //formKey.currentState?.validate();
                    },
                    child: Text(
                      'Return to Sign In',
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

// class _Controller {
//   _SignUpState state;
//   _Controller(this.state);
//   String? email;
//   String? password;
//   String? confirmPassword;
//   String? phone;

//   void signUp() async {
//     FormState? currentState = state.formKey.currentState;
//     if (currentState == null || !currentState.validate()) return;

//     currentState.save();
//     if (password != confirmPassword) {
//       showSnackBar(
//           context: state.context,
//           seconds: 20,
//           message: 'passwords do not match');
//       return;
//     }

  //   try {
  //     await AuthController.createAccountTest(
  //         email: email!, password: password!, userProf: state.userProf);
  //     FirestoreController.addUser(userProf: state.userProf);
  //     showSnackBar(
  //       context: state.context,
  //       seconds: 20,
  //       message: 'Account created! Sign In and use the app',
  //     );
  //   } catch (e) {
  //     if (Constant.devMode) print('========= sign up falied: $e');
  //     showSnackBar(
  //       context: state.context,
  //       seconds: 20,
  //       message: 'Cannot create account: $e',
  //     );
  //   }
  // }

//   // // ignore: body_might_complete_normally_nullable
//   // String? validateEmail(String? value) {
//   //   if (value == null || !(value.contains('@') && value.contains('.'))) {
//   //     return 'Invalid email';
//   //   }
//   // }

//   void saveEmail(String? value) {
//     email = value;
//     state.userProf.email = value!;
//   }

//   String? validatePassword(String? value) {
//     if (value == null || value.length < 6) {
//       return 'password too short (min 6 characters)';
//     } else {
//       return null;
//     }
//   }

//   void savePassword(String? value) {
//     password = value;
//   }

//   void saveConfirmPassword(String? value) {
//     confirmPassword = value;
//   }
// String? validatePhone(String? value){
//     if (value == null || value.length < 10){
//       return 'Invalid Phone Number; 10 digits';
//     }else{
//       return null;
//     }
//   }

//   void savePhone (String? value) {

//     if (value != null) phone = value;
//   }

//   void gotoSignInScreen() {
//     print('in goto sign in fun');
//     Navigator.pushNamed(state.context, SignInScreen.routeName);
//   }
// }