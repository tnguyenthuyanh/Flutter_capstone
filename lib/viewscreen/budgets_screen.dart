import 'dart:collection';
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
  static const _screenName = "Budgets";

  const BudgetsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BudgetsState();
}

class _BudgetsState extends State<BudgetsScreen> {
  late _Controller _con;

  // state vars
  // TODO: Fix this- change current mode to a provider consumer
  // TODO: separate viewing from isCurrent. isCurrent is global- don't need to set
  // the budget, just need to view it
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
          title: const Text(BudgetsScreen._screenName),
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
                return Text(
                  'No Budgets to show',
                  style: Theme.of(context).textTheme.headline5,
                );
              } else {
                return Column(
                  children: <Widget>[
                    Expanded(
                      child:
                          // budget list
                          ListView.builder(
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
    print("delete button pressed");
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
    // TODO: fix this
    throw "I don't know what happened";
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
