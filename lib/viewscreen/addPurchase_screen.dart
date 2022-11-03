import 'package:cap_project/controller/firestore_controller.dart';
import 'package:cap_project/model/purchase.dart';
import 'package:cap_project/model/user.dart';
import 'package:cap_project/viewscreen/purchases_screen.dart';
import 'package:cap_project/viewscreen/userhome_screen.dart';
import 'package:cap_project/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:provider/provider.dart';
import '../View_Model/purchases_viewModal.dart';
import '../model/constant.dart';

class AddPurchaseScreen extends StatefulWidget {
  const AddPurchaseScreen(
      {required this.userP,
      required this.user,
      required this.purchaseList,
      required this.transType,
      Key? key})
      : super(key: key);

  final List<Purchase> purchaseList;
  final User user;
  final UserProfile userP;
  final String transType;
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
  late String transType;
  late PurchaseViewModal purchaseViewModel;


  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    email = widget.user.email ?? 'No email';
    transType = widget.transType;
  
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    purchaseViewModel = Provider.of<PurchaseViewModal>(context);
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
                validator: purchaseViewModel.validateAmount,
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: 'Note'),
                autocorrect: false,
                onSaved: con.saveNote,
              ),
              DropdownButton(items: purchaseViewModel.categories.map((e) => DropdownMenuItem(value: e,child: Text(e),)).toList(), onChanged: (value){})
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
      tempPurchase.transactionType = state.transType;
      String docId = await FirestoreController.addPurchase(
        user: state.widget.userP,
        purchase: tempPurchase,
      );
      tempPurchase.docId = docId;

      state.widget.userP.purchases.insert(0, tempPurchase);

      stopCircularProgress(state.context);
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
