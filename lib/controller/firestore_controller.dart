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

  // tools - save tip calc
  static Future<String> saveTipCalc(TipCalc tc) async {
    var ref = await FirebaseFirestore.instance
        .collection(Constant.savedTipCalc)
        .add(tc.toFirestoreDoc());
    return ref.id;
  }

  // tools - get tipcalc list
  static Future<List<TipCalc>> getTipCalcList({required String email}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.savedTipCalc)
        .where(TipCalc.CREATE_BY, isEqualTo: email)
        .orderBy(TipCalc.TIMESTAMP, descending: true)
        .get();
    var result = <TipCalc>[];
    querySnapshot.docs.forEach((m) {
      var data = m.data() as Map<String, dynamic>;
      result.add(TipCalc.fromFirestoreDoc(docId: m.id, doc: data));
    });
    return result;
  }
}
