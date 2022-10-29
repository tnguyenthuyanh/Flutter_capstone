import 'package:cap_project/controller/auth_controller.dart';
import 'package:cap_project/model/constant.dart';
import 'package:cap_project/viewscreen/ForgotSignIn_screen.dart';
import 'package:cap_project/viewscreen/components/buttons/myelevatedbutton.dart';
import 'package:cap_project/viewscreen/signup_screen.dart';
import 'package:cap_project/viewscreen/userhome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../controller/firestore_controller.dart';
import '../model/user.dart';
import 'components/buttons/mysizedbutton.dart';

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
  late User gUser;
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ForgotSignIn.routeName);
                    },
                    child: const Text(
                      "Forgot Password",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                MySizedButton(
                  buttonText: "Sign in",
                  onPressedCallback: con.signIn,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      //foregroundColor: Colors.black,
                      minimumSize: const Size(50, 50),
                    ),
                    icon: const FaIcon(FontAwesomeIcons.google),
                    label: const Text('Sign In with Google'),
                    onPressed: () {
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
                      provider.googleLogin(
                          context); //passed in context to google sign in provider file
                    }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, SignUpScreen.routeName);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'New User? Create Account',
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
      user = await AuthController.signIn(email: email!, password: password!);

      await FirestoreController.initProfile(user: user!);
      await FirestoreController.initWallet(user: user);

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
    if (value == null || !(value.contains('@') && value.contains('.'))) {
      return 'Invalid email';
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return 'Invalid Password';
    } else {
      return null;
    }
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
