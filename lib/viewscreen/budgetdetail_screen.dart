import 'dart:collection';
import 'package:cap_project/viewscreen/components/texts/emptycontenttext.dart';
import 'package:cap_project/viewscreen/components/texts/ohnoeserrortext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../View_Model/budget_data.dart';
import '../model/budget.dart';
import '../model/constant.dart';
import 'addbudget_screen.dart';
import 'components/budgetdetailfield.dart';
import 'components/buttons/mysizedbutton.dart';

// TODO: add edit functionality
// TODO: add copy to functionality
// TODO: add delete functionality
class BudgetDetailScreen extends StatefulWidget {
  static const routeName = '/budgetDetailScreen';
  static const _screenName = "Budget Detail";

  const BudgetDetailScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BudgetDetailState();
}

class _BudgetDetailState extends State<BudgetDetailScreen> {
  late _Controller _con;
  Budget? _selected;
  Budget? _current;

  // state vars

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
    _selected = Provider.of<BudgetData>(context).selectedBudget;
    _current = Provider.of<BudgetData>(context).currentBudget;

    return WillPopScope(
        onWillPop: _con.onPopScope,
        child: Scaffold(
          //        APPBAR     --------------------------------------------------
          appBar: AppBar(
            title: const Text(BudgetDetailScreen._screenName),
          ),
          //        BODY      --------------------------------------------------
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: _selected == null
                    ? OhNoesErrorText(
                        message:
                            'There has been a mistake. Selected Budget is null')
                    : Column(
                        children: [
                          BudgetDetailField(
                              titleText: "Title", fieldText: _selected!.title),
                          MySizedButton(
                            buttonText: "Use",
                            onPressedCallback: _selected! == _current
                                ? null
                                : _con.onUseButtonPressed,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ));
  }
}

class _Controller {
  final _BudgetDetailState _state;
  _Controller(this._state);

  // button events
  //---------------------------------------------------------------------------
  // if back arrow is pressed
  Future<bool> onPopScope() {
    Navigator.pop(_state.context);
    // TODO: fix this
    throw "I don't know what happened";
  }

  void onUseButtonPressed() {
    Provider.of<BudgetData>(_state.context, listen: false)
        .setCurrentBudget(_state._selected!);
  }

  //---------------------------------------------------------------------------

  // // Mode methods
  // //---------------------------------------------------------------------------

  //---------------------------------------------------------------------------

  //---------------------------------------------------------------------------
}
