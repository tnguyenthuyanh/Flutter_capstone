//import 'dart:html';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/user.dart';
import 'firestore_controller.dart';

class AuthController {
  static Future<User?> signIn(
      {required String email, required String password}) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> createAccountTest(
      {required String password, required Userprof userProf}) async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: userProf.email, password: password);
      if (user != null) {
        userProf.uid = user.user?.uid;

        await FirestoreController.addUser(userProf: userProf);
      }
    } catch (e) {
      throw (e);
    }
  }

  static Future<void> createAccount({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }
}
