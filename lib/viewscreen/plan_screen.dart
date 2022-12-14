// ignore_for_file: must_be_immutable

import 'package:cap_project/controller/firestore_controller.dart';
import 'package:cap_project/model/constant.dart';
import 'package:cap_project/model/plan.dart';
import 'package:cap_project/viewscreen/addPlan_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PlanScreen extends StatefulWidget {
  static const routeName = '/planScreen';

  final User user;
  late List<Plan> planList = <Plan>[];

  PlanScreen(
      {required this.user,
      //required this.planList,
      Key? key})
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
      body: con.planList.isEmpty
          ? const Text('No plans have been created')
          : ListView.builder(
              itemCount: con.planList.length,
              itemBuilder: ((context, index) {
                return Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: con.toDelete.contains(index)
                        ? Colors.red
                        : Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.red,
                        size: 32,
                      ),
                      onPressed: () => {con.onTap(index, widget.user.email)},
                    ),
                    onLongPress: () => con.onLongPress(index),
                    title: Text('Plan: ${con.planList[index].title}'),
                  ),
                );
              }),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          con.addNewPlanScreen(widget.user.email);
        },
      ),
    );
  }
} //end _PlanState

class _Controller {
  _PlanState state;
  late List<Plan> planList;
  List<int> toDelete = [];
  int selectedIndex = 0;

  _Controller(this.state) {
    planList = state.widget.planList;
    getPlanList(state.widget.user.email);
  }

  Future<void> getPlanList(String? email) async {
    planList = await FirestoreController.getPlanList(email: email!);
    state.render(() {});
  }

  void addNewPlanScreen(String? email) async {
    Navigator.pushNamed(state.context, AddPlanScreen.routeName,
        arguments: {ArgKey.user: state.widget.user});
    planList = await FirestoreController.getPlanList(email: email!);
    state.render(() {
      //reorder so most recent appears at top
      planList.sort((a, b) {
        if (a.timeStamp!.isBefore(b.timeStamp!)) {
          return 1;
        } else if (a.timeStamp!.isAfter(b.timeStamp!)) {
          return -1;
        } else {
          return 0;
        }
      });
    });
  }

  void onTap(int index, String? email) async {}

  void onLongPress(int index) async {
    state.render(() {
      if (toDelete.contains(index)) {
        toDelete.remove(index);
      } else {
        toDelete.add(index);
      }
    });
  }

  void cancelDelete() {
    state.render(() {
      toDelete.clear();
    });
  }

  void delete() async {
    toDelete.sort();
    for (int i = toDelete.length - 1; i >= 0; i--) {
      try {
        Plan f = planList[toDelete[i]];
        await FirestoreController.deletePlan(plan: f);
        state.render(() {
          planList.removeAt(toDelete[i]);
        });
      } catch (e) {
        // ignore: avoid_print
        if (Constant.devMode) print('===== failed to delete plan: $e');
        break; //quit further processing
      }
    }
    state.render(() => toDelete.clear());
  }
} //end controller
