import 'package:cap_project/model/budgetAmount.dart';
import 'package:cap_project/viewscreen/components/debug/debugprinter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oktoast/oktoast.dart';

import '../../model/budget.dart';
import '../../model/catergories.dart';
import '../../model/constant.dart';
import '../../model/subcategories.dart';
import '../auth_controller.dart';

class BudgetStorageController {
  static DebugPrinter printer =
      DebugPrinter(className: "BudgetStorageController", printOff: true);

  static Future<String> addBudget({required Budget budget}) async {
    printer.setMethodName(methodName: "addBudget");

    try {
      DocumentReference ref = await FirebaseFirestore.instance
          .collection(Constant.budgets)
          .add(budget.serialize());
      return ref.id;
    } catch (e) {
      printer.debugPrint("Error adding Budget: $e");
      return "errawr";
    }
  }

  static Future<List<Budget>> getBudgetList() async {
    printer.setMethodName(methodName: "getBudgetList");

    printer.debugPrint("getting budget list");
    var result = <Budget>[];

    printer.debugPrint("User id: ${AuthController.currentUser!.uid}");

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.budgets)
        .where('ownerUIDs', arrayContains: AuthController.currentUser!.uid)
        .get();

    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        printer.debugPrint("Document: ${doc.data()}");

        var document = doc.data() as Map<String, dynamic>;
        Budget? temp = Budget.deserialize(doc: document, docId: doc.id);

        if (temp != null) {
          result.add(temp);
          printer.debugPrint("Adding Budget ${temp.title} to budget list");
        }
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

  static Future<List<Category>> getCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection(Constant.categories)
          .where("userid", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();

      List<Category> categories = [];

      categories = data.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return Category.fromJson(data);
      }).toList();

      data = await FirebaseFirestore.instance
          .collection(Constant.categories)
          .where("type", isEqualTo: "global")
          .get();
      categories.addAll(data.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return Category.fromJson(data);
      }).toList());
      return categories;
    } catch (e) {
      throw (e);
    }
  }

  static Future<List<SubCategory>> getSubCategories(String categoryid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection(Constant.categories)
          .doc(categoryid)
          .collection(FirebaseAuth.instance.currentUser!.uid)
          .get();
      // /categories/121389128391/userid
      List<SubCategory> subcategories = [];

      subcategories = data.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return SubCategory.fromJson(data);
      }).toList();

      return subcategories;
    } catch (e) {
      throw (e);
    }
  }

  static Future<bool> deleteSubCategories(SubCategory subCategory) async {
    try {
      await FirebaseFirestore.instance
          .collection(Constant.categories)
          .doc(subCategory.categoryid)
          .collection(subCategory.userid!)
          .doc(subCategory.subcategoryid)
          .delete();

      return true;
    } catch (e) {
      throw (e);
    }
  }

  static Future<bool> addSubCategory(SubCategory subCategory) async {
    try {
      QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection(Constant.categories)
          .doc(subCategory.categoryid)
          .collection(subCategory.userid!)
          .where("label", isEqualTo: subCategory.label)
          .get();
      if (data.docs.isNotEmpty) {
        throw ("sub category already exist with this name");
      }

      DocumentReference documentReference = FirebaseFirestore.instance
          .collection(Constant.categories)
          .doc(subCategory.categoryid)
          .collection(subCategory.userid!)
          .doc();
      subCategory.subcategoryid = documentReference.id;

      await documentReference.set(subCategory.toJson());

      return true;
    } catch (e) {
      throw (e);
    }
  }

  static Future<bool> addCategory(Category category) async {
    try {
      QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection(Constant.categories)
          .where("label", isEqualTo: category.label)
          .where("type", isEqualTo: "global")
          .get();
      if (data.docs.isNotEmpty) {
        throw ("Global category already exist with this name");
      } else {
        data = await FirebaseFirestore.instance
            .collection(Constant.categories)
            .where("label", isEqualTo: category.label)
            .where("userid", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .get();
        if (data.docs.isNotEmpty) {
          throw ("category already exist with this name");
        }
      }
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection(Constant.categories).doc();
      category.categoryid = documentReference.id;
      await documentReference.set(category.toJson());

      return true;
    } catch (e) {
      throw (e);
    }
  }

  static Future<bool> addBudgetAmount(
    BudgetAmount budgetAmount,
    String budgetId,
  ) async {
    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection(Constant.budgets)
          .doc(budgetId)
          .collection(budgetAmount.ownerId)
          .doc();

      budgetAmount.budgetAmountId = documentReference.id;
      await documentReference.set(budgetAmount.toJson());

      return true;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> deleteCategory(String categoryid) async {
    print(categoryid);
    try {
      await FirebaseFirestore.instance
          .collection(Constant.categories)
          .doc(categoryid)
          .delete();

      return true;
    } catch (e) {
      throw (e);
    }
  }
}
