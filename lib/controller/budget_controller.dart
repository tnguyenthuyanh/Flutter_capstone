import 'package:cap_project/controller/firestore_controller.dart';
import 'package:cap_project/viewscreen/components/debug/debugprinter.dart';
import 'package:oktoast/oktoast.dart';
import '../model/budgetlist.dart';
import '/model/budget.dart';

class BudgetController {
  DebugPrinter printer =
      DebugPrinter(className: "BudgetController", printOff: true);

  BudgetList _list = BudgetList();
  Budget? _selected = null; // budget being VIEWED
  Budget? _current = null; // budget being USED for calculations etc

  BudgetController() {
    fsLoadBudgets();
  }

// ---- getters for encapsulated member variables ------------------------------
  Budget? get selectedBudget => _selected;
  Budget? get currentBudget => _current;
  List<int> get selectedIndices => _list.selectedIndices;
  int get numberOfBudgets => _list.size;

  /// add the budget to the local budget list, store in firebase and notify
  void add(Budget budget) async {
    budget.docID = await fsAddBudget(budget);

    _list.add(budget);

    // if the new budget is set to current, set update other budgets, if any
    if (budget.isCurrent! || _current == null) {
      setCurrentBudget(budget);
    }
  }

  void setCurrentBudget(Budget budget) {
    printer.setMethodName(methodName: "setCurrentBudget");

    _current = budget;
    budget.dirty = true;

    budget.isCurrent = true;

    printer.debugPrint('Current updated to: ${budget.title}');

    // if there is more than one budget, set others to inactive
    if (_list.size > 1) {
      _list.setNewCurrentBudget(budget);
    }

    // update firestore, if needed
    fsUpdateAllDirty();
    _list.clearDirtyFlags();

    printer
        .debugPrint("${budget.title} current: ${budget.isCurrent.toString()}");
  }

  // sets the budget selected for view/edit in the budgets list
  void setSelectedBudget(Budget budget) {
    _selected = budget;
  }

  void updateSelectedBudget(String newTitle) {
    printer.setMethodName(methodName: "updateSelectedBudget");

    if (_selected != null) {
      printer.debugPrint("Updating budget title");

      _selected!.title = newTitle;
    } else {
      showToast("Budget was not updated. Selected budget is null");
      return;
    }

    try {
      fsUpdateBudget(_selected!);
    } catch (e) {
      printer.debugPrint(e.toString());
    }
  }

// ---- Deletion Related Methods -----------------------------------------------
  void stageForDeletion(Budget budget) {
    _list.stageForDeletion(budget);
  }

  void unstageForDeletion(Budget budget) {
    _list.unstageForDeletion(budget);
  }

  void confirmDeletion() {
    printer.setMethodName(methodName: "confirmDeletion");

    for (Budget budget in _list.deletionList) {
      fsDeleteBudget(budget);

      if (budget == _current) {
        _current = null;
      }
      if (budget == _selected) {
        _selected = null;
      }
    }

    _list.commitDeletion();
  }

  void cancelDeletion() {
    _list.cancelDeletion();
  }

  bool isStagedForDeletion(Budget budget) {
    return _list.isStagedForDeletion(budget);
  }

// ---- Firestore Related Methods ----------------------------------------------
  void fsLoadBudgets() async {
    List<Budget> _tempBudgets = await FirestoreController.getBudgetList();

    // load all the budgets into the provider's budget list
    for (Budget budget in _tempBudgets) {
      _list.add(budget);

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

    printer.debugPrint(
        "Added ${budget.title} to FireStore with docid ${budget.docID!}");

    return docID;
  }

  Future<void> fsUpdateAllDirty() async {
    for (Budget dirtyBoi in _list.getDirtyList()) {
      await FirestoreController.updateBudget(budget: dirtyBoi);
    }
  }

  void fsUpdateBudget(Budget budget) async {
    FirestoreController.updateBudget(budget: budget);
  }

  void fsDeleteBudget(Budget budget) {
    FirestoreController.deleteBudget(budget: budget);
  }
}
