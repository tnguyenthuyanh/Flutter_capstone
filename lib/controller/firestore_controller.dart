import 'package:cap_project/model/debt.dart';
import 'package:cap_project/model/user.dart';
import 'package:cap_project/model/tipcalc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/constant.dart';
import '../model/user.dart' as usr;

class FirestoreController {
  static addUser({
    required usr.UserProfile userProf,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.users)
        .add(userProf.toFirestoreDoc());
    return ref.id; // doc id auto-generated.
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
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.users)
        .where(DocKeyUserprof.email.name, isEqualTo: email)
        .get();

    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var u = UserProfile.fromFirestoreDoc(doc: document, docId: doc.id);
        if (u != null) return u;
      }
    }
    return UserProfile();
  }

  static Future<void> initProfile({
    required User user,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.USERPROFILE_COLLECTION)
        .where('uid', isEqualTo: user.uid)
        .get();
    if (querySnapshot.size == 0)
      // ignore: curly_braces_in_flow_control_structures
      await FirebaseFirestore.instance
          .collection(Constant.USERPROFILE_COLLECTION)
          .add({
        'name': "",
        'bio': "",
        'email': user.email,
        'uid': user.uid,
      });
  }

  static Future<Map> getProfile({
    required String uid,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.USERPROFILE_COLLECTION)
        .where('uid', isEqualTo: uid)
        .get();

    var i = querySnapshot.docs[0];
    return {
      'name': i['name'],
      'bio': i['bio'],
      'email': i['email'],
      "uid": i['uid']
    };
  }

  static Future<void> addUpdateProfile({
    required String uid,
    required String name,
    required String bio,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.USERPROFILE_COLLECTION)
        .where('uid', isEqualTo: uid)
        .get();

    await FirebaseFirestore.instance
        .collection(Constant.USERPROFILE_COLLECTION)
        .doc(querySnapshot.docs[0].id)
        .update({'name': name, 'bio': bio});
  }

  static Future<List<usr.UserInfo>> getUserList({required User user}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.USERPROFILE_COLLECTION)
        .orderBy(usr.UserInfo.EMAIL)
        .get();

    var result = <usr.UserInfo>[];

    querySnapshot.docs.forEach((doc) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        var p = usr.UserInfo.fromFirestoreDoc(
          doc: document,
          docId: doc.id,
        );
        if (p != null) {
          if (p.uid != user.uid) result.add(p);
        }
      }
    });
    return result;
  }

  static Future<void> deleteProfile({
    required String uid,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.USERPROFILE_COLLECTION)
        .where('uid', isEqualTo: uid)
        .get();
    for (int i = 0; i < querySnapshot.size; i++)
      // ignore: curly_braces_in_flow_control_structures
      if (querySnapshot.docs[i]['uid'] == uid) {
        String docId = querySnapshot.docs[i].id;
        await FirebaseFirestore.instance
            .collection(Constant.USERPROFILE_COLLECTION)
            .doc(docId)
            .delete();
      }
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
