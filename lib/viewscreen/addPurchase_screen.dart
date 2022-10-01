import 'package:cap_project/controller/firestore_controller.dart';
import 'package:cap_project/model/purchase.dart';
import 'package:cap_project/model/user.dart';
import 'package:cap_project/viewscreen/purchases_screen.dart';
import 'package:cap_project/viewscreen/userhome_screen.dart';
import 'package:cap_project/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/constant.dart';

class AddPurchaseScreen extends StatefulWidget {
  const AddPurchaseScreen(
      {required this.userP,
      required this.user,
      required this.purchaseList,
      Key? key})
      : super(key: key);

  final List<Purchase> purchaseList;
  final User user;
  final UserProfile userP;

  static const routeName = '/addPurchaseScreen';

  @override
  State<StatefulWidget> createState() {
    return _AddPurchaseState();
  }
}

class _AddPurchaseState extends State<AddPurchaseScreen> {
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
        title: const Text('Add A Purchase'),
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
              TextFormField(
                decoration: const InputDecoration(hintText: 'Note'),
                autocorrect: false,
                onSaved: con.saveNote,
              ),
            ],
          ),
        )),
      ),
    );
  }
}

class _Controller {
  _AddPurchaseState state;
  late List<Purchase> purchaseList;
  Purchase tempPurchase = Purchase();

  _Controller(this.state) {
    purchaseList = state.widget.purchaseList;
  }

  void saveAmount(String? value) {
    if (value != null) {
      tempPurchase.amount = value;
      tempPurchase.createdBy = state.email;
    }
  }

  void saveNote(String? value) {
    if (value != null) {
      tempPurchase.note = value;
      tempPurchase.createdBy = state.email;
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
      String docId = await FirestoreController.addPurchase(
        user: state.widget.userP,
        purchase: tempPurchase,
      );
      tempPurchase.docId = docId;

      state.widget.userP.debts.insert(0, tempPurchase);

      stopCircularProgress(state.context);

      // return to home
      await Navigator.pushNamed(
        state.context,
        UserHomeScreen.routeName,
        arguments: {
          //ArgKey.purchaseList: purchaseList,
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
