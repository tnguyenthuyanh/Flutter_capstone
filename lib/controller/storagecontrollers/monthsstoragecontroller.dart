import 'package:cap_project/model/budgetmonth.dart';
import 'package:cap_project/model/docKeys/docKeys.dart';
import 'package:cap_project/viewscreen/components/debug/debugprinter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/constant.dart';

class MonthsStorageController {
  static DebugPrinter printer =
      DebugPrinter(className: "MonthsStorageController", printOff: true);

  static String _collectionName = Constant.months;

  static Future<String> add({required BudgetMonth object}) async {
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
      return "errawr";
    }
  }

  static Future<List<BudgetMonth>> getList({required String templateId}) async {
    printer.setMethodName(methodName: "getList");
    printer.debugPrint("Getting BudgetMonth List for template $templateId");

    List<BudgetMonth> result = [];

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(_collectionName)
          .where(DocKeyMonths.templateId, isEqualTo: templateId)
          .get();

      // If no Budget Months Found
      if (snapshot.docs.isEmpty) {
        printer.debugPrint("No results found");
      }
      // If budget Months found, deserialize and add to months list
      else {
        for (var doc in snapshot.docs) {
          if (doc.data() != null) {
            printer.debugPrint("Found objects");

            var document = doc.data() as Map<String, dynamic>;

            BudgetMonth? temp =
                BudgetMonth.deserialize(doc: document, docId: doc.id);

            printer.debugPrint("Temp: ");

            if (temp != null) {
              result.add(temp);
            }
          }
        }
      }
    }
    // ERRAWR
    catch (e) {
      printer.debugPrint("Error getting Month List from DB: $e");
    }
    return result;
  }

  static Future<void> update({required BudgetMonth object}) async {
    printer.setMethodName(methodName: "update");

    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(object.docId!)
          .update({
        DocKeyMonths.docId: object.docId,
        DocKeyMonths.ownerUids: object.ownerUids,
        DocKeyMonths.templateId: object.templateId,
        DocKeyMonths.startDate: object.startDate.dateTime.toIso8601String()
      });
    } catch (e) {
      printer.debugPrint(e.toString());
    }
  }

  static Future<void> delete({required BudgetMonth object}) async {
    printer.setMethodName(methodName: "delete");

    await FirebaseFirestore.instance
        .collection(_collectionName)
        .doc(object.docId)
        .delete();
  }
}
