import 'package:cap_project/model/constant.dart';
import 'package:cap_project/viewscreen/addPlan_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PlanScreen extends StatefulWidget {
  static const routeName = '/planScreen';

  const PlanScreen({required this.user, Key? key}) : super(key: key);
  final User user;

  @override
  State<StatefulWidget> createState() {
    return _PlanState();
  }
} //end PlanScreen

class _PlanState extends State<PlanScreen> {
  late _Controller con;
  late String email;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    email = widget.user.email ?? 'No email found';
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a new plan'),
      ),
      body: const SingleChildScrollView(
        child: Text('plans'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, AddPlanScreen.routeName,
              arguments: {ArgKey.user: widget.user});
        },
      ),
    );
  }
} //end _PlanState

class _Controller {
  _PlanState state;
  _Controller(this.state);

  Future<void> addPlan() async {}
}
