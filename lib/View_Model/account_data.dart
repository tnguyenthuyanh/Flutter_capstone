import 'dart:collection';
import 'package:cap_project/controller/firestore_controller.dart';
import 'package:cap_project/model/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../controller/auth_controller.dart';
import '../model/account.dart';
import '../model/accountlist.dart';
import '../model/budgetlist.dart';
import '/model/budget.dart';

class AccountData extends ChangeNotifier {
  AccountList _list = AccountList();
  Account? _selected = null; // account being VIEWED
  Account? _current = null; // account being USED for calculations etc
  ListMode _currentMode = ListMode.view;

  AccountData() {
    // fsLoadBudgets();
  }

// ---- getters for encapsulated member variables ------------------------------
  UnmodifiableListView<Account> get list => _list.accountsListView;
  Account? get selected => _selected;
  Account? get current => _current;
  List<int> get selectedIndices => _list.selectedIndices;
  int get number => _list.size;
  ListMode get currentMode => _currentMode;

  set currentMode(ListMode mode) {
    _currentMode = mode;
    notifyListeners();
  }

  /// add the budget to the local budget list, store in firebase and notify
//   void add(Budget budget) async {
//     budget.docID = await fsAddBudget(budget);

//     _budgetList.add(budget);

//     // if the new budget is set to current, set update other budgets, if any
//     if (budget.isCurrent! || _currentBudget == null) {
//       setCurrentBudget(budget);
//     }

//     notifyListeners();
//   }

//   void setCurrentBudget(Budget budget) {
//     _currentBudget = budget;
//     budget.dirty = true;

//     budget.isCurrent = true;

//     // TODO: Remove - debug
//     print('BudgetData: current updated to: ' +
//         budget.title +
//         "********************");

//     // if there is more than one budget, set others to inactive
//     if (_budgetList.size > 1) {
//       _budgetList.setNewCurrentBudget(budget);
//     }

//     // update firestore, if needed
//     fsUpdateAllDirty();
//     _budgetList.clearDirtyFlags();

//     // TODO:Remove-debug
//     print("BudgetData: " + budget.title + " current?");
//     print(budget.isCurrent.toString());
//     notifyListeners();
//   }

//   // sets the budget selected for view/edit in the budgets list
//   void setSelectedBudget(Budget budget) {
//     _selectedBudget = budget;
//     notifyListeners();
//   }

// // ---- Deletion Related Methods -----------------------------------------------
//   void stageForDeletion(Budget budget) {
//     _budgetList.stageForDeletion(budget);
//     notifyListeners();
//   }

//   void unstageForDeletion(Budget budget) {
//     _budgetList.unstageForDeletion(budget);
//     notifyListeners();
//   }

  void confirmDeletion() {
    // TODO: Remove-debug
    print("Before deletion:");
    printAll();

    for (Account object in _list.deletionList) {
      fsDelete(object);

      if (identical(object, _current)) {
        _current = null;
      }
      if (identical(object, _selected)) {
        _selected = null;
      }
    }

    _list.commitDeletion();

    // TODO: Remove-Debug
    print("After deletion: ");
    printAll();

    notifyListeners();
  }

  void cancelDeletion() {
    _list.cancelDeletion();
    notifyListeners();
  }

  bool isStagedForDeletion(Account object) {
    return _list.isStagedForDeletion(object);
  }

// // ---- Firestore Related Methods ----------------------------------------------
//   void fsLoadBudgets() async {
//     List<Budget> _tempBudgets = await FirestoreController.getBudgetList();

//     // load all the budgets into the provider's budget list
//     for (Budget budget in _tempBudgets) {
//       _budgetList.add(budget);

//       // if the budget is set as current, set the provider's selected budget
//       if (budget.isCurrent!) {
//         setCurrentBudget(budget);
//       }
//     }
//   }

//   // add the budget to firestore and set the budget's docid
//   Future<String> fsAddBudget(Budget budget) async {
//     var docID = await FirestoreController.addBudget(budget: budget);
//     budget.docID = docID;

//     // TODO: Remove - debug
//     print("Added " +
//         budget.title +
//         " to FireStore with docid " +
//         budget.docID! +
//         "***********************8");

//     notifyListeners();

//     return docID;
//   }

//   Future<void> fsUpdateAllDirty() async {
//     for (Budget dirtyBoi in _budgetList.getDirtyList()) {
//       await FirestoreController.updateBudget(budget: dirtyBoi);

//       // TODO: Remove-debug
//       print("Sending to FS to update: ");
//       print(dirtyBoi.serialize());
//     }
//   }

//   void fsUpdateBudget(Budget budget) async {
//     FirestoreController.updateBudget(budget: budget);
//     notifyListeners();
//   }

  void fsDelete(Account object) {
    FirestoreController.deleteAccount(object: object);
  }

//   // ---- Debug Methods ----------------------------------------------
  void printAll() {
    for (Account object in list) {
      print("Object: $object.serialize()");
    }

    if (_current != null) {
      print("Current: $current!.serialize()");
    } else {
      print("Current is null");
    }

    if (_selected != null) {
      print("Selected: $selected!.serialize()");
    } else {
      print("Selected is null");
    }
  }
}
