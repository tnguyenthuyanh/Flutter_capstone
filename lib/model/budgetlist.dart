import 'dart:collection';
import '/model/budget.dart';

class BudgetList {
  late List<Budget> _budgets; // all budgets
  late List<Budget> _deletionList; // budgets staged for deletion
  late List<int> _selectedIndices; // and their indices

  int get size => _budgets.length; // how many budgets

  BudgetList() {
    _budgets = <Budget>[];
    _deletionList = <Budget>[];
  }

  // ---- GETTERS ----
  List<int> get selectedIndices => _selectedIndices;
  List<Budget> get deletionList => _deletionList;
  UnmodifiableListView<Budget> get budgetsListView =>
      UnmodifiableListView(_budgets);

  void add(Budget budget) {
    _budgets.add(budget);
  }

  void setNewCurrentBudget(Budget newCurrent) {
    if (_budgets.length > 1) {
      // set all active budgets but newCurrent to inactive
      // and set their dirty flag
      for (Budget budget in _budgets) {
        if (!budget.equals(newCurrent)) {
          // TODO:Remove-debug
          print("Comparing: " + newCurrent.title + " to " + budget.title);

          if (budget.isCurrent!) {
            budget.isCurrent = false;
            budget.dirty = true;

            // TODO: Remove- debug
            print("BudgetList: budget " + budget.title + " set dirty");
          }
        }
      }
    }
  }

  // Get a list of all budgets that need to be updated in firestore
  List<Budget> getDirtyList() {
    List<Budget> temp = [];

    for (Budget budget in _budgets) {
      if (budget.dirty) {
        temp.add(budget);

        // TODO: Remove-debug
        print("Adding to dirtyList: ");
        print(budget.serialize());
      }
    }
    return temp;
  }

  void clearDirtyFlags() {
    for (Budget budget in _budgets) {
      budget.dirty = false;
    }
  }

  void addAll(List<Budget> budgets) {
    for (Budget budget in budgets) {
      add(budget);
    }
  }

  Budget? getBudgetById(String id) {
    for (Budget budget in _budgets) {
      if (budget.docID == id) {
        return budget;
      }
    }
    return null;
  }

  bool containsBudget(Budget budget) {
    if (getBudgetById(budget.docID!) != null) {
      return true;
    }
    return false;
  }

  void stageForDeletion(Budget budget) {
    // if the deletionList is null, instantiate it
   // _deletionList ??= <Budget>[];

    // if the budget isn't in the deletionlist already, add it
    if (!(_deletionList.contains(budget))) {
      _deletionList.add(budget);
    }
  }

  // removes a budget from the deletionlist
  void unstageForDeletion(Budget budget) {
    if (_deletionList.contains(budget)) {
      _deletionList.remove(budget);
    }
  }

  // perform the deletion
  void commitDeletion() {
    // iterate through the deletionlist and remove budgets from
    // the provider's budget list
    for (Budget budget in _deletionList) {
      if (_budgets.contains(budget)) {
        _budgets.remove(budget);
      }
    }
    _deletionList.clear();
  }

  // removes all budgets from the deletionlist without changes to
  // the provider's budgetlist or firebase
  void cancelDeletion() {
    _deletionList.clear();
  }

  // returns if the budget is to be deleted or not
  bool isStagedForDeletion(Budget budget) {
    return _deletionList.contains(budget);
  }
}
