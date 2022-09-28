import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/constant.dart';
import '../model/user.dart';
import '../viewscreen/userhome_screen.dart';
import 'firestore_controller.dart';

class AuthController extends ChangeNotifier {
  static Future<User?> signIn(
      {required String email, required String password}) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> createAccountTest({
    required String email,
    required String password,
    required Userprof userProf,
  }) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await FirestoreController.addUser(userProf: userProf);
  }

  static Future<void> createAccount({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }
}

//Google Provider
class GoogleSignInProvider extends ChangeNotifier {
  String? email = FirebaseAuth.instance.currentUser?.email;
  GoogleSignIn googleAuth = GoogleSignIn(scopes: ['email]']);

  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin(context) async {
    User? user;
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    user = userCredential.user;

    notifyListeners();

//used context from the sign in page
    Navigator.pushNamed(context, UserHomeScreen.routeName, arguments: {
      ArgKey.user: user,
    });
  }
}//End GoogleProvider
