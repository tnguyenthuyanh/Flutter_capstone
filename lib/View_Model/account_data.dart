import 'dart:collection';
import 'package:cap_project/controller/firestore_controller.dart';
import 'package:cap_project/model/constant.dart';
import 'package:cap_project/model/storableobject.dart';
import 'package:cap_project/viewscreen/components/debug/debugprinter.dart';
import 'package:flutter/material.dart';
import '../model/account.dart';
import '../model/accountlist.dart';

class AccountData extends ChangeNotifier {
  DebugPrinter printer = DebugPrinter(className: "AccountData");

  AccountList _list = AccountList();
  Account? _selected = null; // account being VIEWED
  Account? _current = null; // account being USED for calculations etc
  ListMode _currentMode = ListMode.view;

  AccountData() {
    fsLoad();
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

  // add to the local list, store in firebase and notify
  void add(Account object) async {
    object.docId = await fsAdd(object);

    _list.add(object);

    if (object.isCurrent! || _current == null) {
      setCurrent(object);
    }

    notifyListeners();
  }

  void setCurrent(Account object) {
    printer.setMethodName(methodName: "setCurrent");

    _current = object;
    object.setDirty(true);

    object.isCurrent = true;

    // TODO: Remove - debug
    printer.debugPrint("Current updated to: $object.title");

    // if there is more than one budget, set others to inactive
    if (_list.size > 1) {
      _list.setNewCurrent(object);
    }

    // update firestore, if needed
    fsUpdateAllDirty();
    _list.clearDirtyFlags();

    // TODO:Remove-debug
    print("$object.title : isCurrent = $object.isCurrent.toString()");

    notifyListeners();
  }

//   // sets selected for view/edit in the acount list
  void setSelected(Account object) {
    _selected = object;
    notifyListeners();
  }

// // ---- Deletion Related Methods -----------------------------------------------
  void stageForDeletion(Account object) {
    _list.stageForDeletion(object);
    notifyListeners();
  }

  void unstageForDeletion(Account object) {
    _list.unstageForDeletion(object);
    notifyListeners();
  }

  void confirmDeletion() {
    printer.setMethodName(methodName: "confirmDeletion");

    // TODO: Remove-debug
    printer.debugPrint("Before deletion:");
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
    printer.debugPrint("After deletion: ");
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
  void fsLoad() async {
    List<Account> _temp = await FirestoreController.getAccountList();

    // load all the budgets into the provider's budget list
    for (Account object in _temp) {
      _list.add(object);

      // if the budget is set as current, set the provider's selected budget
      if (object.isCurrent!) {
        setCurrent(object);
      }
    }
  }

//   // add to firestore and set the object's docid
  Future<String> fsAdd(Account object) async {
    printer.setMethodName(methodName: "fsAdd");

    var docId = await FirestoreController.addAccount(object: object);
    object.docId = docId;

    // TODO: Remove - debug
    printer.debugPrint(
        "Added $object.title to FireStore with docid " + "$object.docId!");

    notifyListeners();

    return docId;
  }

  Future<void> fsUpdateAllDirty() async {
    printer.setMethodName(methodName: "fsUpdateAllDirty");

    for (StorableInterface dirtyBoi in _list.getDirtyList()) {
      await FirestoreController.updateAccount(object: dirtyBoi as Account);

      // TODO: Remove-debug
      printer.debugPrint("Sending to FS to update: $dirtyBoi.serialize()");
    }
  }

  void fsUpdate(Account object) async {
    FirestoreController.updateAccount(object: object);
    notifyListeners();
  }

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
