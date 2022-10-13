import 'package:cap_project/model/docKeys/docKeys.dart';
import 'package:cap_project/viewscreen/components/debug/debugprinter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/account.dart';
import '../../model/constant.dart';
import '../auth_controller.dart';

class AccountStorageController {
  static DebugPrinter printer =
      DebugPrinter(className: "AccountStorageController");
  static String _collectionName = Constant.accounts;

  static Future<String> add({required Account object}) async {
    printer.setMethodName(methodName: "add");

    try {
      DocumentReference ref = await FirebaseFirestore.instance
          .collection(_collectionName)
          .add(object.serialize());

      object.docId = ref.id;
      await update(object: object);

      printer.debugPrint("returning " + ref.id);
      return ref.id;
    } catch (e) {
      print(e.toString());
      return "errawr";
    }
  }

  static Future<List<Account>> getList() async {
    printer.setMethodName(methodName: "getList");

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(_collectionName)
        .where(DocKeyStorable.ownerUid,
            isEqualTo: AuthController.currentUser!.uid)
        .get();

    printer.debugPrint(
        "query returned " + querySnapshot.size.toString() + " results");
    var result = <Account>[];

    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        printer.debugPrint("found objects");

        var document = doc.data() as Map<String, dynamic>;
        Account? temp = Account.deserialize(doc: document, docId: doc.id);
        if (temp != null) {
          result.add(temp);

          printer.debugPrint(
              "added " + temp.serialize().toString() + " to result list");
        }
      }
    }
    return result;
  }

  static Future<void> update({required Account object}) async {
    printer.setMethodName(methodName: "update");

    String? docId = object.docId;
    if (docId == null) {
      printer.debugPrint("shit");
    }
    // printer.debugPrint("Object: " + object.title + " , " + object.docId);

    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(object.docId!)
          .update({
        DocKeyStorable.docId: object.docId,
        DocKeyStorable.isCurrent: object.isCurrent,
        DocKeyStorable.ownerUid: object.ownerUid,
        DocKeyStorable.title: object.title
      });
    } catch (e) {
      printer.debugPrint(e.toString());
    }
  }

  static Future<void> delete({required Account object}) async {
    await FirebaseFirestore.instance
        .collection(_collectionName)
        .doc(object.docId)
        .delete();
  }
}
