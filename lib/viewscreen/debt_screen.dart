import 'package:cap_project/model/custom_icons_icons.dart';
import 'package:cap_project/model/debt.dart';
import 'package:cap_project/model/user.dart';
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
                  child: double.parse(widget.userP.debts[index].balance) /
                              double.parse(widget.userP.debts[index].original) *
                              100 >=
                          80
                      ? Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          elevation: 8.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                widget.userP.debts[index].category == 'Mortgage'
                                    ? const Icon(
                                        Icons.house,
                                        color: Color.fromARGB(255, 212, 7, 7),
                                      )
                                    : widget.userP.debts[index].category ==
                                            'Car loan'
                                        ? const Icon(
                                            CustomIcons.cab,
                                            color:
                                                Color.fromARGB(255, 212, 7, 7),
                                          )
                                        : widget.userP.debts[index].category ==
                                                'Credit Card'
                                            ? const Icon(
                                                CustomIcons.money_check,
                                                color: Color.fromARGB(
                                                    255, 212, 7, 7),
                                              )
                                            : const Icon(
                                                Icons.medical_services,
                                                color: Color.fromARGB(
                                                    255, 212, 7, 7),
                                              ),
                                SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.userP.debts[index].title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .merge(
                                              TextStyle(
                                                color: Color.fromARGB(
                                                    255, 212, 7, 7),
                                              ),
                                            )),
                                    Text(
                                      widget.userP.debts[index].category,
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 212, 7, 7),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : double.parse(widget.userP.debts[index].balance) /
                                  double.parse(
                                      widget.userP.debts[index].original) *
                                  100 >=
                              60
                          ? Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0)),
                              elevation: 8.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    widget.userP.debts[index].category ==
                                            'Mortgage'
                                        ? const Icon(
                                            Icons.house,
                                            color: Color.fromARGB(
                                                255, 255, 166, 0),
                                          )
                                        : widget.userP.debts[index].category ==
                                                'Car loan'
                                            ? const Icon(
                                                CustomIcons.cab,
                                                color: Color.fromARGB(
                                                    255, 255, 166, 0),
                                              )
                                            : widget.userP.debts[index]
                                                        .category ==
                                                    'Credit Card'
                                                ? const Icon(
                                                    CustomIcons.money_check,
                                                    color: Color.fromARGB(
                                                        255, 255, 166, 0),
                                                  )
                                                : const Icon(
                                                    Icons.medical_services,
                                                    color: Color.fromARGB(
                                                        255, 255, 166, 0),
                                                  ),
                                    SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.userP.debts[index].title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .merge(
                                                  TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 255, 166, 0)),
                                                )),
                                        Text(
                                          widget.userP.debts[index].category,
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 166, 0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : double.parse(widget.userP.debts[index].balance) /
                                      double.parse(
                                          widget.userP.debts[index].original) *
                                      100 >=
                                  40
                              ? Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  elevation: 8.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        widget.userP.debts[index].category ==
                                                'Mortgage'
                                            ? const Icon(
                                                Icons.house,
                                                color: Color.fromARGB(
                                                    255, 251, 255, 0),
                                              )
                                            : widget.userP.debts[index]
                                                        .category ==
                                                    'Car loan'
                                                ? const Icon(
                                                    CustomIcons.cab,
                                                    color: Color.fromARGB(
                                                        255, 251, 255, 0),
                                                  )
                                                : widget.userP.debts[index]
                                                            .category ==
                                                        'Credit Card'
                                                    ? const Icon(
                                                        CustomIcons.money_check,
                                                        color: Color.fromARGB(
                                                            255, 251, 255, 0),
                                                      )
                                                    : const Icon(
                                                        Icons.medical_services,
                                                        color: Color.fromARGB(
                                                            255, 251, 255, 0),
                                                      ),
                                        SizedBox(width: 20),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                widget.userP.debts[index].title,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .merge(
                                                      TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 251, 255, 0),
                                                      ),
                                                    )),
                                            Text(
                                              widget
                                                  .userP.debts[index].category,
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 251, 255, 0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : double.parse(widget
                                              .userP.debts[index].balance) /
                                          double.parse(widget
                                              .userP.debts[index].original) *
                                          100 >=
                                      20
                                  ? Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0)),
                                      elevation: 8.0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            widget.userP.debts[index]
                                                        .category ==
                                                    'Mortgage'
                                                ? const Icon(
                                                    Icons.house,
                                                    color: Color.fromARGB(
                                                        255, 123, 255, 0),
                                                  )
                                                : widget.userP.debts[index]
                                                            .category ==
                                                        'Car loan'
                                                    ? const Icon(
                                                        CustomIcons.cab,
                                                        color: Color.fromARGB(
                                                            255, 123, 255, 0),
                                                      )
                                                    : widget.userP.debts[index]
                                                                .category ==
                                                            'Credit Card'
                                                        ? const Icon(
                                                            CustomIcons
                                                                .money_check,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    123,
                                                                    255,
                                                                    0),
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .medical_services,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    123,
                                                                    255,
                                                                    0),
                                                          ),
                                            SizedBox(width: 20),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    widget.userP.debts[index]
                                                        .title,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6!
                                                        .merge(
                                                          TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    123,
                                                                    255,
                                                                    0),
                                                          ),
                                                        )),
                                                Text(
                                                  widget.userP.debts[index]
                                                      .category,
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 123, 255, 0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0)),
                                      elevation: 8.0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            widget.userP.debts[index]
                                                        .category ==
                                                    'Mortgage'
                                                ? const Icon(
                                                    Icons.house,
                                                    color: Color.fromARGB(
                                                        255, 6, 150, 6),
                                                  )
                                                : widget.userP.debts[index]
                                                            .category ==
                                                        'Car loan'
                                                    ? const Icon(
                                                        CustomIcons.cab,
                                                        color: Color.fromARGB(
                                                            255, 6, 150, 6),
                                                      )
                                                    : widget.userP.debts[index]
                                                                .category ==
                                                            'Credit Card'
                                                        ? const Icon(
                                                            CustomIcons
                                                                .money_check,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    6,
                                                                    150,
                                                                    6),
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .medical_services,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    6,
                                                                    150,
                                                                    6),
                                                          ),
                                            SizedBox(width: 20),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    widget.userP.debts[index]
                                                        .title,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6!
                                                        .merge(
                                                          TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    6,
                                                                    150,
                                                                    6),
                                                          ),
                                                        )),
                                                Text(
                                                  widget.userP.debts[index]
                                                      .category,
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 6, 150, 6),
                                                  ),
                                                ),
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

  void colorKey() {
    showSnackBar(
        context: state.context,
        seconds: 30,
        message:
            'If tile is red balance is 100-80% of the orginal amount or limit \n'
            'If tile is orange balance is 79-60% of the orginal amount or limit \n'
            'If tile is yellow balance is 59-40% of the orginal amount or limit \n'
            'If tile is lime green balance is 39-20% of the orginal amount or limit \n'
            'If tile is green balance is lessthan 20% of the orginal amount or limit \n ');
  }
}
