import 'package:cap_project/model/constant.dart';
import 'package:cap_project/model/savings.dart';
import 'package:cap_project/model/savingsBadge.dart';
import 'package:cap_project/model/user.dart';
import 'package:cap_project/viewscreen/addSavings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SavingsScreen extends StatefulWidget {
  SavingsScreen({
    required this.userP,
    required this.user,
    required this.savings,
    Key? key,
  }) : super(key: key);

  final List<Savings> savings;
  final User user;
  final UserProfile userP;
  List<SavingsBadge>? badges;

  static const routeName = '/savingsScreen';

  @override
  State<StatefulWidget> createState() {
    return _SavingsState();
  }
}

class _SavingsState extends State<SavingsScreen> {
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
          title: widget.userP.savings.isEmpty
              ? const Text('No Savings :(')
              : Text(
                  'Highest Savings \$ ${widget.userP.savings.first.amount.toStringAsFixed(2)}')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (var badge in badgeList)
              if (badge.amount <= widget.userP.savings.first.amount)
                Card(
                  margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                  color: Colors.black12,
                  elevation: 15.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: Image.network(badge.badgeUrl),
                      ),
                    ],
                  ),
                )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: con.savingsPage,
      ),
    );
  }
}

class _Controller {
  _SavingsState state;
  late List<dynamic> savings;

  _Controller(this.state) {
    List<dynamic> savings = state.widget.userP.savings;
  }

  void savingsPage() async {
    await Navigator.pushNamed(state.context, AddSavingsScreen.routeName,
        arguments: {
          ArgKey.savings: state.widget.userP.savings,
          ArgKey.user: state.widget.user,
          ArgKey.userProfile: state.widget.userP,
        });
    state.render(() {});
  }
}
