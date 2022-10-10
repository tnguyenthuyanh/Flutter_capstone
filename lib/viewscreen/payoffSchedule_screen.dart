import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';

import '../model/debt.dart';

class PayoffScreen extends StatefulWidget {
  const PayoffScreen({required this.debt, Key? key}) : super(key: key);

  final Debt debt;

  static const routeName = '/payOffScreen';

  @override
  State<StatefulWidget> createState() {
    return _PayoffState();
  }
}

class _PayoffState extends State<PayoffScreen> {
  late _Controller con;
  var formKey = GlobalKey<FormState>();
  bool showSchedule = false;

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
        title: Text(widget.debt.title + "Pay off schedule"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              enabled: false,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: const InputDecoration(),
              initialValue: "Balance: \$" + widget.debt.balance,
            ),
            TextFormField(
              enabled: false,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: const InputDecoration(),
              initialValue: "Interest Rate: " + widget.debt.interest + '%',
              keyboardType: TextInputType.number,
              maxLines: 1,
              validator: Debt.validateInterest,
            ),
            TextFormField(
              //enabled: false,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: const InputDecoration(),
              initialValue: "Minimum payment: " + con.minPayment(),
              keyboardType: TextInputType.number,
              maxLines: 1,
            ),
            TextFormField(
              style: Theme.of(context).textTheme.bodyText1,
              decoration: const InputDecoration(
                hintText: 'Enter payment amount',
              ),
              keyboardType: TextInputType.number,
              maxLines: 1,
              //validator: _Controller.validatePayment,
              onSaved: con.savePayment,
            ),
            ElevatedButton(
                onPressed: con.generateSchedule, child: Text('Submit'))
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _PayoffState state;
  late Debt tempDebt;

  _Controller(this.state) {
    tempDebt = Debt.clone(state.widget.debt);
    double payment = 0.0;
  }

  /*static String? validatePayment(String? value) {
    return (value == null ||
            value.trim().compareTo(minPayment().toString()) < 0)
        ? "Title too short"
        : null;
  }*/

  void savePayment(String? value) {
    if (value != null) {
      double payment = double.parse(value);
    }
  }

  String minPayment() {
    if (tempDebt.category == 'Credit Card') {
      double minPayment = double.parse(tempDebt.balance) * .0255;
      String minPay = minPayment.toStringAsFixed(2);
      return minPay;
    } else {
      double balance = double.parse(state.widget.debt.balance);
      double intrest = double.parse(state.widget.debt.interest) / 100;
      double minPayment = balance *
          intrest /
          12 *
          (pow((1 + intrest / 12), (30 * 12))) /
          (pow((1 + intrest / 12), (30 * 12)) - 1);
      String minPay = minPayment.toStringAsFixed(2);
      return minPay;
    }
  }

  void generateSchedule() {}
  /*double balance = double.parse(state.widget.debt.balance);
    double intrest = double.parse(state.widget.debt.interest) / 100;
    double minPayment = balance * intrest / 12.0;
    String minPay = minPayment.toStringAsFixed(2);
  }*/
}
