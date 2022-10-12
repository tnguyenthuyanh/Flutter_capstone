import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/budget.dart';
import '../../model/constant.dart';
import '../auth_controller.dart';

class BudgetStorageController {
  static Future<String> addBudget({required Budget budget}) async {
    try {
      DocumentReference ref = await FirebaseFirestore.instance
          .collection(Constant.budgets)
          .add(budget.serialize());
      return ref.id;
    } catch (e) {
      print(e.toString());
      return "errawr";
    }
  }

  static Future<List<Budget>> getBudgetList() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.budgets)
        .where('ownerUID', isEqualTo: AuthController.currentUser!.uid)
        .get();

    var result = <Budget>[];
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        Budget? temp = Budget.deserialize(doc: document, docId: doc.id);
        if (temp != null) result.add(temp);
      }
    }
    return result;
  }

  static Future<void> updateBudget({required Budget budget}) async {
    await FirebaseFirestore.instance
        .collection(Constant.budgets)
        .doc(budget.docID!)
        .update({
      'isCurrent': budget.isCurrent,
      'ownerUID': budget.ownerUID,
      'title': budget.title
    });
  }

  static Future<void> deleteBudget({required Budget budget}) async {
    await FirebaseFirestore.instance
        .collection(Constant.budgets)
        .doc(budget.docID)
        .delete();
  }
}
