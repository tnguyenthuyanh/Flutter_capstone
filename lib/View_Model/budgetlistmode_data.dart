import 'package:cap_project/model/constant.dart';
import 'package:flutter/material.dart';

class BudgetListModeData extends ChangeNotifier {
  late BudgetListMode _currentMode;

  BudgetListModeData() {
    _currentMode = BudgetListMode.view;
  }

  BudgetListMode get currentMode => _currentMode;
  set currentMode(BudgetListMode mode) {
    _currentMode = mode;
    notifyListeners();
  }
}
