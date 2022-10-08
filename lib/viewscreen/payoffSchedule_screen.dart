import 'dart:ffi';

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
              style: Theme.of(context).textTheme.bodyText1,
              decoration: const InputDecoration(
                hintText: 'Enter payment amount',
              ),
              keyboardType: TextInputType.number,
              maxLines: 1,
              validator: _Controller.validatePayment,
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
  // late List<dynamic> debtList;

  _Controller(this.state) {
    Debt debt = state.widget.debt;
    double payment = 0.0;
  }

  static String? validatePayment(String? value) {
    return (value == null || value.trim().length < 2)
        ? "Title too short"
        : null;
  }

  void savePayment(String? value) {
    if (value != null) {
      double payment = double.parse(value);
    }
  }

  void generateSchedule() {}
}
