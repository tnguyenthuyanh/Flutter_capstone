import 'dart:collection';
import '/model/budget.dart';

class BudgetList {
  late List<Budget> _budgets;

  // budgets staged for deletion and their indices
  late List<Budget> _deletionList;
  late List<int> _selectedIndices;

  BudgetList() {
    _budgets = <Budget>[];
    _deletionList = <Budget>[];
  }

  UnmodifiableListView<Budget> get budgetsListView =>
      UnmodifiableListView(_budgets);

  List<int> get selectedIndices => _selectedIndices;

  void add(Budget budget) {
    _budgets.add(budget);
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
    // the provider's budget list and firebase
    for (Budget budget in _deletionList) {
      if (_budgets.contains(budget)) {
        _budgets.remove(budget);
        // TODO: Implement Firebase

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
