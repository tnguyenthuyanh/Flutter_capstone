import 'package:cap_project/model/custom_icons_icons.dart';
import 'package:cap_project/model/debt.dart';
import 'package:cap_project/model/user.dart';
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
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    elevation: 8.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          widget.userP.debts[index].category == 'Mortgage'
                              ? const Icon(Icons.house)
                              : widget.userP.debts[index].category == 'Car loan'
                                  ? const Icon(CustomIcons.cab)
                                  : widget.userP.debts[index].category ==
                                          'Credit Card'
                                      ? const Icon(CustomIcons.money_check)
                                      : const Icon(Icons.medical_services),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.userP.debts[index].title,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Text(widget.userP.debts[index].category),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: con.addButton,
      ),
    );
  }
}

class _Controller {
  _DebtState state;
  // late List<dynamic> debtList;

  _Controller(this.state) {
    List<dynamic> debtList = state.widget.userP.debts;
  }

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
}
