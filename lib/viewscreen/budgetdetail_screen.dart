import 'package:cap_project/viewscreen/components/debug/debugprinter.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import '../model/budget.dart';
import '../View_Model/budget_data.dart';
import 'package:cap_project/viewscreen/budgetCategory.dart';
import 'package:cap_project/viewscreen/components/texts/ohnoeserrortext.dart';
import 'components/budgetdetailfield.dart';
import 'components/buttons/modebuttons/editcancelmode_button.dart';
import 'components/buttons/mysizedbutton.dart';
import 'components/textfields/budgettitle_textfield.dart';
import 'components/texts/titletext.dart';

class BudgetDetailScreen extends StatefulWidget {
  static const routeName = '/budgetDetailScreen';
  static const _screenName = "Budget Detail";

  const BudgetDetailScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BudgetDetailState();
}

class _BudgetDetailState extends State<BudgetDetailScreen> {
  DebugPrinter printer =
      DebugPrinter(className: "BudgetDetailState", printOff: true);

  late _Controller _con;

  // state vars
  Budget? _selected;
  Budget? _current;
  bool _editMode = false;
  String? newTitle;

  final _formKey = GlobalKey<FormState>();

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
              icon: const Icon(Icons.check),
              onPressed: _con.save,
            ),
        ],
      ),
      //        BODY      ------------------------------------------------------
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: _selected == null
                  ? OhNoesErrorText(
                      message:
                          'There has been a mistake. Selected Budget is null')
                  : Column(
                      children: [
                        _editMode
                            ? BudgetTitleTextField(onSaved: _con.onSaveTitle)
                            : BudgetDetailField(
                                titleText: "Title",
                                fieldText: _selected!.title),
                        MySizedButton(
                          buttonText: "Use",
                          onPressedCallback: _selected! == _current
                              ? null
                              : _con.onUseButtonPressed,
                        ),
                        // ListViewHeaderText(listViewTitle: "Categories"),
                        // ListView.builder(
                        //   itemCount: 12,
                        //   itemBuilder: (BuildContext context, int index) {
                        //     return ListTile(
                        //       leading: Text("yay"),
                        //     );
                        //   },
                        // ),
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
  DebugPrinter printer =
      DebugPrinter(className: "BudgetDetailScreen Controller");

  final _BudgetDetailState _state;
  _Controller(this._state);

  // button events
  //---------------------------------------------------------------------------
  void onUseButtonPressed() {
    Provider.of<BudgetData>(_state.context, listen: false)
        .setCurrentBudget(_state._selected!);
  }

  void save() {
    printer.setMethodName(methodName: "save");
    printer.debugPrint("saving budget");

    FormState? currentState = _state._formKey.currentState;
    if (!isFormStateValid()) {
      printer.debugPrint("FormState not validated or null");
      return;
    }
    printer.debugPrint("FormState valid: continuing");
    currentState!.save();

    // save the budget, slap some good toast, and navigate to budgets list
    Provider.of<BudgetData>(_state.context, listen: false)
        .updateSelectedBudget(_state.newTitle!);

    showToast("Budget Updated");

    onEditPressed();
  }

  bool isFormStateValid() {
    FormState? currentState = _state._formKey.currentState;
    return !(currentState == null || !currentState.validate());
  }

  void onEditPressed() {
    _state.render(() {
      _state._editMode = !_state._editMode;
    });
  }

  void onSaveTitle(String? value) {
    _state.render(() {
      _state.newTitle = value;
    });
  }
}
