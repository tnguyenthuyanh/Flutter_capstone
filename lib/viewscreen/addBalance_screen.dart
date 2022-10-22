import 'package:cap_project/model/wallet.dart';
import 'package:cap_project/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import '../controller/firestore_controller.dart';
import '../model/constant.dart';

class AddBalanceScreen extends StatefulWidget {
  static const routeName = '/addBalanceScreen';
  final User user;

  AddBalanceScreen({required this.user});

  @override
  State<StatefulWidget> createState() {
    return _AddBalanceState();
  }
}

class _AddBalanceState extends State<AddBalanceScreen> {
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
            isCreditCardSaved
                ? CreditCardWidget(
                    cardNumber: '124214124',
                    expiryDate: 'ee',
                    cardHolderName: 'cardHolderName',
                    cvvCode: '***',
                    bankName: 'Virtual Bank',
                    showBackView: false,
                    obscureCardNumber: true,
                    obscureCardCvv: true,
                    isHolderNameVisible: true,
                    cardBgColor: Color.fromARGB(255, 7, 71, 123),
                    isSwipeGestureEnabled: true,
                    onCreditCardWidgetChange:
                        (CreditCardBrand creditCardBrand) {},
                  )
                : SizedBox(),
            isCreditCardSaved
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
                                    initialValue: "\$5000",
                                    decoration: InputDecoration(
                                      labelText: "Wallet Balance",
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: TextFormField(
                                      maxLength: 8,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
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
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  late _AddBalanceState state;
  late int? credit;

  _Controller(this.state) {}

  void saveCredit(String? value) {
    if (value != null) credit = int.parse(value);
  }

  void add() {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();
    print(credit);
    // startCircularProgress(state.context);
    // try {
    //   String exp = month! + '/' + year!;
    //   Wallet wallet = new Wallet(
    //       exp: exp,
    //       holder_name: holderName!,
    //       card_number: cardNumber!,
    //       cvv: cvv!,
    //       card_saved: 1);
    //   await FirestoreController.saveWallet(wallet);
    //   stopCircularProgress(state.context);
    //   Navigator.of(state.context).pop();
    // } catch (e) {
    //   stopCircularProgress(state.context);
    //   if (Constant.devMode) print('====== error: $e');
    //   showSnackBar(
    //     context: state.context,
    //     message: 'error: $e',
    //   );
    // }
  }
}
