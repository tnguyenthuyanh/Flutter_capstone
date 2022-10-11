import 'package:cap_project/controller/firestore_controller.dart';
import 'package:cap_project/model/constant.dart';
import 'package:cap_project/model/savings.dart';
import 'package:cap_project/model/user.dart';
import 'package:cap_project/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddSavingsScreen extends StatefulWidget {
  const AddSavingsScreen(
      {required this.userP,
      required this.user,
      required this.savings,
      Key? key})
      : super(key: key);

  final List<Savings> savings;
  final User user;
  final UserProfile userP;

  static const routeName = '/addSavingsScreen';

  @override
  State<StatefulWidget> createState() {
    return _AddSavingsState();
  }
}

class _AddSavingsState extends State<AddSavingsScreen> {
  late _Controller con;
  late String email;
  var formKey = GlobalKey<FormState>();
  String? dropValue = null;

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
        title: const Text('Edit Savings Amount'),
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
                decoration: const InputDecoration(hintText: 'Amount'),
                autocorrect: false,
                onSaved: con.saveAmount,
              ),
            ],
          ),
        )),
      ),
    );
  }
}

class _Controller {
  _AddSavingsState state;
  late List<Savings> savings;
  Savings tempSavings = Savings();

  _Controller(this.state) {
    savings = state.widget.savings;
  }

  void saveAmount(String? value) {
    if (value != null) {
      tempSavings.amount = value;
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
      String docID = state.widget.userP.email;

      String docId = await FirestoreController.addSavings(
        user: state.widget.userP,
        savings: tempSavings,
      );
      tempSavings.docId = docId;

      state.widget.userP.savings.insert(0, tempSavings);

      stopCircularProgress(state.context);
      Navigator.of(state.context).pop();
      Navigator.of(state.context).pop();
      //return to home
      // await Navigator.pushNamed(
      //   state.context,
      //   PurchasesScreen.routeName,
      //   arguments: {
      //     ArgKey.purchaseList: purchaseList,
      //     ArgKey.user: state.widget.user,
      //     ArgKey.userProfile: state.widget.userP,
      //   },
      // );
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
