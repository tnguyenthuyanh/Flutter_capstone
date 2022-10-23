import 'dart:collection';
import 'package:cap_project/model/account.dart';
import 'package:cap_project/viewscreen/components/debug/debugprinter.dart';
import 'package:cap_project/viewscreen/components/texts/listviewheadertext.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:cap_project/viewscreen/budgetCategory.dart';
import 'package:cap_project/viewscreen/components/texts/ohnoeserrortext.dart';
import '../../View_Model/account_data.dart';
import '../components/buttons/modebuttons/editcancelmode_button.dart';
import '../components/buttons/mysizedbutton.dart';
import '../components/textfields/account_textfields.dart';
import '../components/texts/detail_text.dart';
import '../components/texts/titletext.dart';

// TODO: add copy to functionality
class AccountDetailScreen extends StatefulWidget {
  static const routeName = '/accountDetailScreen';
  static const _screenName = "Account Detail";

  const AccountDetailScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccountDetailState();
}

class _AccountDetailState extends State<AccountDetailScreen> {
  DebugPrinter printer = DebugPrinter(className: "BudgetDetailState");

  late _Controller _con;

  // state vars
  Account? _selected;
  Account? _current;
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
    _selected = Provider.of<AccountData>(context).selected;
    _current = Provider.of<AccountData>(context).current;

    return Scaffold(
      appBar: AppBar(
        title: TitleText(title: AccountDetailScreen._screenName),
        //          ACTIONS     ------------------------------------------------
        actions: [
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
                          'There has been a mistake. Selected Account is null')
                  : Column(
                      children: [
                        _editMode
                            ? AccountTextFields.titleTextField(
                                onSaved: _con.onSaveTitle)
                            : DetailField(
                                labelText: "Title", text: _selected!.title),
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
  DebugPrinter printer =
      DebugPrinter(className: "AccountDetailScreen Controller");

  final _AccountDetailState _state;
  _Controller(this._state);

  // button events
  //---------------------------------------------------------------------------
  void onUseButtonPressed() {
    Provider.of<AccountData>(_state.context, listen: false)
        .setCurrent(_state._selected!);
  }

  void save() {
    printer.setMethodName(methodName: "save");
    printer.debugPrint("saving account");

    FormState? currentState = _state._formKey.currentState;
    if (!isFormStateValid()) {
      printer.debugPrint("FormState not validated or null");
      return;
    }
    printer.debugPrint("FormState valid: continuing");
    currentState!.save();

    // save the budget, slap some good toast, and navigate to budgets list
    Provider.of<AccountData>(_state.context, listen: false)
        .updateSelected(_state.newTitle!);

    showToast("Account Updated");

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
