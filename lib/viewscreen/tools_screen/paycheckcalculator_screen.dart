import 'package:cap_project/viewscreen/tools_screen/assets/fedtax.dart';
import 'package:cap_project/viewscreen/tools_screen/view/paycheck_widgets.dart';
import 'package:cap_project/viewscreen/tools_screen/view/popup_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'assets/statetax.dart';

class PaycheckCalculatorScreen extends StatefulWidget {
  static const routeName = '/paycheckCalculatorScreen';

  const PaycheckCalculatorScreen({
    required this.user,
    required this.fedTaxDatabase,
    required this.stateTaxDatabase,
    Key? key,
  }) : super(key: key);
  final User user;
  final List<FedTax> fedTaxDatabase;
  final List<StateTax> stateTaxDatabase;

  @override
  State<StatefulWidget> createState() {
    return _PaycheckCalculatorState();
  }
}

class _PaycheckCalculatorState extends State<PaycheckCalculatorScreen> {
  late _Controller con;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<FedTax> fedTaxDatabase = <FedTax>[];

  late String payPeriod;
  late String stateName;
  late String filingStatus;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);

    payPeriod = FedTax.PAY_PERIOD[0].period!;
    con.totalPayPeriod = FedTax.PAY_PERIOD[0].total!;
    stateName = widget.stateTaxDatabase[0].state.toString();
    con.stateTax = widget.stateTaxDatabase[0];
    filingStatus = FedTax.DEFAULT_FILING_STATUS;
    widget.fedTaxDatabase.forEach((e) {
      if (e.status == filingStatus) fedTaxDatabase.add(e);
    });
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => Future.value(true),
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Paycheck Estimator"),
            actions: [],
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      color: Colors.grey.shade700,
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text("Gross Pay"),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: "0.0",
                            ),
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            validator: (value) {
                              return con.validateGrossPay(value);
                            },
                            onChanged: (value) => {formKey.currentState!.validate()},
                            onSaved: (value) {
                              render(() {
                                con.grossPay = double.parse(value!).abs();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    PaycheckWidgets.pickStringDropDownMenu(
                      context,
                      Colors.green.shade900,
                      'Pay Period',
                      payPeriod,
                      FedTax.PAY_PERIOD.map((e) => e.period.toString()).toList(),
                      (value) {
                        render(() {
                          payPeriod = value;
                          FedTax.PAY_PERIOD.forEach((element) {
                            if (element.period == value) {
                              con.totalPayPeriod = element.total!;
                            }
                          });
                        });
                      },
                    ),
                    PaycheckWidgets.pickStringDropDownMenu(
                      context,
                      Colors.green.shade700,
                      'State',
                      stateName,
                      widget.stateTaxDatabase.map((e) => e.state!).toList(),
                      (value) {
                        render(() {
                          stateName = value;
                          widget.stateTaxDatabase.forEach((element) {
                            if (element.state == stateName) con.stateTax = element;
                          });
                        });
                      },
                    ),
                    PaycheckWidgets.pickStringDropDownMenu(
                      context,
                      Colors.green.shade900,
                      'Filing Status',
                      filingStatus,
                      widget.fedTaxDatabase
                          .map((e) => e.status.toString())
                          .toSet()
                          .toList(),
                      (value) {
                        render(() {
                          filingStatus = value;
                          fedTaxDatabase.clear();
                          widget.fedTaxDatabase.forEach((element) {
                            if (element.status == value) fedTaxDatabase.add(element);
                          });
                        });
                      },
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width * 0.3,
                          20,
                          MediaQuery.of(context).size.width * 0.3,
                          20),
                      child: Card(
                        color: Colors.green.shade900,
                        child: InkWell(
                          splashColor: Colors.red.shade500.withAlpha(50),
                          onTap: () {
                            con.estimate(context);
                          },
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Estimate "),
                                const Icon(Icons.sync),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class _Controller {
  _PaycheckCalculatorState state;
  _Controller(this.state);

  late double grossPay = 0;
  late StateTax stateTax;
  FedTax fedTax = FedTax();
  late int totalPayPeriod;

  String? validateGrossPay(String? value) {
    if (double.tryParse(value!) == null || double.parse(value) == 0) {
      return 'Insert a number';
    }
    return null;
  }

  void estimate(BuildContext context) {
    if (!state.formKey.currentState!.validate()) return;
    state.formKey.currentState!.save();

    double estGrossAnnualPay = grossPay * totalPayPeriod;
    for (int i = 0; i < state.fedTaxDatabase.length - 1; i++) {
      if (estGrossAnnualPay >= state.fedTaxDatabase[i].wageThreshold! &&
          estGrossAnnualPay < state.fedTaxDatabase[i + 1].wageThreshold!) {
        fedTax = state.fedTaxDatabase[i];
        break;
      }
    }
    double tentativeAnnualWithholding = fedTax.baseWithholding! +
        fedTax.rateOverThreshold! * (estGrossAnnualPay - fedTax.wageThreshold!);
    double ficaSSN = grossPay * (FedTax.FICA_SSN_RATE / 100);
    double ficaMedicare = grossPay * (FedTax.FICA_MEDICARE_RATE / 100);
    double fedTaxWithheld = tentativeAnnualWithholding / totalPayPeriod;
    double stateAndLocalTaxes = grossPay * (stateTax.rate! / 100);
    double netTakeHomePay =
        grossPay - (ficaSSN + ficaMedicare + fedTaxWithheld + stateAndLocalTaxes);

    PopupDialog.statefulPopUpWithoutSetState(
      context: context,
      title: 'Estimated Pay Check',
      animationTransitionDelay: 50,
      widgetList: <Widget>[
        PaycheckWidgets.resultContentsContainer(
          Colors.cyan.shade900,
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              children: [
                PaycheckWidgets.resultContent(
                    context, "Gross Pay:", '\$ ' + grossPay.toString(), 12),
                PaycheckWidgets.resultContent(context, "Est. Gross Annual Pay:",
                    '\$ ' + estGrossAnnualPay.toString(), 12),
              ],
            ),
          ),
        ),
        PaycheckWidgets.resultContentsContainer(
          Colors.green.shade900,
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              children: [
                PaycheckWidgets.resultContent(
                    context, "Pay Period:", state.payPeriod.toString(), 12),
                PaycheckWidgets.resultContent(
                    context, "Periods Per Year:", totalPayPeriod.toString(), 12),
              ],
            ),
          ),
        ),
        PaycheckWidgets.resultContentsContainer(
          Colors.green.shade900,
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              children: [
                PaycheckWidgets.resultContent(
                    context, "Filing Status:", state.filingStatus.toString(), 12),
              ],
            ),
          ),
        ),
        PaycheckWidgets.resultContentsContainer(
          Colors.green.shade900,
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              children: [
                PaycheckWidgets.resultContent(context, "State:",
                    stateTax.state! + ' (' + stateTax.abbreviation! + ')', 12),
                PaycheckWidgets.resultContent(
                    context, "Tax Rate:", stateTax.rate.toString() + "%", 12),
              ],
            ),
          ),
        ),
        PaycheckWidgets.resultContentsContainer(
          Colors.red.shade500,
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              children: [
                PaycheckWidgets.resultContent(context, "FICA Social Security (6.2%):",
                    '\$ ' + ficaSSN.toStringAsFixed(2).toString(), 12),
                PaycheckWidgets.resultContent(context, "FICA Medicare (1.45%):",
                    '\$ ' + ficaMedicare.toStringAsFixed(2).toString(), 12),
                PaycheckWidgets.resultContent(context, "Federal Tax Withheld:",
                    '\$ ' + fedTaxWithheld.toStringAsFixed(2).toString(), 12),
                PaycheckWidgets.resultContent(context, "State & Local Taxes:",
                    '\$ ' + stateAndLocalTaxes.toStringAsFixed(2).toString(), 12),
              ],
            ),
          ),
        ),
        PaycheckWidgets.resultContentsContainer(
          Colors.black,
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              children: [
                PaycheckWidgets.resultContent(context, "NET Take-Home Pay:",
                    '\$ ' + netTakeHomePay.toStringAsFixed(2).toString(), 12),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
