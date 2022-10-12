import 'dart:collection';
import 'package:cap_project/controller/firestore_controller.dart';
import 'package:cap_project/model/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../controller/auth_controller.dart';
import '../model/budgetlist.dart';
import '/model/budget.dart';

// Instance variables
// Constructor
// Getters
//
//
// Deletion Related
// Firebase Related

class BudgetData extends ChangeNotifier {
  BudgetList _budgetList = BudgetList();
  // which budget is being viewed in budgetdetail
  Budget? _selectedBudget = null;
  // which budget is being used by the rest of the app
  Budget? _currentBudget = null;

  BudgetData() {
    fsLoadBudgets();
  }

// ---- getters for encapsulated member variables ------------------------------
  UnmodifiableListView<Budget> get budgets => _budgetList.budgetsListView;
  Budget? get selectedBudget => _selectedBudget;
  Budget? get currentBudget => _currentBudget;
  List<int> get selectedIndices => _budgetList.selectedIndices;
  int get numberOfBudgets => _budgetList.size;

  /// add the budget to the local budget list and store in firebase
  /// then notify listeners
  void add(Budget budget) async {
    budget.docID = await fsAddBudget(budget);

    _budgetList.add(budget);

    // if the new budget is set to current, set update other budgets, if any
    if (budget.isCurrent! || _currentBudget == null) {
      setCurrentBudget(budget);
    }

    notifyListeners();
  }

  void setCurrentBudget(Budget budget) {
    _currentBudget = budget;

    budget.isCurrent = true;

    // TODO: Remove - debug
    print('BudgetData: current updated to: ' +
        budget.title +
        "********************");

    // if there is more than one budget, set others to inactive
    if (_budgetList.size > 1) {
      _budgetList.setNewCurrentBudget(budget);
    }

    // update firestore, if needed
    fsUpdateAllDirty();
    _budgetList.clearDirtyFlags();

    // TODO:Remove-debug
    print("BudgetData: " + budget.title + " current?");
    print(budget.isCurrent.toString());
    notifyListeners();
  }

  // sets the budget selected for view/edit in the budgets list
  void setSelectedBudget(Budget budget) {
    _selectedBudget = budget;
    notifyListeners();
  }

// ---- Deletion Related Methods -----------------------------------------------
  void stageForDeletion(Budget budget) {
    _budgetList.stageForDeletion(budget);
    notifyListeners();
  }

  void unstageForDeletion(Budget budget) {
    _budgetList.unstageForDeletion(budget);
    notifyListeners();
  }

  void confirmDeletion() {
    print("Before deletion:");
    printAllBudgets();

    for (Budget budget in _budgetList.deletionList) {
      fsDeleteBudget(budget);

      if (budget == _currentBudget) {
        _currentBudget = null;
      }
      if (budget == selectedBudget) {
        _selectedBudget = null;
      }
    }

    _budgetList.commitDeletion();

    print("After deletion: ");
    printAllBudgets();

    notifyListeners();
  }

  void cancelDeletion() {
    _budgetList.cancelDeletion();
    notifyListeners();
  }

  bool isStagedForDeletion(Budget budget) {
    return _budgetList.isStagedForDeletion(budget);
  }

// ---- Firestore Related Methods ----------------------------------------------
  void fsLoadBudgets() async {
    List<Budget> _tempBudgets = await FirestoreController.getBudgetList();

    // load all the budgets into the provider's budget list
    for (Budget budget in _tempBudgets) {
      _budgetList.add(budget);

      // if the budget is set as current, set the provider's selected budget
      if (budget.isCurrent!) {
        setCurrentBudget(budget);
      }
    }
  }

  // add the budget to firestore and set the budget's docid
  Future<String> fsAddBudget(Budget budget) async {
    var docID = await FirestoreController.addBudget(budget: budget);
    budget.docID = docID;

    // TODO: Remove - debug
    print("Added " +
        budget.title +
        " to FireStore with docid " +
        budget.docID! +
        "***********************8");

    notifyListeners();

    return docID;
  }

  Future<void> fsUpdateAllDirty() async {
    for (Budget dirtyBoi in _budgetList.getDirtyList()) {
      await FirestoreController.updateBudget(budget: dirtyBoi);

      // TODO: Remove-debug
      print("Sending to FS to update: ");
      print(dirtyBoi.serialize());
    }
  }

  void fsUpdateBudget(Budget budget) async {
    FirestoreController.updateBudget(budget: budget);
    notifyListeners();
  }

  void fsDeleteBudget(Budget budget) {
    FirestoreController.deleteBudget(budget: budget);
  }

  // ---- Debug Methods ----------------------------------------------
  void printAllBudgets() {
    for (Budget budget in budgets) {
      print("Budget: ");
      print(budget.serialize());
    }

    if (_currentBudget != null) {
      print("Current: ");
      print(currentBudget!.serialize());
    } else {
      print("Current budget is null");
    }

    if (_selectedBudget != null) {
      print("Selected Budget: ");
      print(selectedBudget!.serialize());
    } else {
      print("Selected Budget is null");
    }
  }
}
