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
  void add(Budget budget) {
    fsAddBudget(budget);
    _budgetList.add(budget);

    // if the new budget is set to current, set update other budgets, if any
    if (budget.isCurrent!) {
      setCurrentBudget(budget);
    }

    notifyListeners();
  }

  void setCurrentBudget(Budget budget) {
    _currentBudget = budget;
    print('BudgetData: current updated to: ' + budget.title);

    // if there is more than one budget, set others to inactive
    if (_budgetList.size > 1) {
      _budgetList.setNewCurrentBudget(budget);
    }

    // update firestore, if needed
    fsUpdateAllDirty();
    _budgetList.clearDirtyFlags();

    notifyListeners();
  }

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
    for (Budget budget in _budgetList.deletionList) {
      fsDeleteBudget(budget);
    }

    _budgetList.commitDeletion();

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
  void fsAddBudget(Budget budget) async {
    budget.docID = await FirestoreController.addBudget(budget: budget);
  }

  void fsUpdateAllDirty() {
    for (Budget dirtyBoi in _budgetList.getDirtyList()) {
      FirestoreController.updateBudget(budget: dirtyBoi);
    }
  }

  void fsUpdateBudget(Budget budget) async {
    FirestoreController.updateBudget(budget: budget);
    notifyListeners();
  }

  void fsDeleteBudget(Budget budget) {
    FirestoreController.deleteBudget(budget: budget);
  }
}
