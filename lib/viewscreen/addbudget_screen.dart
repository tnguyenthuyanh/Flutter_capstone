import 'package:cap_project/controller/auth_controller.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../View_Model/budget_data.dart';
import '../View_Model/validator.dart';
import '../model/budget.dart';

class AddBudgetScreen extends StatefulWidget {
  static const routeName = '/addBudgetScreen';

  const AddBudgetScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {
  // UI String values
  final String _screenTitle = 'Add Budget';
  final String _titleFieldHint = 'Title';

  // state vars
  late _Controller _con;
  String? _title;
  bool _current = false;

  @override
  void initState() {
    super.initState();
    _con = _Controller(this);
  }

  void render(fn) {
    setState(fn);
  }

  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screenTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // title field
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    decoration: InputDecoration(hintText: _titleFieldHint),
                    validator: Validator.validateBudgetTitle,
                    onSaved: _con.onSaveTitle,
                  ),
                ),
                // is current switch
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Text("Use this budget"),
                      Switch(
                        value: _current,
                        onChanged: _con.onCurrentChanged,
                      ),
                    ],
                  ),
                ),
                // save button
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _con.save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _AddBudgetScreenState _state;
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

    // if uid is ok, save the budget, slap some good toast on the screen
    // and navigate to the budgets list
    Provider.of<BudgetData>(_state.context, listen: false).add(
      Budget(
        title: _state._title!,
        ownerUID: uid,
        isCurrent: _state._current,
      ),
    );

    showToast("Budget created!");

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
