import 'package:cap_project/controller/auth_controller.dart';
import 'package:cap_project/viewscreen/components/debug/debugprinter.dart';
import 'package:flutter/material.dart';
import '../controller/firestore_controller.dart';
import '../model/budget.dart';
import '../model/budgetmonth.dart';

class HomeScreenViewModel extends ChangeNotifier {
  DebugPrinter printer =
      DebugPrinter(className: "HomeScreenViewModel", printOff: true);

  static const String noBudgetsString = "No budgets";

  /*----------------------------------------------------------------------------
      Template related
  ----------------------------------------------------------------------------*/
  Budget? _currentTemplate;
  bool _noTemplates = true;

  bool get noTemplates => _noTemplates;

  /*----------------------------------------------------------------------------
      Budget Month related
  ----------------------------------------------------------------------------*/
  BudgetMonth? _selectedMonth; // Month selected in drop down
  BudgetMonth? _currentMonth; // Current month, probably the same as selected

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

  /*----------------------------------------------------------------------------
      Budget Months List related
  ----------------------------------------------------------------------------*/
  List<BudgetMonth> _months = [];

  final List<String> _items = [
    noBudgetsString,
  ];

  HomeScreenViewModel() {
    printer.setMethodName(methodName: "Constructor");
    printer.debugPrint("Constructing HomeScreenViewModel");
  }

  Future<void> initialize() async {
    printer.setMethodName(methodName: "initialize");
    printer.debugPrint("initializing");

    try {
      await storageGetCurrentTemplate();

      // If a Budget exists and is set to current, load it's Budget Months
      if (_currentTemplate != null) {
        printer.debugPrint("current template found");

        await storageLoadMonthsForTemplate();
      }

      injectFakeCats();
    }
    // If no Budget is found
    catch (e) {
      printer.debugPrint("Error loading current template: $e");
    }
  }

  Future<void> update() async {
    await initialize();
  }

  injectFakeCats() {
    _currentMonth!.addAmount(FakeCategory(
        title: "Paycheck",
        amount: 2.50,
        categoryType: FakeCategory.INCOME_TYPE));
    _currentMonth!.addAmount(FakeCategory(
        title: "CryptoMining",
        amount: 0.01,
        categoryType: FakeCategory.INCOME_TYPE));
    _currentMonth!.addAmount(FakeCategory(
        title: "doritos",
        amount: 600,
        categoryType: FakeCategory.EXPENSE_TYPE));
    _currentMonth!.addAmount(FakeCategory(
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

  /*----------------------------------------------------------------------------
    Component Update handlers
  ----------------------------------------------------------------------------*/
  void newMonthSelected(String? value) {
    printer.setMethodName(methodName: "newMonthSelected");
    printer.debugPrint("New Month selected");
  }

  void addMonthStringToItems(String monthString) {
    if (_items.contains(noBudgetsString)) {
      _items.remove(noBudgetsString);
    }

    if (!_items.contains(monthString)) {
      _items.add(monthString);
    }

    notifyListeners();
  }

  /*----------------------------------------------------------------------------
    Storage methods
  ----------------------------------------------------------------------------*/
  Future storageGetCurrentTemplate() async {
    /*
      Attempts to load Budgets(templates) for the current User.
      If no templates are found sets _noTemplates to true,
      TODO: prompt to add templates

      If only one template is found, if not set to current, set
      If more than one template is found, search for current. 
      
    */
    printer.setMethodName(methodName: "storageGetCurrentTemplate");
    printer.debugPrint("Getting current template");

    try {
      List<Budget> _tempTemplates = await FirestoreController.getBudgetList();

      // If the user has no template budgets
      if (_tempTemplates.isEmpty) {
        printer.debugPrint("Temp Templates is empty: No user templates loaded");
        _noTemplates = true;
        return;
      }
      // If the user HAS template budgets
      else {
        _noTemplates = false;
        printer.debugPrint("Found templates. Finding current");

        // If only one template is found, set it to current
        if (_tempTemplates.length == 1) {
          _tempTemplates[0].isCurrent = true;
          _currentTemplate = _tempTemplates[0];
        }
        // If more than one, look through templates for one to set to current
        else {
          for (Budget template in _tempTemplates) {
            if (template.isCurrent!) {
              printer.debugPrint("Using ${template.title} as current");

              _currentTemplate = template;
            }
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

    List<BudgetMonth> tempMonths = await FirestoreController.getMonthsList(
        templateId: _currentTemplate!.docID);

    // If no Budget Months were found for the template,
    // create one for the current month
    if (tempMonths.isEmpty) {
      printer.debugPrint("No month budgets found.");
      await createCurrentMonth();
    }
    // If Budget Months were found, find the Current Month
    else {
      printer.debugPrint("BudgetMonths were found. Finding Current");

      // If there is a current Budget Month, set _currentMonth
      for (BudgetMonth month in tempMonths) {
        if (month.containsDate(DateTime.now())) {
          printer.debugPrint("Found current BudgetMonth. Setting currentMonth");
          _currentMonth = month;
        }
        addMonthStringToItems(month.getMonthString());
      }

      // If no Budget Month found for this month
      if (_currentMonth == null) {
        // If template exists, create a Budget Month for this month
        printer.debugPrint("No Current Month- creating one");

        await createCurrentMonth();
      }

      // TODO: Later: Search other user template budgets for budget months for this month
      // TODO: Later: If found, ask if the user would like to copy transactions
    }
    notifyListeners();
  }

  Future<void> storageAddBudgetMonth(BudgetMonth month) async {
    printer.setMethodName(methodName: "storageAddBudgetMonth");
    printer.debugPrint("Sending ${month.getMonthString()} to storage");

    await FirestoreController.addBudgetMonth(object: month);
  }

  Future getCategoriesForMonth(BudgetMonth month) async {}
}
