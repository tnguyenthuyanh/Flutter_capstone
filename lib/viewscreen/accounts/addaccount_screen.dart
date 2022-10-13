import 'package:cap_project/controller/auth_controller.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
// import '../View_Model/budget_data.dart';
// import '../View_Model/validator.dart';
// import '../model/budget.dart';
// import 'components/buttons/savebutton.dart';
// import 'components/sizedboxes/fullwidth_sizedbox.dart';
// import 'components/textfields/budgettitle_textfield.dart';
// import 'components/texts/titletext.dart';

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
  // final String _useBudgetText =
  //     "We'll use this template to create your monthly budgets";
  final String _currentSwitchLabel = "Set as default";

  // state vars
  late _Controller _con;
  String? _title;
  bool _current = false;
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // _con = _Controller(this);
  }

  void render(fn) {
    setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    // _current = Provider.of<BudgetData>(context).numberOfBudgets == 0;
    return Text("Page loaded");
    // return Scaffold(
    //   //        APPBAR      ----------------------------------------------------
    //   appBar: AppBar(
    //     title: TitleText(title: _screenTitle),
    //   ),
    //   //        BODY      ------------------------------------------------------
    //   body: Consumer<BudgetData>(builder: (context, budgets, child) {
    //     return Padding(
    //       padding: const EdgeInsets.all(20.0),
    //       child: SingleChildScrollView(
    //         child: Form(
    //           key: _formKey,
    //           child: Column(
    //             children: [
    //               //        BUDGET TITLE      ----------------------------------
    //               FullWidthSizedBox(
    //                 child: BudgetTitleTextField(
    //                   onSaved: _con.onSaveTitle,
    //                 ),
    //               ),
    //               //        IS CURRENT      ------------------------------------
    //               // if this is the first budget added for the user, it should
    //               // be set to current
    //               budgets.numberOfBudgets == 0
    //                   ? Padding(
    //                       padding: const EdgeInsets.all(10.0),
    //                       child: Text(
    //                         _useBudgetText,
    //                         textAlign: TextAlign.center,
    //                       ),
    //                     )
    //                   : FullWidthSizedBox(
    //                       child: Row(
    //                         children: [
    //                           Text(_currentSwitchLabel),
    //                           Switch(
    //                             value: _current,
    //                             onChanged: _con.onCurrentChanged,
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //               //        SAVE BUTTON     ------------------------------------
    //               SaveButton(
    //                 onPressedCallback: _con.save,
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     );
    //   }),
    // );
  }
}

class _Controller {
  // _AddBudgetScreenState _state;
  // _Controller(this._state);

  // void save() {
  //   FormState? currentState = _state._formKey.currentState;
  //   // return if not validated
  //   if (currentState == null || !currentState.validate()) return;
  //   currentState.save();

  //   // check the current user id. If null or empty, slap some toast on the screen
  //   // and return
  //   String? uid = getCurrentUserID();
  //   if (uid == null || uid.isEmpty) {
  //     showToast("I'm sorry, but I've made a mistake. Your Id is borked");
  //     return;
  //   }

  //   // if uid is ok, save the budget, slap some good toast on the screen
  //   // and navigate to the budgets list
  //   Provider.of<BudgetData>(_state.context, listen: false).add(
  //     Budget(
  //       title: _state._title!,
  //       ownerUID: uid,
  //       isCurrent: _state._current,
  //     ),
  //   );

  //   showToast("Budget created!");

  //   Navigator.pop(_state.context);
  // }

  // void onCurrentChanged(bool? value) {
  //   _state.render(() => _state._current = !_state._current);
  // }

  // // save functions
  // void onSaveTitle(String? value) {
  //   _state.render(() {
  //     _state._title = value;
  //   });
  // }

  // String? getCurrentUserID() {
  //   // get information from user manager
  //   return AuthController.currentUser?.uid;
  // }
}
