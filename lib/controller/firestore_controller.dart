import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_storage/firebase_storage.dart';
import '../model/constant.dart';
import '../model/user.dart';

class FirestoreController {
  static addUser({
    required Userprof userProf,
  }) async {
    try {
      DocumentReference ref = await FirebaseFirestore.instance
          .collection(Constant.users)
          .add(userProf.toFirestoreDoc());
      return ref.id; // doc id auto-generated.
    } catch (e) {
      throw (e);
    }
  }
}
