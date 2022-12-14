// ignore_for_file: file_names

import 'package:cap_project/controller/firestore_controller.dart';
import 'package:cap_project/model/catergories.dart';
import 'package:cap_project/model/purchase.dart';
import 'package:cap_project/model/subcategories.dart';
import 'package:cap_project/model/user.dart';
import 'package:cap_project/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../View_Model/purchases_viewModal.dart';
import '../model/constant.dart';

class AddPurchaseScreen extends StatefulWidget {
  const AddPurchaseScreen(
      {required this.userP,
      required this.user,
      required this.purchaseList,
      required this.transType,
      required this.selected,
      Key? key})
      : super(key: key);

  final List<Purchase> purchaseList;
  final User user;
  final UserProfile userP;
  final String transType;
  final int selected;
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
  String? dropValue;
  late String transType;
  late PurchaseViewModal purchaseViewModel;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    email = widget.user.email ?? 'No email';
    transType = widget.transType;

    Future.delayed(Duration.zero, () async {
      purchaseViewModel =
          Provider.of<PurchaseViewModal>(context, listen: false);
      purchaseViewModel.amountController.clear();
      purchaseViewModel.noteController.clear();
      await purchaseViewModel.getCategories();

      if (widget.selected != -1) {
        dynamic transaction = widget.purchaseList[widget.selected];
        purchaseViewModel.amountController.text = transaction.amount;
        purchaseViewModel.noteController.text = transaction.note;
        if (purchaseViewModel.categoriess.contains(transaction.category)) {
          purchaseViewModel.selectedCategories = Category(
              type: "",
              label: transaction.category,
              categoryid: transaction.docId);
        } else if (transaction.category.isNotEmpty) {
          purchaseViewModel.selectedCategories = Category(
              type: "",
              label: transaction.category,
              categoryid: transaction.docId);
          purchaseViewModel.categoriess
              .add(purchaseViewModel.selectedCategories);
        }
        await purchaseViewModel.getSubCategories();

        if (purchaseViewModel.subcategoriess
            .contains(transaction.subCategory)) {
          purchaseViewModel.selectedsubCategories =
              purchaseViewModel.subcategoriess.firstWhere(
                  (element) => element.label == transaction.subCategory);
          // SubCategory(
          //     subcategoryid: "",
          //     label: transaction.subCategory,
          //     categoryid: "");
        } else if (transaction.subCategory.isNotEmpty) {
          purchaseViewModel.selectedsubCategories = SubCategory(
              subcategoryid: "",
              label: transaction.subCategory,
              categoryid: "");
          purchaseViewModel.subcategoriess
              .add(purchaseViewModel.selectedsubCategories);
        }
      }
    });
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
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
                    controller: purchaseViewModel.amountController,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(hintText: 'Note'),
                    autocorrect: false,
                    onSaved: con.saveNote,
                    controller: purchaseViewModel.noteController,
                  ),
                  Row(
                    children: [
                      const Text('Main Categories:'),
                      const SizedBox(
                        width: 15.0,
                      ),
                      purchaseViewModel.load == false
                          ? DropdownButton(
                              items: purchaseViewModel.categoriess
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.label),
                                      ))
                                  .toList(),
                              value: purchaseViewModel.selectedCategories,
                              onChanged: (value) {
                                purchaseViewModel.onChangedDropDownFn(value);
                              })
                          : const CircularProgressIndicator(),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Sub Categories:'),
                      const SizedBox(
                        width: 15.0,
                      ),
                      purchaseViewModel.subcatLoad == false
                          ? purchaseViewModel.subcategoriess.length <= 1
                              ? const Text('No subcategories exists')
                              : DropdownButton(
                                  items: purchaseViewModel.subcategoriess
                                      .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e.label),
                                          ))
                                      .toList(),
                                  value:
                                      purchaseViewModel.selectedsubCategories,
                                  onChanged: (value) {
                                    purchaseViewModel
                                        .onChangedSubCatDropDownFn(value);
                                  })
                          : const CircularProgressIndicator(),
                    ],
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
      tempPurchase.category = state.purchaseViewModel.selectedCategories.label;

      if (state.purchaseViewModel.selectedsubCategories !=
          state.purchaseViewModel.subcategoriess.first) {
        tempPurchase.subCategory =
            state.purchaseViewModel.selectedsubCategories.label;
      }
      if (state.widget.selected == -1) {
        String docId = await FirestoreController.addPurchase(
          user: state.widget.userP,
          purchase: tempPurchase,
        );
        tempPurchase.docId = docId;
        state.widget.userP.purchases.insert(0, tempPurchase);
      } else {
        tempPurchase.docId =
            state.widget.purchaseList[state.widget.selected].docId;
        String docId = await FirestoreController.updatePurchase(
          user: state.widget.userP,
          purchase: tempPurchase,
        );
        tempPurchase.docId = docId;
        state.widget.userP.purchases.removeAt(state.widget.selected);
        state.widget.userP.purchases
            .insert(state.widget.selected, tempPurchase);
      }

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
      // ignore: avoid_print
      if (Constant.devMode) print('***************** uploadFile/Doc error: $e');
      showSnackBar(
          context: state.context,
          seconds: 20,
          message: 'UploadFile/Doc Error: $e');
    }
  }
}
