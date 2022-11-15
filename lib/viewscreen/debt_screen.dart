import 'package:cap_project/model/debt.dart';
import 'package:cap_project/model/user.dart';
import 'package:cap_project/viewscreen/components/cards/debtCards.dart';
import 'package:cap_project/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/constant.dart';
import 'addDebt_screen.dart';
import 'debtDetail_screen.dart';

class DebtScreen extends StatefulWidget {
  const DebtScreen(
      {required this.debtList,
      required this.user,
      required this.userP,
      Key? key})
      : super(key: key);

  final List<Debt> debtList;
  final User user;
  final UserProfile userP;

  static const routeName = '/debtScreen';

  @override
  State<StatefulWidget> createState() {
    return _DebtState();
  }
}

class _DebtState extends State<DebtScreen> {
  late _Controller con;
  late String email;
  var formKey = GlobalKey<FormState>();

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
        title: Text("$email's Debt List"),
      ),
      body: widget.userP.debts.isEmpty
          ? Text(
              'No Debts entered',
              style: Theme.of(context).textTheme.headline6,
            )
          : ListView.builder(
              itemCount: widget.userP.debts.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => con.onTap(index),
                  child: con.getPercent(widget.userP.debts[index]) > 80
                      ? RedDebtCard(debt: widget.userP.debts[index])
                      : con.getPercent(widget.userP.debts[index]) > 60
                          ? OrangeDebtCard(debt: widget.userP.debts[index])
                          : con.getPercent(widget.userP.debts[index]) > 40
                              ? YellowDebtCard(debt: widget.userP.debts[index])
                              : con.getPercent(widget.userP.debts[index]) > 20
                                  ? LimeGreenDebtCard(
                                      debt: widget.userP.debts[index])
                                  : GreenDebtCard(
                                      debt: widget.userP.debts[index]),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: con.addButton,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: GestureDetector(
          onTap: con.colorKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Color Key',
                style: TextStyle(
                  color: Colors.blue.shade800,
                  fontSize: 16,
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
  _DebtState state;
  // late List<dynamic> debtList;

  _Controller(this.state);

  void addButton() async {
    await Navigator.pushNamed(state.context, AddDebtScreen.routeName,
        arguments: {
          ArgKey.debtList: state.widget.userP.debts,
          ArgKey.user: state.widget.user,
          ArgKey.userProfile: state.widget.userP,
        });
    state.render(() {}); //rerender the screen
  }

  void onTap(int index) async {
    await Navigator.pushNamed(state.context, DebtDetailScreen.routeName,
        arguments: {
          ArgKey.user: state.widget.user,
          ArgKey.singleDebt: state.widget.userP.debts[index],
          ArgKey.userProfile: state.widget.userP,
        });
    state.render(() {});
  }

  void colorKey() {
    showSnackBar(
        context: state.context,
        seconds: 30,
        message:
            'If tile content is red balance is 100-81% of the orginal amount or limit \n'
            'If tile content is orange balance is 80-61% of the orginal amount or limit \n'
            'If tile content is yellow balance is 60-41% of the orginal amount or limit \n'
            'If tile content is lime green balance is 40-21% of the orginal amount or limit \n'
            'If tile content is green balance is less than or equal to 20% of the orginal amount or limit \n ');
  }

  double getPercent(Debt debt) {
    double percent =
        double.parse(debt.balance) / double.parse(debt.original) * 100;
    return percent;
  }
}
