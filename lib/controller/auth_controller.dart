import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../model/constant.dart';
import '../model/user.dart';
import '../viewscreen/userhome_screen.dart';
import 'firestore_controller.dart';

class AuthController extends ChangeNotifier {
  // keeps track of the currently logged in user
  static late User? _currentUser;

  // current user getter
  static User? get currentUser => _currentUser;

  // a convenience method that sets current user and notifies listeners - or will
  static void _setCurrentUser(User? user) {
    _currentUser = user;
    // TODO: uncomment notify after sign in screen has been refactored for provider
    // notifyListeners();
  }

  static Future<User?> signIn(
      {required String email, required String password}) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    _setCurrentUser(userCredential.user);

    return _currentUser;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    _setCurrentUser(null);
  }

  static Future<User?> resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> createAccountTest(
      {required String password, required UserProfile userProf}) async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: userProf.email, password: password);
      if (user.user != null) {
        userProf.uid = user.user?.uid;

        await FirestoreController.addUser(userProf: userProf);
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> createAccount({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> deleteAccount() async {
    await FirebaseAuth.instance.currentUser!.delete();
  }
}

//Google Provider
class GoogleSignInProvider extends ChangeNotifier {
  String? email = FirebaseAuth.instance.currentUser?.email;
  GoogleSignIn googleAuth = GoogleSignIn(scopes: ['email]']);

  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  late UserProfile userP;

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

    userP = await FirestoreController.getUser(email: email!);

    await FirestoreController.initProfile(user: user!);
    await FirestoreController.initWallet(user: user);

    notifyListeners();

//used context from the sign in page
    Navigator.pushNamed(context, UserHomeScreen.routeName, arguments: {
      ArgKey.user: user,
      ArgKey.userProfile: userP,
    });
  }

  Future logout() async {
    await googleSignIn.disconnect();
  }
} //End GoogleProvider





