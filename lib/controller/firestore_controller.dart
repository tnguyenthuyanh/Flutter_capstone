import 'package:cap_project/model/tipcalc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_storage/firebase_storage.dart';
import '../model/constant.dart';
import '../model/user.dart';

class FirestoreController {
  static addUser({
    required Userprof userProf,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.users)
        .add(userProf.toFirestoreDoc());
    return ref.id; // doc id auto-generated.
  }

  static Future<String> saveTipCalc(TipCalc tc) async {
    var ref = await FirebaseFirestore.instance
        .collection(Constant.savedTipCalc)
        .add(tc.toFirestoreDoc());
    return ref.id;
  }
}
