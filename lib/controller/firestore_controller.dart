import 'package:cap_project/model/debt.dart';
import 'package:cap_project/model/purchase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:firebase_storage/firebase_storage.dart';
import '../model/constant.dart';
import '../model/user.dart';

class FirestoreController {
  static addUser({
    required UserProfile userProf,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.users)
        .add(userProf.toFirestoreDoc());
    return ref.id; // doc id auto-generated.
  }

  static addPurchase({
    required UserProfile user,
    required Purchase purchase,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.users)
        .doc(user.docId)
        .collection(Constant.purchases)
        .add(purchase.toFirestoreDoc());
    return ref.id; // doc is auto-generated.
  }

  static Future<List<Purchase>> getPurchaseList({
    required UserProfile user,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.users)
        .doc(user.docId)
        .collection(Constant.purchases)
        .orderBy(DocKeyPurchase.title.name, descending: true)
        .get();

    var result = <Purchase>[];
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = Purchase.fromFirestoreDoc(doc: document, docId: doc.id);
        if (p != null) result.add(p);
      }
    }
    return result;
  }

  static addDebt({
    required UserProfile user,
    required Debt debt,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.users)
        .doc(user.docId)
        .collection(Constant.debts)
        .add(debt.toFirestoreDoc());
    return ref.id; // doc id auto-generated.
  }

  static Future<List<Debt>> getDebtList({
    required UserProfile user,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.users)
        .doc(user.docId)
        .collection(Constant.debts)
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

  static Future<UserProfile> getUser({
    required String email,
  }) async {
    print('FIRESTORE INSTANCE+++++++++++++++++IN');
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.users)
        .where(DocKeyUserprof.email.name, isEqualTo: email)
        .get();
    print('FIRESTORE INSTANCE+++++++++++++++++OUT');
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var u = UserProfile.fromFirestoreDoc(doc: document, docId: doc.id);
        if (u != null) return u;
      }
    }
    return UserProfile();
  }
}
