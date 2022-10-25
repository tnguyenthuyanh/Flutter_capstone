import 'package:cap_project/model/budgetAmount.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oktoast/oktoast.dart';

import '../../model/budget.dart';
import '../../model/catergories.dart';
import '../../model/constant.dart';
import '../../model/subcategories.dart';
import '../auth_controller.dart';

class BudgetStorageController {
  static Future<String> addBudget({required Budget budget}) async {
    try {
      DocumentReference ref =
          FirebaseFirestore.instance.collection(Constant.budgets).doc();

      budget.budgetId = ref.id;
      await ref.set(budget.serialize());
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
    print(
        '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!hello from getbudgetList');
    print(querySnapshot.docs.length);
    print(
        '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%afterdoclenght');

    var result = <Budget>[];
    for (var doc in querySnapshot.docs) {
      if (doc.data() != null) {
        var document = doc.data() as Map<String, dynamic>;
        Budget? temp = Budget.deserialize(doc: document, docId: doc.id);
        if (temp != null) result.add(temp);
      }
    }
    print(
        '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%beforereturn');
    print(result);
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
      print(e);
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
      print("error");
      print(e);

      throw (e);
    }
  }

  static Future<bool> deleteSubCategories(SubCategory subCategory) async {
    try {
      print('hello form delete sub line 127!!!!!!!!!');
      final batch = FirebaseFirestore.instance.batch();
      final docref = FirebaseFirestore.instance
          .collection(Constant.categories)
          .doc(subCategory.categoryid)
          .collection(subCategory.userid!)
          .doc(subCategory.subcategoryid);
      batch.delete(docref);

      QuerySnapshot subCatBudgeAmount = await FirebaseFirestore.instance
          .collection(Constant.budgetAmount)
          .where("CategoryId", isEqualTo: subCategory.categoryid)
          .get();
          
      for (var element in subCatBudgeAmount.docs)  {
        print(element.data());
        print('*************hello from 142');
        BudgetAmount budgetAmount =
            BudgetAmount.fromJson(element.data() as Map<String,dynamic>);
            print('hello from line 144!!!!!!!!!!!!!!!!!');
            print(budgetAmount.toJson());
       final docref2 = FirebaseFirestore.instance
            .collection(Constant.budgetAmount)
            .doc(budgetAmount.budgetAmountId)
            .collection(Constant.subcatagory)
            .doc(subCategory.label);
        batch.delete(docref2);

        DocumentSnapshot getamountref = await FirebaseFirestore.instance
            .collection(Constant.budgetAmount)
            .doc(budgetAmount.budgetAmountId)
            .collection(Constant.subcatagory)
            .doc(subCategory.label)
            .get();
        
        double amount = (getamountref.data() as Map)["amount"];
        final budgetamountref = FirebaseFirestore.instance.collection(Constant.budgetAmount).doc(budgetAmount.budgetAmountId);
        print('hello from 163 in budget storage');
        batch.set(budgetamountref, budgetAmount.toJsonForDeleting(amount));
        print('hello from 165 in budget storage');
      }
      await batch.commit();
      return true;

    } catch (e) {

      print(e);
      print('helllo from delete sub cate exception !!!!!!!');
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
      BudgetAmount budgetAmount, String budgetId) async {
    try {
      final batch = FirebaseFirestore.instance.batch();

      QuerySnapshot budgetAmountdoc = await FirebaseFirestore.instance
          .collection(Constant.budgetAmount)
          .where("CategoryId", isEqualTo: budgetAmount.CategoryId)
          .where("budgetId", isEqualTo: budgetId)
          .get();
      if (budgetAmountdoc.docs.isNotEmpty) {
        print('hello from line 246 storage cont');
        
        if (budgetAmount.SubCategory == null) {
          final collection = await FirebaseFirestore.instance
              .collection(Constant.budgetAmount)
              .doc(budgetAmountdoc.docs.first.id)
              .collection(Constant.subcatagory)
              .get();

          collection.docs.forEach((element) {

            batch.delete(element.reference);
          });
          budgetAmount.budgetAmountId = budgetAmountdoc.docs.first.id;
          await batch.commit();
          await FirebaseFirestore.instance
              .collection(Constant.budgetAmount)
              .doc(budgetAmountdoc.docs.first.id)
              .set(budgetAmount.toJson());
        } else {
          print('hello from line 263 storage cont');
          final docRefrence = await FirebaseFirestore.instance
              .collection(Constant.budgetAmount)
              .doc(budgetAmountdoc.docs.first.id)
              .collection(Constant.subcatagory)
              .doc(budgetAmount.SubCategoryLabel);
          batch.set(docRefrence, budgetAmount.toJsonforSubCat());
          final docRefrence2 = await FirebaseFirestore.instance
              .collection(Constant.budgetAmount)
              .doc(budgetAmountdoc.docs.first.id);
          batch.set(
              docRefrence2,
              budgetAmount.toJsonForUpdating(
                  (budgetAmountdoc.docs.first.data() as Map)["amount"]));
          batch.commit();
        }
      } else {
        print('hello from line 283 storage cont');
        DocumentReference? ref1 = null;
        DocumentReference documentReference =
            FirebaseFirestore.instance.collection(Constant.budgetAmount).doc();
        if (budgetAmount.SubCategory != null) {
          ref1 = documentReference
              .collection(Constant.subcatagory)
              .doc(budgetAmount.SubCategoryLabel);
        }

        budgetAmount.budgetAmountId = documentReference.id;
        print('hello form line 288 budgetstoragecontroller');
        print(budgetAmount.toJson());
        await documentReference.set(budgetAmount.toJson());
        await ref1?.set(budgetAmount.toJsonforSubCat());
      }
    } catch (e) {
      throw (e);
    }

    return true;
  }

  static Future<bool> deleteCategory(String categoryid) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      final docref = FirebaseFirestore.instance
          .collection(Constant.categories)
          .doc(categoryid);
      batch.delete(docref);
      QuerySnapshot budgetAmountref = await FirebaseFirestore.instance
          .collection(Constant.budgetAmount)
          .where("CategoryId", isEqualTo: categoryid)
          .get();
      budgetAmountref.docs.forEach((element) {
        batch.delete(element.reference);
      });
      await batch.commit();
      return true;
    } catch (e) {
      throw (e);
    }
  }
}
