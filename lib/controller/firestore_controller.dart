import 'package:cap_project/model/debt.dart';
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

  static addDebt({
    required Debt debt,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.users)
        .add(debt.toFirestoreDoc());
    return ref.id; // doc id auto-generated.
  }

  static Future<List<Debt>> getDebtList({
    required String email,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.debtCollection)
        .where(DocKeyDebt.createdby.name, isEqualTo: email)
        .orderBy(DocKeyDebt.title.name, descending: true)
        .get();

    var result = <Debt>[];
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = Debt.fromFirestoreDoc(doc: document, docId: doc.id);
        if (p != null) result.add(p);
      }
    }
    return result;
  }
}
