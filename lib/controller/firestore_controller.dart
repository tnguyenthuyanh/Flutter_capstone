import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:firebase_storage/firebase_storage.dart';
import '../model/constant.dart';
import '../model/user.dart' as usr;

class FirestoreController {
  static addUser({
    required usr.Userprof userProf,
  }) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection(Constant.users)
        .add(userProf.toFirestoreDoc());
    return ref.id; // doc id auto-generated.
  }

  static Future<void> initProfile({
    required User user,
  }) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.USERPROFILE_COLLECTION)
        .where('uid', isEqualTo: user.uid)
        .get();
    if (querySnapshot.size == 0)
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
      if (querySnapshot.docs[i]['uid'] == uid) {
        String docId = querySnapshot.docs[i].id;
        await FirebaseFirestore.instance
            .collection(Constant.USERPROFILE_COLLECTION)
            .doc(docId)
            .delete();
      }
  }
}
