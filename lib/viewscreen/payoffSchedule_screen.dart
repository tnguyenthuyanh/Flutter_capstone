import 'dart:math';

import 'package:cap_project/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/debt.dart';

class PayoffScreen extends StatefulWidget {
  const PayoffScreen({required this.debt, required this.user, Key? key})
      : super(key: key);

  final Debt debt;
  final User user;

  static const routeName = '/payOffScreen';

  @override
  State<StatefulWidget> createState() {
    return _PayoffState();
  }
}

class _PayoffState extends State<PayoffScreen> {
  late _Controller con;
  late String email;
  var formKey = GlobalKey<FormState>();
  bool showSchedule = false;

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
        title: Text(widget.debt.title + ' Pay off schedule'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                enabled: false,
                style: Theme.of(context).textTheme.bodyText1,
                initialValue: 'Balance: \$' + widget.debt.balance,
              ),
              TextFormField(
                enabled: false,
                style: Theme.of(context).textTheme.bodyText1,
                initialValue: 'Interest Rate: \$' + widget.debt.interest,
              ),
              TextFormField(
                enabled: false,
                style: Theme.of(context).textTheme.bodyText1,
                initialValue: 'Minimum payment: \$' + con.setMinPayment(),
              ),
              !showSchedule
                  ? Column(
                      children: [
                        TextFormField(
                          style: Theme.of(context).textTheme.bodyText1,
                          decoration: const InputDecoration(
                              hintText: 'Enter payment amount'),
                          keyboardType: TextInputType.number,
                          validator: Debt.validatePayment,
                          onSaved: con.savePayment,
                        ),
                        ElevatedButton(
                          onPressed: con.generateSchedule,
                          child: const Text('Submit'),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        TextFormField(
                          enabled: false,
                          style: Theme.of(context).textTheme.bodyText1,
                          initialValue: 'Months to pay off: ' +
                              con.payments.toStringAsFixed(0),
                        ),
                        TextFormField(
                          enabled: false,
                          style: Theme.of(context).textTheme.bodyText1,
                          initialValue: 'Total interest paid: \$' +
                              con.interestPaid.toStringAsFixed(0),
                        ),
                        TextFormField(
                          style: Theme.of(context).textTheme.bodyText1,
                          decoration: const InputDecoration(
                              hintText: 'Enter payment amount'),
                          keyboardType: TextInputType.number,
                          validator: Debt.validatePayment,
                          onSaved: con.savePayment,
                        ),
                        ElevatedButton(
                            onPressed: con.generateSchedule,
                            child: const Text('Submit'))
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _PayoffState state;
  late Debt tempDebt;
  late double payments;
  late double interestPaid;
  late double paymentAmount;
  late double minPayment;
  late String payAmt;

  _Controller(this.state) {
    tempDebt = Debt.clone(state.widget.debt);
    payments = 0;
    interestPaid = 0.0;
    paymentAmount = 0.0;
    minPayment = 0.0;
    payAmt = '';
  }

  void savePayment(String? value) {
    if (value != null) {
      tempDebt.payment = value;
    }
  }

  String setMinPayment() {
    if (tempDebt.category == 'Credit Card') {
      minPayment = double.parse(tempDebt.balance) * .0255;
      String minPay = minPayment.toStringAsFixed(2);
      return minPay;
    } else {
      double balance = double.parse(state.widget.debt.balance);
      double intrest = double.parse(state.widget.debt.interest) / 100;
      minPayment = balance *
          intrest /
          12 *
          (pow((1 + intrest / 12), (30 * 12))) /
          (pow((1 + intrest / 12), (30 * 12)) - 1);
      String minPay = minPayment.toStringAsFixed(2);
      return minPay;
    }
  }

  void generateSchedule() {
    paymentAmount = double.parse(tempDebt.payment);
    if (paymentAmount < minPayment) {
      showSnackBar(
        context: state.context,
        seconds: 10,
        message: 'Payment amount is too small \n payment  = ' +
            paymentAmount.toStringAsFixed(2) +
            '\n minimum = ' +
            minPayment.toStringAsFixed(2),
      );
      return;
    } else {
      double balance = double.parse(state.widget.debt.balance);
      double intrest = double.parse(state.widget.debt.interest) / 100;
      payments = ((log(paymentAmount / intrest)) /
          (paymentAmount / intrest + balance) /
          log(1 + intrest));
      interestPaid = payments * paymentAmount - balance;
      state.showSchedule = true;
      state.render(() {});
    }
  }
  /*double balance = double.parse(state.widget.debt.balance);
    double intrest = double.parse(state.widget.debt.interest) / 100;
    double minPayment = balance * intrest / 12.0;
    String minPay = minPayment.toStringAsFixed(2);
  }*/
}
