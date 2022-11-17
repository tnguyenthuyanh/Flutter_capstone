// ignore_for_file: file_names

import 'package:cap_project/model/wallet.dart';
import 'package:cap_project/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controller/firestore_controller.dart';
import '../model/constant.dart';

class AddCardScreen extends StatefulWidget {
  static const routeName = '/addCardScreen';
  final User user;
  final Wallet wallet;

  // ignore: use_key_in_widget_constructors
  const AddCardScreen({required this.user, required this.wallet});

  @override
  State<StatefulWidget> createState() {
    return _AddCardState();
  }
}

class _AddCardState extends State<AddCardScreen> {
  late _Controller con;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isCreditCardSaved = true;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add money'),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            maxLength: 16,
                            validator: con.validateCardNumber,
                            onSaved: con.saveCardNumber,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: const InputDecoration(
                              hintText: "XXXX-XXXX-XXXX-XXXX",
                              labelText: "Card number",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: TextFormField(
                              maxLength: 30,
                              keyboardType: TextInputType.name,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z ]')),
                              ],
                              onSaved: con.saveHolderName,
                              decoration: const InputDecoration(
                                hintText: "Full name",
                                labelText: "Card holder name",
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  maxLength: 3,
                                  validator: con.validateCVV,
                                  onSaved: con.saveCVV,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: const InputDecoration(
                                    hintText: "XXX",
                                    labelText: "CVV",
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  maxLength: 2,
                                  validator: con.validateMonth,
                                  onSaved: con.saveMonth,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: const InputDecoration(
                                    hintText: "MM",
                                    labelText: "Month",
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  maxLength: 2,
                                  validator: con.validateYear,
                                  onSaved: con.saveYear,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: const InputDecoration(
                                    hintText: "YY",
                                    labelText: "Year",
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              // backgroundColor:
                              //     const Color.fromARGB(255, 74, 125, 193),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(12),
                              child: const Text('Save Card'),
                            ),
                            onPressed: con.saveCard,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  late _AddCardState state;
  String? cardNumber;
  String? holderName;
  String? cvv;
  String? month;
  String? year;

  _Controller(this.state);

  String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty || value.length != 16) {
      return 'Please enter 16-digit card number';
    }
    return null;
  }

  String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter 3-digit CVV';
    }
    return null;
  }

  String? validateMonth(String? value) {
    if (value == null ||
        value.isEmpty ||
        int.parse(value) < 1 ||
        int.parse(value) > 12) {
      return '';
    }
    return null;
  }

  String? validateYear(String? value) {
    if (value == null ||
        value.isEmpty ||
        value.length != 2 ||
        int.parse(value) < 22) {
      return '2-digit > 23';
    }
    return null;
  }

  void saveCardNumber(String? value) {
    if (value != null) cardNumber = value;
  }

  void saveHolderName(String? value) {
    if (value != null) holderName = value;
  }

  void saveCVV(String? value) {
    if (value != null) cvv = value;
  }

  void saveMonth(String? value) {
    if (value != null) month = value;
  }

  void saveYear(String? value) {
    if (value != null) year = value;
  }

  void saveCard() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    startCircularProgress(state.context);
    try {
      String exp = month! + '/' + year!;
      Map<String, dynamic> updateInfo = {};
      updateInfo[Wallet.CARD_NUMBER] = cardNumber;
      updateInfo[Wallet.CVV] = cvv;
      updateInfo[Wallet.EXP] = exp;
      updateInfo[Wallet.HOLDER_NAME] = holderName;
      updateInfo[Wallet.CARD_SAVED] = 1;

      await FirestoreController.saveWallet(
          state.widget.wallet.docId!, updateInfo);
      stopCircularProgress(state.context);
      Navigator.of(state.context).pop();
      //Navigator.of(state.context).pop();
    } catch (e) {
      stopCircularProgress(state.context);
      // ignore: avoid_print
      if (Constant.devMode) print('====== error: $e');
      showSnackBar(
        context: state.context,
        message: 'error: $e',
      );
    }
  }
}
