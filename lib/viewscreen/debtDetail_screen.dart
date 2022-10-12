import 'package:cap_project/model/debt.dart';
import 'package:cap_project/model/user.dart';
import 'package:cap_project/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'payoffSchedule_screen.dart';
import '../controller/firestore_controller.dart';
import '../model/constant.dart';
import 'debt_screen.dart';

class DebtDetailScreen extends StatefulWidget {
  const DebtDetailScreen({
    required this.user,
    required this.userP,
    required this.debt,
    Key? key,
  }) : super(key: key);

  static const routeName = '/debtDetailScreen';

  final User user;
  final Debt debt;
  final UserProfile userP;

  @override
  State<StatefulWidget> createState() {
    return _DebtDetailState();
  }
}

class _DebtDetailState extends State<DebtDetailScreen> {
  late _Controller con;
  bool editmode = false;
  var formKey = GlobalKey<FormState>();
  String? dropValue = null;

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
          title: const Text('Detailed View'),
          actions: [
            editmode
                ? IconButton(
                    onPressed: con.update, icon: const Icon(Icons.check))
                : IconButton(onPressed: con.edit, icon: const Icon(Icons.edit))
          ],
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  enabled: editmode,
                  style: Theme.of(context).textTheme.headline6,
                  decoration: const InputDecoration(
                    hintText: 'Enter title',
                  ),
                  initialValue: con.tempDebt.title,
                  validator: Debt.validateTitle,
                  onSaved: con.saveTitle,
                ),
                TextFormField(
                  enabled: editmode,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: const InputDecoration(
                    hintText: 'Enter Balance',
                  ),
                  initialValue: "Balance: \$" + con.tempDebt.balance,
                  keyboardType: TextInputType.numberWithOptions(),
                  maxLines: 1,
                  validator: Debt.validateBalance,
                  onSaved: con.saveBalance,
                ),
                TextFormField(
                  enabled: editmode,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: const InputDecoration(
                    hintText: 'Enter Interest Rate',
                  ),
                  initialValue: "Interest Rate: " + con.tempDebt.interest + '%',
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  validator: Debt.validateInterest,
                  onSaved: con.saveInterest,
                ),
                editmode
                    ? DropdownButton(
                        value: con.tempDebt.category,
                        items: Constant.menuItems,
                        onChanged: con.saveCategory,
                        hint: const Text('Select Category'),
                      )
                    : Text('Debt Category \n' + con.tempDebt.category),
                ElevatedButton(
                    onPressed: con.payOff, child: Text('Payoff Schedule'))
              ],
            ),
          ),
        ));
  }
}

class _Controller {
  _DebtDetailState state;
  late Debt tempDebt;

  _Controller(this.state) {
    tempDebt = Debt.clone(state.widget.debt);
  }

  void update() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null) return;
    if (!currentState.validate()) return;
    currentState.save();

    startCircularProgress(state.context);
    try {
      Map<String, dynamic> update = {};
      //update Firestore doc
      if (tempDebt.title != state.widget.debt.title) {
        update[DocKeyDebt.title.name] = tempDebt.title;
      }

      if (tempDebt.balance != state.widget.debt.balance) {
        update[DocKeyDebt.balance.name] = tempDebt.balance;
      }

      if (tempDebt.interest != state.widget.debt.interest) {
        update[DocKeyDebt.interest.name] = tempDebt.interest;
      }

      if (tempDebt.category != state.widget.debt.category) {
        update[DocKeyDebt.category.name] = tempDebt.category;
      }

      if (update.isNotEmpty) {
        //change has been made
        await FirestoreController.updateDebt(
            userP: state.widget.userP, docId: tempDebt.docId!, update: update);

        //update the original
        state.widget.debt.copyFrom(tempDebt);
      }

      await Navigator.pushNamed(
        state.context,
        DebtScreen.routeName,
        arguments: {
          ArgKey.debtList:
              FirestoreController.getDebtList(user: state.widget.userP),
          ArgKey.user: state.widget.user,
          ArgKey.userProfile: state.widget.userP,
        },
      );

      stopCircularProgress(state.context);
      state.render(() => state.editmode = false);
    } catch (e) {
      stopCircularProgress(state.context);
      if (Constant.devMode) print('======== failed to get update: $e');
      showSnackBar(
          context: state.context, seconds: 20, message: 'failed to update: $e');
    }
  }

  void edit() {
    state.render(() => state.editmode = true);
  }

  void saveTitle(String? value) {
    if (value != null) {
      tempDebt.title = value;
    }
  }

  void saveBalance(String? value) {
    if (value != null) {
      tempDebt.balance = value;
    }
  }

  void saveInterest(String? value) {
    if (value != null) {
      tempDebt.interest = value;
    }
  }

  void saveCategory(String? value) {
    if (value != null) {
      tempDebt.category = value;
      state.dropValue = value;
      state.render(() {});
    }
  }

  void payOff() async {
    await Navigator.pushNamed(state.context, PayoffScheduleScreen.routeName,
        arguments: {
          ArgKey.user: state.widget.user,
          ArgKey.singleDebt: state.widget.debt
        });
    state.render(() {}); //rerender the screen
  }
}
