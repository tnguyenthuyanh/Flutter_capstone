import 'package:cap_project/model/docKeys/docKeys.dart';
import 'package:cap_project/viewscreen/components/debug/debugprinter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/account.dart';
import '../../model/constant.dart';
import '../auth_controller.dart';

class AccountStorageController {
  static DebugPrinter printer =
      DebugPrinter(className: "AccountStorageController", printOff: true);
  static String _collectionName = Constant.accounts;

  static Future<String> add({required Account object}) async {
    printer.setMethodName(methodName: "add");

    try {
      DocumentReference ref = await FirebaseFirestore.instance
          .collection(_collectionName)
          .add(object.serialize());

      object.docId = ref.id;
      // await update(object: object);

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

    printer.debugPrint("Returned ${querySnapshot.size.toString()} results");
    var result = <Account>[];

    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        printer.debugPrint("found objects");

        var document = doc.data() as Map<String, dynamic>;
        printer.debugPrint("doc.id: ${doc.id}");

        Account? temp = Account.deserialize(doc: document, docID: doc.id);
        if (temp != null) {
          result.add(temp);

          printer.debugPrint("added " +
              "id: " +
              temp.docId! +
              ", " +
              temp.serialize().toString() +
              " to result list");
        }
      }
    }
    return result;
  }

  static Future<void> update({required Account object}) async {
    printer.setMethodName(methodName: "update");

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
    printer.setMethodName(methodName: "delete");
    printer.debugPrint("deleting ${object.title}");

    await FirebaseFirestore.instance
        .collection(_collectionName)
        .doc(object.docId)
        .delete();
  }
}
