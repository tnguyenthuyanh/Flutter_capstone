import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/account.dart';
import '../../model/constant.dart';
import '../auth_controller.dart';

class AccountStorageController {
  static String _collectionName = Constant.accounts;

  static Future<String> add({required Account object}) async {
    try {
      DocumentReference ref = await FirebaseFirestore.instance
          .collection(_collectionName)
          .add(object.serialize());
      return ref.id;
    } catch (e) {
      print(e.toString());
      return "errawr";
    }
  }

  static Future<List<Account>> getList() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(_collectionName)
        .where('ownerUid', isEqualTo: AuthController.currentUser!.uid)
        .get();

    var result = <Account>[];

    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        Account? temp = Account.deserialize(doc: document, docId: doc.id);
        if (temp != null) result.add(temp);
      }
    }
    return result;
  }

  static Future<void> update({required Account object}) async {
    await FirebaseFirestore.instance
        .collection(_collectionName)
        .doc(object.docId!)
        .update({
      'isCurrent': object.isCurrent,
      'ownerUid': object.ownerUid,
      'title': object.title
    });
  }

  static Future<void> delete({required Account object}) async {
    await FirebaseFirestore.instance
        .collection(_collectionName)
        .doc(object.docId)
        .delete();
  }
}
