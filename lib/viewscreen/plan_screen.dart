import 'package:cap_project/model/constant.dart';
import 'package:cap_project/model/plan.dart';
import 'package:cap_project/viewscreen/addPlan_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PlanScreen extends StatefulWidget {
  static const routeName = '/planScreen';

  final User user;
  late List<Plan> planList;

  PlanScreen({required this.user, required this.planList, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlanState();
  }
} //end PlanScreen

class _PlanState extends State<PlanScreen> {
  late _Controller con;

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
  late List<Plan> planList;

  _Controller(this.state) {
    planList = state.widget.planList;
  }
}
