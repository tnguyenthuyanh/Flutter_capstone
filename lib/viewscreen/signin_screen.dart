import 'package:cap_project/controller/firebaseauth_controller.dart';
import 'package:cap_project/controller/google_sign_in.dart';
import 'package:cap_project/model/constant.dart';
import 'package:cap_project/viewscreen/userhome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

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
        title: const Text('Lets get started'),
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
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      minimumSize: Size(50, 50),
                    ),
                    icon: FaIcon(FontAwesomeIcons.google),
                    label: Text('Sign Up with Google'),
                    onPressed: () {
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
                      provider.googleLogin();
                      Navigator.of(context).pushNamed(UserHomeScreen.routeName);
                    }),
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
  //phone number

  void signIn() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    User? user;

    try {
      if (email == null || password == null) {
        throw 'Email or password is null';
      }
      user = await FirebaseAuthController.signIn(
          email: email!, password: password!);

      Navigator.pushNamed(
        state.context,
        UserHomeScreen.routeName,
        arguments: {
          ArgKey.user: user,
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
}
