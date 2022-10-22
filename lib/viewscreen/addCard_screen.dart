import 'package:cap_project/model/wallet.dart';
import 'package:cap_project/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import '../controller/firestore_controller.dart';
import '../model/constant.dart';

class AddCardScreen extends StatefulWidget {
  static const routeName = '/addCardScreen';
  final User user;

  AddCardScreen({required this.user});

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
        title: Text('Add money'),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              isCreditCardSaved
                  ? CreditCardWidget(
                      cardNumber: '124214124',
                      expiryDate: 'ee',
                      cardHolderName: 'cardHolderName',
                      cvvCode: 'cvvCode',
                      bankName: 'Axis Bank',
                      showBackView: false,
                      obscureCardNumber: true,
                      obscureCardCvv: true,
                      isHolderNameVisible: true,
                      //cardBgColor: Colors.red,
                      isSwipeGestureEnabled: true,
                      onCreditCardWidgetChange:
                          (CreditCardBrand creditCardBrand) {},
                      customCardTypeIcons: <CustomCardTypeIcon>[
                        CustomCardTypeIcon(
                          cardType: CardType.americanExpress,
                          cardImage: Image.asset(
                            'assets/mastercard.png',
                            height: 40,
                            width: 40,
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),
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
                              maxLength: 12,
                              validator: con.validateCardNumber,
                              onSaved: con.saveCardNumber,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
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
                                      RegExp(r'[a-zA-Z]')),
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
                                SizedBox(width: 16),
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
                                SizedBox(width: 10),
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
                                backgroundColor:
                                    Color.fromARGB(255, 74, 125, 193),
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

  _Controller(this.state) {}

  void update() async {}

  String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter 12-digit card number';
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
      Wallet wallet = new Wallet(
          exp: exp,
          holder_name: holderName!,
          card_number: cardNumber!,
          cvv: cvv!,
          card_saved: 1);
      await FirestoreController.saveWallet(wallet);
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
}
