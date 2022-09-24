import 'package:cap_project/controller/firestore_controller.dart';
import 'package:cap_project/model/debt.dart';
import 'package:cap_project/model/user.dart';
import 'package:cap_project/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/constant.dart';
import 'debt_screen.dart';

class AddDebtScreen extends StatefulWidget {
  const AddDebtScreen(
      {required this.debtList,
      required this.userP,
      required this.user,
      Key? key})
      : super(key: key);

  final List<Debt> debtList;
  final User user;
  final UserProfile userP;

  static const routeName = '/addDebtScreen';

  @override
  State<StatefulWidget> createState() {
    return _AddDebtState();
  }
}

class _AddDebtState extends State<AddDebtScreen> {
  late _Controller con;
  late String email;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    email = widget.user.email ?? 'No email';
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add A Debt'),
          actions: [
            IconButton(
              onPressed: con.save,
              icon: const Icon(Icons.check),
            )
          ],
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
              child: Center(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Title'),
                  autocorrect: true,
                  validator: Debt.validateTitle,
                  onSaved: con.saveTitle,
                ),
                DropdownButton(
                  items: Constant.menuItems,
                  onChanged: con.saveCategory,
                  hint: Text('Select Category'),
                )
              ],
            ),
          )),
        ));
  }
}

class _Controller {
  _AddDebtState state;
  late List<Debt> debtList;
  Debt tempDebt = Debt();

  _Controller(this.state) {
    debtList = state.widget.debtList;
  }

  void saveTitle(String? value) {
    if (value != null) {
      tempDebt.title = value;
      tempDebt.createdBy = state.email;
    }
  }

  void saveCategory(String? value) {
    if (value != null) {
      tempDebt.category = value;
    }
  }

  void save() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) {
      return;
    }

    currentState.save();

    startCircularProgress(state.context);

    try {
      String docId = await FirestoreController.addDebt(
          user: state.widget.userP, debt: tempDebt);
      tempDebt.docId = docId;

      state.widget.userP.debts.insert(0, tempDebt);

      stopCircularProgress(state.context);

      // return to home
      await Navigator.pushNamed(
        state.context,
        DebtScreen.routeName,
        arguments: {
          //ArgKey.debtList: debtList,
          ArgKey.user: state.widget.user,
          ArgKey.userProfile: state.widget.userP,
        },
      );
    } catch (e) {
      stopCircularProgress(state.context);
      if (Constant.devMode) print('***************** uploadFile/Doc error: $e');
      showSnackBar(
          context: state.context,
          seconds: 20,
          message: 'UploadFile/Doc Error: $e');
    }
  }
}
