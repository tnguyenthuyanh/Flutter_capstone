import 'package:cap_project/controller/auth_controller.dart';
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

  static const String noBudgetsString = "No budgets";

  // Template related
  Budget? _currentTemplate;
  bool _noTemplates = true;

  bool get noTemplates => _noTemplates;
  BudgetMonth get selectedMonth => _selectedMonth!;
  BudgetMonth get currentMonth => _currentMonth!;

  String get totalExpensesString {
    if (_currentMonth != null) {
      return _currentMonth!.totalExpenses.toString();
    } else {
      return "0";
    }
  }

  String get totalIncomeString {
    if (_currentMonth != null) {
      return _currentMonth!.totalIncome.toString();
    } else {
      return "0";
    }
  }

  // Budget Month Related
  BudgetMonth? _selectedMonth; // Month selected in drop down
  BudgetMonth? _currentMonth; // Current month, probably the same as selected
  List<BudgetMonth> _months = [];

  final List<String> _items = [
    noBudgetsString,
  ];

  HomeScreenViewModel() {
    printer.setMethodName(methodName: "Constructor");
    printer.debugPrint("Constructing HomeScreenViewModel");
  }

  void initialize() async {
    printer.setMethodName(methodName: "initialize");
    printer.debugPrint("initializing");

    try {
      await storageGetCurrentTemplate();

      if (_currentTemplate != null) {
        printer.debugPrint("current template found");

        await storageLoadMonthsForTemplate();
      }
    } catch (e) {
      printer.debugPrint("Error loading current template: $e");
    }
  }

  injectFakeCats() {
    _currentMonth!.addCategory(FakeCategory(
        title: "Paycheck",
        amount: 2.50,
        categoryType: FakeCategory.INCOME_TYPE));
    _currentMonth!.addCategory(FakeCategory(
        title: "CryptoMining",
        amount: 0.01,
        categoryType: FakeCategory.INCOME_TYPE));
    _currentMonth!.addCategory(FakeCategory(
        title: "doritos",
        amount: 600,
        categoryType: FakeCategory.EXPENSE_TYPE));
    _currentMonth!.addCategory(FakeCategory(
        title: "electricity",
        amount: 600,
        categoryType: FakeCategory.EXPENSE_TYPE));
  }

  String getSelectedMonthString() {
    if (_selectedMonth != null) {
      return _selectedMonth!.getMonthString();
    } else {
      return _items[0];
    }
  }

  String getCurrentMonthString() {
    if (_currentMonth != null) {
      return _currentMonth!.getMonthString();
    } else {
      return noBudgetsString;
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

  Future createCurrentMonth() async {
    printer.setMethodName(methodName: "createCurrentMonth");

    BudgetMonth temp = BudgetMonth(
        ownerUid: AuthController.currentUser!.uid,
        date: DateTime.now(),
        templateId: _currentTemplate!.docID!);

    _currentMonth = temp;
    addMonthStringToItems(temp.getMonthString());

    try {
      await storageAddBudgetMonth(temp);
    } catch (e) {
      printer.debugPrint("Error adding current month: $e");
    }
    notifyListeners();
  }

  //  Component Update handlers
  //----------------------------------------------------------------------------
  void newMonthSelected(String? value) {
    printer.setMethodName(methodName: "newMonthSelected");
    printer.debugPrint("New Month selected");
  }

  void addMonthStringToItems(String monthString) {
    if (_items.contains(noBudgetsString)) {
      _items.remove(noBudgetsString);
    }
    _items.add(monthString);

    notifyListeners();
  }

  //  Storage methods
  //----------------------------------------------------------------------------
  Future storageGetCurrentTemplate() async {
    printer.setMethodName(methodName: "storageGetCurrentTemplate");
    printer.debugPrint("Getting current template");

    try {
      List<Budget> _tempTemplates = await FirestoreController.getBudgetList();

      // If the user has no template budgets
      if (_tempTemplates.isEmpty) {
        printer.debugPrint("Temp Templates is empty: No user templates loaded");
        _noTemplates = true;

        // TODO: prompt to add templates
      }
      // If the user HAS template budgets
      else {
        _noTemplates = false;
        printer.debugPrint("Found templates. Finding current");

        // Look through templates for one to set to current
        for (Budget template in _tempTemplates) {
          if (template.isCurrent!) {
            printer.debugPrint("${template.title} set to current");

            _currentTemplate = template;
          }
        }
      }
    } catch (e) {
      printer.debugPrint("Error loading template budget: $e");
    }
  }

  Future<void> storageLoadMonthsForTemplate() async {
    printer.setMethodName(methodName: "storageLoadMonthsForTemplate");

    printer.debugPrint("Loading months for  ${_currentTemplate!.title}");

    List<BudgetMonth> temp = await FirestoreController.getMonthsList(
        templateId: _currentTemplate!.docID);

    // If budget months were found for the template
    if (temp.isEmpty) {
      printer.debugPrint("No month budgets found.");

      await createCurrentMonth();
    } else {
      printer.debugPrint("BudgetMonths were found. Finding Current");

      // Find a budget month for the current month
      DateTime now = DateTime.now();

      // If there is a current budget month, set it
      for (BudgetMonth month in temp) {
        if (month.containsDate(now)) {
          printer.debugPrint("Found current BudgetMonth. Setting currentMonth");
          _currentMonth = month;
          addMonthStringToItems(month.getMonthString());
        }
      }

      // If no budget month found for this month
      if (_currentMonth == null) {
        if (_currentTemplate != null) {
          printer.debugPrint(
              "Current Month not found. Template exists, so creating one");

          await createCurrentMonth();
        }

        // TODO: Later: Search other user template budgets for budget months for this month

        // TODO: Later: If found, ask if the user would like to copy transactions

        // If none found,

      }
    }

    injectFakeCats();
    notifyListeners();
  }

  Future<void> storageAddBudgetMonth(BudgetMonth month) async {
    printer.setMethodName(methodName: "storageAddBudgetMonth");
    printer.debugPrint("Sending ${month.getMonthString()} to storage");
    await FirestoreController.addBudgetMonth(object: month);
  }

  Future getCategoriesForMonth(BudgetMonth month) async {}
}
