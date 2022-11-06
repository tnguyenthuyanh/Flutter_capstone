import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/debt.dart';
import 'view/view_util.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class PayoffScheduleScreen extends StatefulWidget {
  const PayoffScheduleScreen({required this.debt, required this.user, Key? key})
      : super(key: key);

  final Debt debt;
  final User user;

  static const routeName = '/PayoffScheduleScreen';

  @override
  State<StatefulWidget> createState() {
    return _PayoffScheduleState();
  }
}

class _PayoffScheduleState extends State<PayoffScheduleScreen> {
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
        title: Text(widget.debt.title + ' Payoff schedule'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Center(
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
                  initialValue: 'Interest Rate: ' + widget.debt.interest + '%',
                ),
                TextFormField(
                  enabled: false,
                  style: Theme.of(context).textTheme.bodyText1,
                  initialValue: 'Minimum payment: \$' + con.setMinPayment(),
                ),
                !showSchedule
                    ? Column(
                        children: [
                          /*TextFormField(
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: const InputDecoration(
                                hintText: 'Enter payment amount',
                                labelText: 'Payment amount'),
                            keyboardType: TextInputType.number,
                            validator: Debt.validatePayment,
                            onSaved: con.savePayment,
                          ),*/
                          SleekCircularSlider(
                            appearance: CircularSliderAppearance(
                              size: 250,
                              infoProperties: InfoProperties(
                                topLabelText: 'payment \n amount',
                                topLabelStyle: TextStyle(
                                  fontSize: 20,
                                ),
                                mainLabelStyle: TextStyle(
                                  color: Colors.green.shade800,
                                  fontSize: 30,
                                ),
                                modifier: con.showDollar,
                              ),
                              customColors: (CustomSliderColors(
                                  trackColor: Colors.white,
                                  progressBarColors: [
                                    Colors.green.shade900,
                                    Colors.green.shade800,
                                    Colors.green.shade700,
                                    Colors.green.shade600,
                                    Colors.green,
                                    Colors.yellow,
                                    Colors.yellow.shade600,
                                    Colors.yellow.shade700,
                                    Colors.yellow.shade800,
                                    Colors.yellow.shade900,
                                    Colors.orange,
                                    Colors.orange.shade600,
                                    Colors.orange.shade700,
                                    Colors.orange.shade800,
                                    Colors.orange.shade900,
                                    Colors.red,
                                    Colors.red.shade600,
                                    Colors.red.shade700,
                                    Colors.red.shade800,
                                    Colors.red.shade900,
                                  ])),
                            ),
                            // key: formKey,
                            initialValue: double.parse(con.setMinPayment()) +
                                double.parse(widget.debt.balance) / 2,
                            min: double.parse(con.setMinPayment()),
                            max: double.parse(widget.debt.balance),
                            onChangeEnd: con.savePayment2,
                          ),
                          ElevatedButton(
                            onPressed: con.generateSchedule,
                            child: const Text("Submit"),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          /*TextFormField(
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: const InputDecoration(
                                hintText: 'Enter payment amount',
                                labelText: 'Payment amount'),
                            keyboardType: TextInputType.number,
                            validator: Debt.validatePayment,
                            onSaved: con.savePayment,
                          ),*/
                          TextFormField(
                              enabled: false,
                              style: Theme.of(context).textTheme.bodyText1,
                              initialValue: 'Months to pay off: ' +
                                  con.payments.toString()),
                          TextFormField(
                            enabled: false,
                            style: Theme.of(context).textTheme.bodyText1,
                            initialValue: 'Total interest paid: \$' +
                                con.interestPaid.toStringAsFixed(2),
                          ),
                          SleekCircularSlider(
                            appearance: CircularSliderAppearance(
                              size: 250,
                              infoProperties: InfoProperties(
                                topLabelText: 'payment \n amount',
                                topLabelStyle: TextStyle(
                                  fontSize: 20,
                                ),
                                mainLabelStyle: TextStyle(
                                  color: Colors.green.shade800,
                                  fontSize: 30,
                                ),
                                modifier: con.showDollar,
                              ),
                              customColors: (CustomSliderColors(
                                  trackColor: Colors.white,
                                  progressBarColors: [
                                    Colors.green.shade900,
                                    Colors.green.shade800,
                                    Colors.green.shade700,
                                    Colors.green.shade600,
                                    Colors.green,
                                    Colors.yellow,
                                    Colors.yellow.shade600,
                                    Colors.yellow.shade700,
                                    Colors.yellow.shade800,
                                    Colors.yellow.shade900,
                                    Colors.orange,
                                    Colors.orange.shade600,
                                    Colors.orange.shade700,
                                    Colors.orange.shade800,
                                    Colors.orange.shade900,
                                    Colors.red,
                                    Colors.red.shade600,
                                    Colors.red.shade700,
                                    Colors.red.shade800,
                                    Colors.red.shade900,
                                  ])),
                            ),
                            // key: formKey,
                            initialValue: double.parse(con.setMinPayment()) +
                                double.parse(widget.debt.balance) / 2,
                            min: double.parse(con.setMinPayment()),
                            max: double.parse(widget.debt.balance),
                            onChangeEnd: con.savePayment2,
                          ),
                          ElevatedButton(
                            onPressed: con.generateSchedule,
                            child: const Text("Submit"),
                          ),
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _PayoffScheduleState state;
  Debt tempDebt = Debt();
  late int payments;
  late double interestPaid;
  late double paymentAmount;
  late double minPayment;
  late String payAmt;

  _Controller(this.state) {
    tempDebt = Debt.clone(state.widget.debt);
    interestPaid = 0;
    payments = 0;
  }

  String showDollar(double value) {
    final roundedValue = value.ceil().toInt().toString();
    return '\$' + value.toStringAsFixed(2);
  }

  void savePayment(String? value) {
    if (value != null) {
      paymentAmount = double.parse(value);
    }
  }

  void savePayment2(double? value) {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) {
      return;
    }
    if (value != null) {
      paymentAmount = value;
      state.showSchedule = false;
      interestPaid = 0;
      payments = 0;
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
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) {
      return;
    }

    currentState.save();

    if (paymentAmount < minPayment) {
      showSnackBar(
        context: state.context,
        seconds: 10,
        message: 'Payment amount is too small \n payment  = ' +
            paymentAmount.toStringAsFixed(2) +
            '\n minimum = ' +
            minPayment.toStringAsFixed(2),
      );
      state.showSchedule = false;
      state.render(() {});
      return;
    } else {
      double tempInterest = 0;
      double principal = 0;
      interestPaid = 0;
      payments = 0;
      double balance = double.parse(state.widget.debt.balance);
      double intrest = double.parse(state.widget.debt.interest) / 100;
      while (balance > 0) {
        print('balance: ' + balance.toStringAsFixed(2));
        tempInterest = balance * (intrest / 12);
        interestPaid += tempInterest;
        print('interest: ' + interestPaid.toStringAsFixed(2));
        principal = paymentAmount - tempInterest;
        balance = balance - principal;
        payments++;
      }
      print(payments);
      state.showSchedule = true;
      state.render(() {});
    }
  }
}
