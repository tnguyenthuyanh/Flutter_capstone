import 'dart:collection';
import 'package:cap_project/controller/firestore_controller.dart';
import 'package:cap_project/viewscreen/components/debug/debugprinter.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import '../model/budgetlist.dart';
import '/model/budget.dart';

class BudgetData extends ChangeNotifier {
  DebugPrinter printer = DebugPrinter(className: "BudgetData", printOff: true);

  BudgetList _budgetList = BudgetList();
  Budget? _selectedBudget = null; // budget being VIEWED
  Budget? _currentBudget = null; // budget being USED for calculations etc

  BudgetData() {
    fsLoadBudgets();
    printer.setPrintOff(printOff: true);
  }

// ---- getters for encapsulated member variables ------------------------------
  UnmodifiableListView<Budget> get budgets => _budgetList.budgetsListView;
  Budget? get selectedBudget => _selectedBudget;
  Budget? get currentBudget => _currentBudget;
  List<int> get selectedIndices => _budgetList.selectedIndices;
  int get numberOfBudgets => _budgetList.size;

  /// add the budget to the local budget list, store in firebase and notify
  void add(Budget budget) async {
    printer.setMethodName(methodName: "add");
    budget.docID = await fsAddBudget(budget);

    _budgetList.add(budget);

    // if the new budget is set to current, set update other budgets, if any
    if (budget.isCurrent! || _currentBudget == null) {
      setCurrentBudget(budget);
    }

    notifyListeners();
  }

  void setCurrentBudget(Budget budget) {
    printer.setMethodName(methodName: "setCurrentBudget");

    _currentBudget = budget;
    budget.dirty = true;

    budget.isCurrent = true;

    printer.debugPrint('Current updated to: ' + budget.title);

    // if there is more than one budget, set others to inactive
    if (_budgetList.size > 1) {
      _budgetList.setNewCurrentBudget(budget);
    }

    // update firestore, if needed
    fsUpdateAllDirty();
    _budgetList.clearDirtyFlags();

    printer
        .debugPrint(budget.title + " current: " + budget.isCurrent.toString());

    notifyListeners();
  }

  // sets the budget selected for view/edit in the budgets list
  void setSelectedBudget(Budget budget) {
    _selectedBudget = budget;
    notifyListeners();
  }

  void updateSelectedBudget(String newTitle) {
    printer.setMethodName(methodName: "updateSelectedBudget");

    if (_selectedBudget != null) {
      printer.debugPrint("Updating budget title");

      _selectedBudget!.title = newTitle;
    } else {
      showToast("Budget was not updated. Selected budget is null");
      return;
    }

    try {
      fsUpdateBudget(_selectedBudget!);
    } catch (e) {
      printer.debugPrint(e.toString());
    }
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
    printer.setMethodName(methodName: "confirmDeletion");

    printer.debugPrint("Before deletion:");

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
    printer.setMethodName(methodName: "fsLoadBudgets");

    printer.debugPrint("getting Budget List");
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

    notifyListeners();

    return docID;
  }

  Future<void> fsUpdateAllDirty() async {
    for (Budget dirtyBoi in _budgetList.getDirtyList()) {
      await FirestoreController.updateBudget(budget: dirtyBoi);
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
