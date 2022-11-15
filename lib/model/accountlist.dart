import 'dart:collection';
import 'package:cap_project/model/storableobject.dart';
import 'package:cap_project/viewscreen/components/debug/debugprinter.dart';
import 'account.dart';

class AccountList {
  final DebugPrinter printer = DebugPrinter(className: "AccountList");

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

  void setNewCurrent(Account newCurrent) {
    printer.setMethodName(methodName: "setNewCurrent");

    if (_objectList.length > 1) {
      for (StorableInterface object in _objectList) {
        if (!identical(newCurrent, object)) {
          // TODO:Remove-debug
          printer.debugPrint(
              "Comparing: " + newCurrent.title + " to " + object.title);

          if (object.isCurrent!) {
            object.isCurrent = false;
            object.setDirty(true);

            // TODO: Remove- debug
            printer.debugPrint("object " + object.title + " set dirty");
          }
        }
      }
    }
  }

  // Get a list of all objects that need to be updated in firestore
  List<StorableInterface> getDirtyList() {
    printer.setMethodName(methodName: "getDirtyList");

    List<StorableInterface> temp = [];

    for (StorableInterface object in _objectList) {
      if (object.isDirty()) {
        temp.add(object);

        // TODO: Remove-debug
        printer.debugPrint("Adding to dirtyList: ");
        printer.debugPrint(object.serialize());
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

  void stageForDeletion(StorableInterface object) {
    if (!(_deletionList.contains(object))) {
      _deletionList.add(object as Account);
    }
  }

  // // removes object from the deletionlist
  void unstageForDeletion(StorableInterface object) {
    if (_deletionList.contains(object)) {
      _deletionList.remove(object);
    }
  }

  // // perform the deletion
  void commitDeletion() {
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
  bool isStagedForDeletion(StorableInterface object) {
    return _deletionList.contains(object);
  }
}
