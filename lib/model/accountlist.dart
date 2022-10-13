import 'dart:collection';
import 'package:cap_project/model/storableobject.dart';
import 'account.dart';

class AccountList {
  late List<Account> _objectList; // all objects
  late List<Account> _deletionList; // objects staged for deletion
  late List<int> _selectedIndices; // and their indices

  int get size => _objectList.length; // how many budgets

  AccountList() {
    _objectList = <Account>[];
    _deletionList = <Account>[];
  }

  // ---- GETTERS ----
  List<int> get selectedIndices => _selectedIndices;
  List<Account> get deletionList => _deletionList;
  UnmodifiableListView<Account> get accountsListView =>
      UnmodifiableListView(_objectList);

  void add(Account account) {
    _objectList.add(account);
  }

  // void setNewCurrentAccount(Budget newCurrent) {
  //   if (_budgets.length > 1) {
  //     // set all active budgets but newCurrent to inactive
  //     // and set their dirty flag
  //     for (Budget budget in _budgets) {
  //       if (!budget.equals(newCurrent)) {
  //         // TODO:Remove-debug
  //         print("Comparing: " + newCurrent.title + " to " + budget.title);

  //         if (budget.isCurrent!) {
  //           budget.isCurrent = false;
  //           budget.dirty = true;

  //           // TODO: Remove- debug
  //           print("BudgetList: budget " + budget.title + " set dirty");
  //         }
  //       }
  //     }
  //   }
  // }

  // Get a list of all objects that need to be updated in firestore
  List<StorableInterface> getDirtyList() {
    List<StorableInterface> temp = [];

    for (StorableInterface object in _objectList) {
      if (object.isDirty()) {
        temp.add(object);

        // TODO: Remove-debug
        print("Adding to dirtyList: ");
        print(object.serialize());
      }
    }
    return temp;
  }

  void clearDirtyFlags() {
    for (StorableInterface object in _objectList) {
      object.setDirty(false);
    }
  }

  StorableInterface? getById(String id) {
    for (StorableInterface object in _objectList) {
      if (object.docId == id) {
        return object;
      }
    }
    return null;
  }

  bool contains(StorableInterface object) {
    if (getById(object.docId!) != null) {
      return true;
    }
    return false;
  }

  // void stageForDeletion(StorableInterface object) {
  //   // if the budget isn't in the deletionlist already, add it
  //   if (!(_deletionList.contains(object))) {
  //     _deletionList.add(object);
  //   }
  // }

  // // removes a budget from the deletionlist
  // void unstageForDeletion(Budget budget) {
  //   if (_deletionList.contains(budget)) {
  //     _deletionList.remove(budget);
  //   }
  // }

  // // perform the deletion
  void commitDeletion() {
    // iterate through the deletionlist and remove object from
    // the provider's list
    for (StorableInterface object in _deletionList) {
      if (_objectList.contains(object)) {
        _objectList.remove(object);
      }
    }
    _deletionList.clear();
  }

  // removes all from the deletionlist without changing the provider's
  // list or firebase
  void cancelDeletion() {
    _deletionList.clear();
  }

  // // returns if the object is to be deleted or not
  bool isStagedForDeletion(Account object) {
    return _deletionList.contains(object);
  }
}
