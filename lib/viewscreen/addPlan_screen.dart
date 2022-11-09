import 'package:cap_project/controller/firestore_controller.dart';
import 'package:cap_project/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cap_project/View_Model/auth_viewModel.dart';
//import 'package:cap_project/viewscreen/components/my_textfield.dart';

import '../model/constant.dart';
import '../model/plan.dart';
import '../model/user.dart';

class AddPlanScreen extends StatefulWidget {
  static const routeName = 'addPlanScreen';
  final User user;
  late List<Plan> planList;

  AddPlanScreen({required this.user, required this.planList, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddPlanState();
  }
} //end of AddPlanScreen

class _AddPlanState extends State<AddPlanScreen> {
  late _Controller con;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
        title: const Text('Add a new plan'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * .5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
              ),
            ),
            const VerticalDivider(
              color: Colors.grey,
              thickness: 1,
              indent: 20,
              endIndent: 0,
              width: 20,
            ),
            Expanded(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Fill in the below items for your plan',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Center(
                      child: TextFormField(
                        decoration: const InputDecoration(
                            hintText: 'What are you saving for?'),
                        onSaved: con.saveTitle,
                      ),
                    ),
                    Center(
                      child: TextFormField(
                        decoration: const InputDecoration(
                            hintText: 'Average cost of your goal item'),
                        onSaved: con.saveCost,
                      ),
                    ),
                    Center(
                      child: TextFormField(
                        decoration: const InputDecoration(
                            hintText:
                                'What are you going to reduce from your budget?'),
                        onSaved: con.saveReduction,
                      ),
                    ),
                    Center(
                      child: TextFormField(
                        decoration: const InputDecoration(
                            hintText: 'Reducing budget item for how long?'),
                        onSaved: con.reductionLength,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: con.save,
                      child: const Text('Save'),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} //end _AddPlanState

class _Controller {
  late _AddPlanState state;
  Plan tempPlan = Plan();
  _Controller(this.state);

  void save() async {
    FormState? currentState = state.formKey.currentState;

    if (currentState == null || !currentState.validate()) {
      return;
    }

    currentState.save();
    startCircularProgress(state.context);

    try {
      tempPlan.createdBy = state.widget.user.email!;
      tempPlan.timeStamp = DateTime.now();

      String docId = await FirestoreController.addPlan(plan: tempPlan);

      tempPlan.docId = docId;
      state.widget.planList.insert(0, tempPlan);

      stopCircularProgress(state.context);

      Navigator.pop(state.context);
    } catch (e) {
      stopCircularProgress(state.context);
      if (Constant.devMode) print('Error uploading Plan doc to Firestore: $e');
    }
  }

  void saveTitle(String? value) {
    if (value != null) tempPlan.title = value;
  }

  void saveReduction(String? value) {
    if (value != null) tempPlan.reduction = value;
  }

  void saveCost(String? value) {
    if (value != null) tempPlan.costs = value;
  }

  void reductionLength(String? value) {
    if (value != null) tempPlan.length = value;
  }
}//End controller