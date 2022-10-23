import 'package:cap_project/model/wallet.dart';
import 'package:cap_project/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import '../controller/firestore_controller.dart';
import '../model/constant.dart';
import 'addCard_screen.dart';

class AddBalanceScreen extends StatefulWidget {
  static const routeName = '/addBalanceScreen';
  final User user;
  final Wallet wallet;

  AddBalanceScreen({required this.user, required this.wallet});

  @override
  State<StatefulWidget> createState() {
    return _AddBalanceState();
  }
}

class _AddBalanceState extends State<AddBalanceScreen> {
  late _Controller con;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
        title: Text('Add Balance'),
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            widget.wallet.card_saved == 1
                ? CreditCardWidget(
                    cardNumber: widget.wallet.card_number,
                    expiryDate: widget.wallet.exp,
                    cardHolderName: widget.wallet.holder_name,
                    cvvCode: '***',
                    bankName: 'Virtual Bank',
                    showBackView: false,
                    obscureCardCvv: true,
                    isHolderNameVisible: true,
                    cardBgColor: Color.fromARGB(255, 7, 71, 123),
                    isSwipeGestureEnabled: true,
                    onCreditCardWidgetChange:
                        (CreditCardBrand creditCardBrand) {},
                  )
                : Align(
                    alignment: Alignment.center,
                    child: Text('No card is added')),
            widget.wallet.card_saved == 1
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    enabled: false,
                                    initialValue:
                                        '\$' + widget.wallet.balance.toString(),
                                    decoration: InputDecoration(
                                      labelText: "Wallet Balance",
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: TextFormField(
                                      maxLength: 6,
                                      validator: con.validateCredit,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9\.]')),
                                      ],
                                      onSaved: con.saveCredit,
                                      decoration: const InputDecoration(
                                        hintText: "\$",
                                        labelText: "Add Credit",
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      backgroundColor:
                                          Color.fromARGB(255, 74, 125, 193),
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.all(12),
                                      child: const Text('Add'),
                                    ),
                                    onPressed: con.add,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: Color.fromARGB(255, 74, 125, 193),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      child: const Text('Add a card'),
                    ),
                    onPressed: con.addCardScreen,
                  ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  late _AddBalanceState state;
  late double? credit;
  late Wallet wallet;

  _Controller(this.state);

  String? validateCredit(String? value) {
    if (value == null ||
        value.isEmpty ||
        '.'.allMatches(value).length > 1 ||
        double.tryParse(value) == null ||
        double.parse(value) <= 0) {
      return 'Please enter value greater than 0';
    } else if (value != null && value.indexOf('.') != -1) {
      int n = value.indexOf('.');
      if (value.length - 1 - n > 2) {
        return 'Please enter value in correct format ###.##';
      }
    }
    return null;
  }

  void saveCredit(String? value) {
    if (value != null) credit = double.parse(value);
  }

  void add() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    startCircularProgress(state.context);

    try {
      await FirestoreController.addCredit(
          state.widget.user.uid, credit!, state.widget.wallet.docId!);
      stopCircularProgress(state.context);
      Navigator.of(state.context).pop();
    } catch (e) {
      stopCircularProgress(state.context);
      if (Constant.devMode) print('====== error: $e');
      showSnackBar(
        context: state.context,
        message: 'error: $e',
      );
    }
  }

  void addCardScreen() async {
    try {
      await Navigator.pushNamed(state.context, AddCardScreen.routeName,
          arguments: {
            ArgKey.user: state.widget.user,
          });
      Navigator.of(state.context).pop();
      Navigator.of(state.context).pop();
    } catch (e) {
      if (Constant.devMode) print('====== AddCardScreen error: $e');
      showSnackBar(
        context: state.context,
        message: 'Failed to get AddCardScreen: $e',
      );
    }
  }
}
