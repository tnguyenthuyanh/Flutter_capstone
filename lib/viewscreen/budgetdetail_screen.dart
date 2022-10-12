import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import '../model/budget.dart';
import '../model/constant.dart';
import '../View_Model/budget_data.dart';
import 'package:cap_project/viewscreen/budgetCategory.dart';
import 'package:cap_project/viewscreen/components/texts/ohnoeserrortext.dart';
import 'components/budgetdetailfield.dart';
import 'components/buttons/modebuttons/editcancelmode_button.dart';
import 'components/buttons/mysizedbutton.dart';
import 'components/textfields/budgettitle_textfield.dart';
import 'components/texts/titletext.dart';

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

  // state vars
  Budget? _selected;
  Budget? _current;
  bool _editMode = false;
  String? newTitle;
  var _formKey = GlobalKey<FormState>();

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

    return Scaffold(
      //        APPBAR     -----------------------------------------------------
      appBar: AppBar(
        title: TitleText(title: BudgetDetailScreen._screenName),
        //          ACTIONS     ------------------------------------------------
        actions: [
          //              CATEGORIES DROPDOWN    --------------------------------
          DropdownButton<String>(
            value: "Categories",
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              if (value == "Set Budget Categories") {
                Navigator.pushNamed(context, AddCategory.routeName);
              }
              setState(() {
                //dropdownValue = value!;
              });
            },
            items: ["Set Budget Categories", "placeholder1", "Categories"]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          //              EDIT/CANCEL & SAVE BUTTONS   ---------------------------
          EditCancelModeButton(
            editMode: _editMode,
            onPressedCallback: _con.onEditPressed,
          ),
          if (_editMode)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _con.onSavePressed,
            ),
        ],
      ),
      //        BODY      ------------------------------------------------------
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: _selected == null
                  ? OhNoesErrorText(
                      message:
                          'There has been a mistake. Selected Budget is null')
                  : Column(
                      children: [
                        _editMode
                            ? BudgetTitleTextField(onSaved: _con.save)
                            : BudgetDetailField(
                                titleText: "Title",
                                fieldText: _selected!.title),
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
      ),
    );
  }
}

class _Controller {
  final _BudgetDetailState _state;
  _Controller(this._state);

  // button events
  //---------------------------------------------------------------------------
  void onUseButtonPressed() {
    Provider.of<BudgetData>(_state.context, listen: false)
        .setCurrentBudget(_state._selected!);
  }

  void onSavePressed() {
    showToast("You keep on knockin but you can't come in");
  }

  void save(String? value) {
    showToast("not implemented yet");
  }

  void onEditPressed() {
    _state.render(() {
      _state._editMode = !_state._editMode;
    });
  }
}
