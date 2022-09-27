import 'package:cap_project/model/tipcalc.dart';
import 'package:cap_project/viewscreen/tools_screen/view/star_rating.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TipCalculatorScreen extends StatefulWidget {
  static const routeName = '/tipCalculatorScreen';

  const TipCalculatorScreen({required this.user, Key? key}) : super(key: key);
  final User user;

  @override
  State<StatefulWidget> createState() {
    return _TipCalculatorState();
  }
}

class _TipCalculatorState extends State<TipCalculatorScreen> {
  late _Controller con;
  List<int> list = <int>[];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    for (int i = 1; i <= 50; i++) {
      list.add(i);
    }
    con.numOfPeople = list.first;
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Tip Calculator"),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.green.shade900,
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Purchase Amount (\$)"),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "\$ 0.0",
                          ),
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          validator: (value) {
                            return TipCalc.validatePurchaseAmount(value);
                          },
                          onSaved: (value) {
                            con.savePurchaseAmount(value);
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.green.shade800.withAlpha(90),
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: StarRating(
                            rating: con.star,
                            onRatingChanged: (rating) => setState(() {
                              con.star = rating;
                            }),
                            color: Colors.yellow,
                          ),
                        ),
                        con.star == 0
                            ? const Text("No Tip")
                            : Row(
                                children: [
                                  Text("Tip " + (con.star * 5).toString() + "%"),
                                  Card(
                                    color: Colors.red.shade900,
                                    child: InkWell(
                                      splashColor: Colors.red.shade500.withAlpha(50),
                                      onTap: () => setState(() {
                                        con.star = 0;
                                      }),
                                      child: const SizedBox(
                                        child: Icon(Icons.delete),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.green.shade900,
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: con.numOfPeople,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          style: const TextStyle(color: Colors.white),
                          underline: Container(
                            height: 2,
                            color: Colors.cyan,
                          ),
                          items: list.map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text("With $value person(s)"),
                            );
                          }).toList(),
                          onChanged: (int? value) {
                            setState(() {
                              con.numOfPeople = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.green.shade800.withAlpha(90),
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("Note"),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Add a note",
                          ),
                          keyboardType: TextInputType.text,
                          maxLines: 2,
                          onSaved: (String? value) {
                            con.saveNote(value);
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.3,
                        20, MediaQuery.of(context).size.width * 0.3, 20),
                    child: Card(
                      color: Colors.green.shade900,
                      child: InkWell(
                        splashColor: Colors.red.shade500.withAlpha(50),
                        onTap: () => con.calculate(context),
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Calculate "),
                              const Icon(Icons.rotate_90_degrees_ccw),
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
      ),
    );
  }
}

class _Controller {
  _TipCalculatorState state;
  _Controller(this.state);
  static const RATE_PER_STAR = 0.05;
  static const ANIMATION_TRANSITION_DELAY = 500;

  TipCalc tipcalc = TipCalc();

  double purchaseAmount = 0;
  double star = 0;
  int numOfPeople = 1;
  String? note;

  double totalTip = 0;
  double tipPerPerson = 0;
  double totalPay = 0;

  double amountPerPerson = 0;

  void savePurchaseAmount(String? value) {
    purchaseAmount = double.parse(value!).abs();
  }

  void saveNote(String? value) {
    note = value;
  }

  void calculate(BuildContext context) {
    if (!state.formKey.currentState!.validate()) return;
    state.formKey.currentState!.save();

    totalTip = star * RATE_PER_STAR * purchaseAmount;
    totalPay = purchaseAmount + totalTip;
    tipPerPerson = totalTip / numOfPeople;
    amountPerPerson = totalPay / numOfPeople;

    tipcalc.purchaseAmount = purchaseAmount;
    tipcalc.star = star;
    tipcalc.numOfPeople = numOfPeople;
    tipcalc.note = note;
    tipcalc.totalTip = totalTip;
    tipcalc.tipPerPerson = tipPerPerson;
    tipcalc.totalPay = totalPay;
    tipcalc.amountPerPerson = amountPerPerson;
    showCustomDialog(state.context, tipcalc);
  }

  void showCustomDialog(BuildContext context, TipCalc tc) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: ANIMATION_TRANSITION_DELAY),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 300,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Total Pay: " + tc.totalPay!.toStringAsFixed(2).toString(),
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    "Total Tip: " + tc.totalTip!.toStringAsFixed(2).toString(),
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    "Tip Per Person: " + tc.tipPerPerson!.toStringAsFixed(2).toString(),
                    style: TextStyle(fontSize: 14),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                    child: Text(
                      "Amount Per Person: " +
                          tc.amountPerPerson!.toStringAsFixed(2).toString(),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }
}
