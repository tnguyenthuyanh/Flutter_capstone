import 'package:cap_project/controller/firebaseauth_controller.dart';
import 'package:cap_project/controller/firestore_controller.dart';
import 'package:cap_project/model/constant.dart';
import 'package:cap_project/model/user.dart';
import 'package:cap_project/viewscreen/userhome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/signInScreen';
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SignInState();
  }
} //end signinscreen

class _SignInState extends State<SignInScreen> {
  late _Controller con;
  GlobalKey<FormState> formKey = GlobalKey<FormState>(); //key for form

  @override
  void initState() {
    //use this as constructor for state
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in please'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Budget App',
                  style: TextStyle(
                    fontFamily: 'CarterOne',
                    fontSize: 40.0,
                  ),
                ),
                const Text(
                  'Sign in please',
                  style: TextStyle(
                    fontFamily: 'CarterOne',
                    fontSize: 24.0,
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Email Address'),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: con.validateEmail,
                  onSaved: con.saveEmail,
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Enter Password'),
                  autocorrect: false,
                  obscureText: true,
                  validator: con.validatePassword,
                  onSaved: con.savePassword,
                ),
                ElevatedButton(
                  onPressed: con.signIn,
                  child: Text(
                    'Sign in',
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                // ElevatedButton(
                //   onPressed: con.signUp,
                //   child: Text('Create a new account',
                //       style: Theme.of(context).textTheme.button),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} //end signingState

class _Controller {
  late _SignInState state;
  _Controller(this.state);

  String? email;
  String? password;
  late UserProfile userP;

  void signIn() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    User? user;
    userP = await FirestoreController.getUser(email: email!);

    try {
      if (email == null || password == null) {
        throw 'Email or password is null';
      }
      user = await FirebaseAuthController.signIn(
          email: email!, password: password!);

      print('+++++++++++++++++++++++++TESTING');
      Navigator.pushNamed(
        state.context,
        UserHomeScreen.routeName,
        arguments: {
          ArgKey.user: user,
          ArgKey.userProfile: userP,
        },
      );
    } catch (e) {
      if (Constant.devMode) print('=== signIn error: $e');
    }
  }

  String? validateEmail(String? value) {
    if (value == null || !(value.contains('@') && value.contains('.')))
      return 'Invalid email';
    else
      return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 6)
      return 'Invalid Password';
    else
      return null;
  }

  void saveEmail(String? value) {
    if (value != null) email = value;
  }

  void savePassword(String? value) {
    if (value != null) password = value;
  }

  Future<UserProfile> getUserProfile(String? email) async {
    Future<UserProfile> temp = FirestoreController.getUser(email: email!);
    return temp;
  }
}
