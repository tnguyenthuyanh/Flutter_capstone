import 'dart:collection';
import 'package:cap_project/viewscreen/components/texts/emptycontenttext.dart';
import 'package:cap_project/viewscreen/components/texts/titletext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../View_Model/budget_data.dart';
import '../View_Model/budgetlistmode_data.dart';
import '../model/budget.dart';
import '../model/constant.dart';
import 'addbudget_screen.dart';
import 'components/budget_listviewtile.dart';

class BudgetsScreen extends StatefulWidget {
  static const routeName = '/budgetsScreen';
  static const _screenName = "Budget Templates";

  const BudgetsScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _BudgetsState();
}

class _BudgetsState extends State<BudgetsScreen> {
  late _Controller _con;

  // state vars
  BudgetListMode _currentMode = BudgetListMode.view;

  @override
  void initState() {
    super.initState();
    _con = _Controller(this);
  }

  void render(fn) {
    setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    _currentMode = Provider.of<BudgetListModeData>(context).currentMode;

    return WillPopScope(
      onWillPop: _con.onPopScope,
      child: Scaffold(
        //        APPBAR      --------------------------------------------------
        appBar: AppBar(
          title: TitleText(title: BudgetsScreen._screenName),
          actions: [
            // delete/cancel button
            IconButton(
              icon: _currentMode == BudgetListMode.delete
                  ? const Icon(Icons.cancel)
                  : const Icon(Icons.delete),
              onPressed: _con.onDeleteModeButtonPressed,
            ),
            // confirm button
            if (_currentMode == BudgetListMode.delete)
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: _con.onConfirmButtonPressed,
              ),
          ],
        ),
        // Add FloatingActionButton
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: _con.onAddButtonPressed,
        ),
        //        BODY      --------------------------------------------------
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Consumer<BudgetData>(
            builder: (context, budgets, child) {
              //no budgets - display a text with the message
              if (budgets.budgets.isEmpty) {
                return EmptyContentText(message: "No budgets");
              } else {
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemCount: budgets.budgets.length,
                        itemBuilder: (BuildContext context, int index) {
                          // get the budget at the selected index
                          Budget _temp = budgets.budgets[index];

                          return BudgetListViewTile(
                            currentMode: _currentMode,
                            budget: _temp,
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _Controller {
  final _BudgetsState _state;
  _Controller(this._state);
  BudgetListMode _currentMode = BudgetListMode.view;

  // button events
  //---------------------------------------------------------------------------
  Future<void> onAddButtonPressed() async {
    if (_state._currentMode == BudgetListMode.delete) {
      onCancelButtonPressed();
    }
    await Navigator.pushNamed(_state.context, AddBudgetScreen.routeName);
    _state.render(() {});
  }

  // enter delete selection mode
  void onDeleteModeButtonPressed() {
    // if mode is already delete, set mode to view
    if (getCurrentMode() == BudgetListMode.delete) {
      onCancelButtonPressed();
    } else {
      setCurrentMode(BudgetListMode.delete);
    }
  }

  // unstage any budgets selected for deletion and set mode to view
  void onCancelButtonPressed() {
    Provider.of<BudgetData>(_state.context, listen: false).cancelDeletion();
    setCurrentMode(BudgetListMode.view);
  }

  void onConfirmButtonPressed() {
    // delete staged budgets and set mode to view
    Provider.of<BudgetData>(_state.context, listen: false).confirmDeletion();
    setCurrentMode(BudgetListMode.view);
  }

  // if back arrow is pressed
  Future<bool> onPopScope() {
    onCancelButtonPressed();
    Navigator.pop(_state.context);
    return Future.value(false);
  }
  //---------------------------------------------------------------------------

  // // Mode methods
  // //---------------------------------------------------------------------------
  BudgetListMode getCurrentMode() {
    return Provider.of<BudgetListModeData>(_state.context, listen: false)
        .currentMode;
  }

  void setCurrentMode(BudgetListMode mode) {
    Provider.of<BudgetListModeData>(_state.context, listen: false).currentMode =
        mode;
  }
  //---------------------------------------------------------------------------

  UnmodifiableListView<Budget> getBudgetListView() {
    if (Provider.of<BudgetData>(_state.context).budgets != null) {
      return Provider.of<BudgetData>(_state.context).budgets;
    } else {
      return UnmodifiableListView(<Budget>[]);
    }
  }
  //---------------------------------------------------------------------------
}
