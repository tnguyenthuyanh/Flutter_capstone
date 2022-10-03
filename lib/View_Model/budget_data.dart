import 'dart:collection';
import 'package:cap_project/controller/firestore_controller.dart';
import 'package:cap_project/model/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../controller/auth_controller.dart';
import '../model/budgetlist.dart';
import '/model/budget.dart';

class BudgetData extends ChangeNotifier {
  BudgetList _budgetList = BudgetList();
  Budget? _selectedBudget = null;

  BudgetData() {
    loadBudgets();
  }

  // getters for encapsulated member variables
  UnmodifiableListView<Budget> get budgets => _budgetList.budgetsListView;
  Budget? get selectedBudget => _selectedBudget;
  List<int> get selectedIndices => _budgetList.selectedIndices;

  int get numberOfBudgets => _budgetList.size;

  void loadBudgets() async {
    List<Budget> _tempBudgets = await FirestoreController.getBudgetList();

    // load all the budgets into the provider's budget list
    for (Budget budget in _tempBudgets) {
      _budgetList.add(budget);

      // if the budget is set as current, set the provider's selected budget
      if (budget.isCurrent!) {
        setSelectedBudget(budget);
      }
    }
  }

  void setSelectedBudget(Budget budget) {
    _selectedBudget = budget;

    _budgetList.setNewSelectedBudget(budget);
    for (Budget dirtyBoi in _budgetList.getDirtyList()) {
      FirestoreController.updateBudget(budget: dirtyBoi);
    }

    notifyListeners();
  }

  // add the budget to the local budget list and store in firebase
  // then notify listeners
  void add(Budget budget) {
    // add to the budget list
    _budgetList.add(budget);

    if (budget.isCurrent!) {
      setSelectedBudget(budget);
    }
    // store in firebase
    storeBudget(budget);

    notifyListeners();
  }

  // modifies the values of the CURRENTLY SELECTED budget
  void updateBudget(String title) async {
    // TODO: implement firebase controller updateBudget
    _selectedBudget?.title = title;
    notifyListeners();
  }

  // store adds the budget to Firebase without notifying listeners
  void storeBudget(Budget budget) async {
    budget.docID = await FirestoreController.addBudget(budget: budget);
  }

  void addAll(List<Budget> budgetList) {
    _budgetList.addAll(budgetList);
    notifyListeners();
  }

  void stageForDeletion(Budget budget) {
    _budgetList.stageForDeletion(budget);
    notifyListeners();
  }

  void unstageForDeletion(Budget budget) {
    _budgetList.unstageForDeletion(budget);
    notifyListeners();
  }

  void confirmDeletion() {
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
}
