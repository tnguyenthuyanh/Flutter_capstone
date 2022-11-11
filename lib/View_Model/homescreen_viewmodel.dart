import 'package:cap_project/viewscreen/components/debug/debugprinter.dart';
import 'package:flutter/material.dart';

import '../controller/firestore_controller.dart';
import '../model/budget.dart';
import '../model/budgetmonth.dart';

/*
Flow:
Get Template
- If none
-- Prompt to add templates

- If the user HAS template budgets
-- Look through templates for one set to current
--- If found, load Budget Months for it
---- If months found
----- Find current month
------ If found, load

------ If not found
------- Search other templates for current month, if found create a new month
         from this template and copy all transactions over to the new budget
         month
---- If no months are found for the template, ask the user if they want to
       switch to a different template

--- If no template is set to current
---- Ask user if they want to switch to a different template.
----- If no, ask if they want to create a new one.

if none, check if any months for current month with other template
 if so, ask if switching to other template or creating a new month
if creating new ask if migrating transactions
create one for current month
*/

class HomeScreenViewModel extends ChangeNotifier {
  DebugPrinter printer = DebugPrinter(className: "HomeScreenViewModel");

  // Template related
  Budget? _currentTemplate;
  bool _noTemplates = true;

  bool get noTemplates => _noTemplates;

  // Budget Month Related
  BudgetMonth? _selectedMonth;
  BudgetMonth? _currentMonth;
  List<BudgetMonth> _months = [];

  // TODO: Remove, dev use
  final List<String> _items = [
    'No budgets yet',
    'Mock Month January',
    'Mock Month February'
  ];

  HomeScreenViewModel() {
    printer.setMethodName(methodName: "Constructor");

    try {
      storageGetCurrentTemplate();
      if (_currentTemplate != null) {
        storageLoadMonthsForTemplate();
      }
    } catch (e) {
      printer.debugPrint("Error loading current template: $e");
    }
  }

  String getCurrentMonthString() {
    if (_selectedMonth != null) {
      return _selectedMonth!.getMonthString();
    } else {
      return "No Budget selected";
    }
  }

  getMonthsMenuItems() {
    return _items.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  //  Component Update handlers
  //----------------------------------------------------------------------------
  void newMonthSelected(String? value) {
    printer.setMethodName(methodName: "newMonthSelected");
    printer.debugPrint("New Month selected");
  }

  //  Storage methods
  //----------------------------------------------------------------------------
  void storageGetCurrentTemplate() async {
    List<Budget> _tempTemplates = await FirestoreController.getBudgetList();

    // If the user has no template budgets
    if (_tempTemplates.isEmpty) {
      _noTemplates = true;
      // prompt to add templates
    }
    // If the user HAS template budgets
    else {
      // Look through templates for one set to current
      for (Budget template in _tempTemplates) {
        if (template.isCurrent!) {
          _currentTemplate = template;
        } else {
          _currentTemplate = null;
        }
      }
    }
  }

  void storageLoadMonthsForTemplate() async {
    printer.setMethodName(methodName: "storageLoadMonthsForTemplate");
    printer.debugPrint("Loading months for  ${_currentTemplate!.title}");

    List<BudgetMonth> temp = await FirestoreController.getMonthsList(
        templateId: _currentTemplate!.docID);

    // If budget months were found for the template
    if (temp.isNotEmpty) {
      // Find a budget month for the current month
      DateTime now = DateTime.now();

      // If there is a current budget month, set it
      for (BudgetMonth month in temp) {
        if (month.containsDate(now)) {
          _currentMonth = month;
        }
      }

      // If no budget month found for this month
      if (_currentMonth == null) {
        // Search other user template budgets for budget months for this month

        // If found, ask if the user would like to copy transactions

        // If none found,
      }
    }
  }
}
