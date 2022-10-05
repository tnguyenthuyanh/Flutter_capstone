import 'package:cap_project/controller/firestore_controller.dart';
import 'package:cap_project/model/tipcalc.dart';
import 'package:cap_project/viewscreen/tools_screen/view/popup_dialog.dart';
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
          actions: [
            IconButton(
              icon: Icon(Icons.list),
              onPressed: () => con.getTipCalcList(),
            )
          ],
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
                    color: Colors.grey.shade600,
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("Purchase Amount (\$)"),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "\$ 0.0",
                          ),
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          validator: (value) {
                            return TipCalc.validatePurchaseAmount(value);
                          },
                          onChanged: (value) => {formKey.currentState!.validate()},
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
                            ? Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.black.withAlpha(90),
                                ),
                                child: const Text("No Tip"))
                            : Row(
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withAlpha(90),
                                      ),
                                      child: Text((con.star * 5).toString() + "%")),
                                  Card(
                                    // color: Colors.red.shade900,
                                    child: InkWell(
                                      splashColor: Colors.red.shade500.withAlpha(90),
                                      onTap: () => setState(() {
                                        con.star = 0;
                                      }),
                                      child: const SizedBox(
                                        child: Icon(
                                          Icons.delete_forever,
                                          size: 18,
                                        ),
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
                    color: Colors.green.shade800.withAlpha(90),
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
      ),
    );
  }
}

class _Controller {
  _TipCalculatorState state;
  _Controller(this.state);
  static const ratePerStar = 0.05;
  static const animationTransitionDelay = 500;

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

    totalTip = star * ratePerStar * purchaseAmount;
    totalPay = purchaseAmount + totalTip;
    tipPerPerson = totalTip / numOfPeople;
    amountPerPerson = totalPay / numOfPeople;

    tipcalc.createBy = state.widget.user.email;
    tipcalc.timestamp = DateTime.now();
    tipcalc.purchaseAmount = purchaseAmount;
    tipcalc.star = star;
    tipcalc.numOfPeople = numOfPeople;
    tipcalc.note = note;
    tipcalc.totalTip = totalTip;
    tipcalc.tipPerPerson = tipPerPerson;
    tipcalc.totalPay = totalPay;
    tipcalc.amountPerPerson = amountPerPerson;
    showCalculatedResult(state.context, tipcalc);
  }

  void showCalculatedResult(BuildContext context, TipCalc tc) {
    showGeneralDialog(
      context: context,
      useRootNavigator: false,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: animationTransitionDelay),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 300,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(100),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Text(
                          "Total Pay: ",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(50),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "\$ " + tc.totalPay!.toStringAsFixed(2).toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade700,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Total Tip: ",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(50),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "\$ " + tc.totalTip!.toStringAsFixed(2).toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Tip Per Person: ",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(50),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "\$ " + tc.tipPerPerson!.toStringAsFixed(2).toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade900,
                      // borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
                    ),
                    padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                    child: Row(
                      children: [
                        Text(
                          "Amount Per Person: ",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(50),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "\$ " + tc.amountPerPerson!.toStringAsFixed(2).toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.green.withAlpha(90),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 14,
                              ),
                              Text(
                                tc.numOfPeople!.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.3,
                        20, MediaQuery.of(context).size.width * 0.3, 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
                      color: Colors.cyan.shade900,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      color: Colors.cyan.shade900.withAlpha(90),
                      child: InkWell(
                        splashColor: Colors.red.shade500.withAlpha(50),
                        onTap: () => saveTipCalc(context, tc),
                        child: SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("Save "),
                              SizedBox(width: 10),
                              Icon(Icons.cloud_upload),
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
        );
      },
      transitionBuilder: (_, animation, __, child) {
        Tween<Offset> tween;
        if (animation.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  void saveTipCalc(BuildContext context, TipCalc tc) async {
    PopupDialog.circularProgressStart(context);
    try {
      String id = await FirestoreController.saveTipCalc(tc);
      tc.docId = id;
      state.setState(() {
        numOfPeople = 1;
        star = 0;
      });
      state.formKey.currentState!.reset();
      PopupDialog.circularProgressStop(context);
      Navigator.pop(context, true);
      PopupDialog.info(context: context, title: "YAY!", content: 'Saved! =)');
    } catch (e) {
      PopupDialog.circularProgressStop(context);
      PopupDialog.info(
        context: context,
        title: "Save Failed",
        content: '$e',
      );
    }
  }

  void getTipCalcList() async {
    try {
      var tipCalcList = <TipCalc>[];
      tipCalcList = await FirestoreController.getTipCalcList(
          email: state.widget.user.email.toString());
      tipCalcList.forEach((tc) {
        print(tc.amountPerPerson);
      });
    } catch (e) {}
  }

  void showSavedTipCalc(BuildContext context, TipCalc tc) {
    showGeneralDialog(
      context: context,
      useRootNavigator: false,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: animationTransitionDelay),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 300,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(100),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, animation, __, child) {
        Tween<Offset> tween;
        if (animation.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }
}
