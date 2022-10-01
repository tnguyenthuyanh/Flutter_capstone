import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../View_Model/budget_data.dart';
import '../View_Model/validator.dart';
import '../model/budget.dart';

// TODO: add budget added toast
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
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    Provider.of<BudgetData>(_state.context, listen: false).add(
      Budget(
        title: _state._title!,
        ownerUID: getCurrentUserID(),
      ),
    );

    Navigator.pop(_state.context);
  }

  // save functions
  void onSaveTitle(String? value) {
    _state.render(() {
      _state._title = value;
    });
  }

  String getCurrentUserID() {
    // get information from user manager
    // TODO: link to user manager
    return "f657847387cjfjff";
  }
}
