import 'package:cap_project/controller/auth_controller.dart';
import 'package:cap_project/viewscreen/components/debug/debugprinter.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../View_Model/account_data.dart';
import '../../model/account.dart';
import '../components/buttons/savebutton.dart';
import '../components/sizedboxes/fullwidth_sizedbox.dart';
import '../components/textfields/accouttitle_textfield.dart';
import '../components/texts/titletext.dart';

class AddAccountScreen extends StatefulWidget {
  static const routeName = '/addAccountScreen';

  const AddAccountScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  // UI String values
  final String _screenTitle = 'Add Account';
  final String _titleFieldHint = 'Title';
  final String _defaultText = "Using as the default account for transactions";
  final String _currentSwitchLabel = "Set as default";

  // state vars
  late _Controller _con;
  String? _title;
  bool _current = false;
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
    _current = Provider.of<AccountData>(context).number == 0;

    return Scaffold(
      //        APPBAR      ----------------------------------------------------
      appBar: AppBar(
        title: TitleText(title: _screenTitle),
      ),
      //        BODY      ------------------------------------------------------
      body: Consumer<AccountData>(builder: (context, accounts, child) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  //        ACCOUNT TITLE      ----------------------------------
                  FullWidthSizedBox(
                    child: AccountTitleTextField(
                      onSaved: _con.onSaveTitle,
                    ),
                  ),
                  //        IS CURRENT      ------------------------------------
                  // if this is the first account added for the user, it should
                  // be set to current
                  accounts.number == 0
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            _defaultText,
                            textAlign: TextAlign.center,
                          ),
                        )
                      : FullWidthSizedBox(
                          child: Row(
                            children: [
                              Text(_currentSwitchLabel),
                              Switch(
                                value: _current,
                                onChanged: _con.onCurrentChanged,
                              ),
                            ],
                          ),
                        ),
                  //        SAVE BUTTON     ------------------------------------
                  SaveButton(
                    onPressedCallback: _con.save,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _Controller {
  _AddAccountScreenState _state;
  _Controller(this._state);

  void save() {
    FormState? currentState = _state._formKey.currentState;
    // return if not validated
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    // check the current user id. If null or empty, slap some toast on the screen
    // and return
    String? uid = getCurrentUserID();
    if (uid == null || uid.isEmpty) {
      showToast("I'm sorry, but I've made a mistake. Your Id is borked");
      return;
    }

    // if uid is ok, save, slap some good toast on the screen
    // and navigate to the accounts list
    Provider.of<AccountData>(_state.context, listen: false).add(
      Account(
        title: _state._title!,
        ownerUid: uid,
        isCurrent: _state._current,
      ),
    );

    showToast("Account created!");

    Navigator.pop(_state.context);
  }

  void onCurrentChanged(bool? value) {
    _state.render(() => _state._current = !_state._current);
  }

  // save functions
  void onSaveTitle(String? value) {
    _state.render(() {
      _state._title = value;
    });
  }

  String? getCurrentUserID() {
    // get information from user manager
    return AuthController.currentUser?.uid;
  }
}
