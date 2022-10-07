import 'package:cap_project/controller/firestore_controller.dart';
import 'package:cap_project/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cap_project/View_Model/auth_viewModel.dart';
import 'package:cap_project/viewscreen/components/my_textfield.dart';

class AddPlanScreen extends StatefulWidget {
  static const routeName = 'addPlanScreen';

  const AddPlanScreen({required this.user, Key? key}) : super(key: key);
  final User user;

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
              width: MediaQuery.of(context).size.width * .7,
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
                    ),
                  ),
                  Center(
                    child: TextFormField(
                      decoration: const InputDecoration(
                          hintText: 'Average cost of your goal item'),
                    ),
                  ),
                  Center(
                    child: TextFormField(
                      decoration: const InputDecoration(
                          hintText:
                              'What are you going to reduce from your budget?'),
                    ),
                  ),
                  Center(
                    child: TextFormField(
                      decoration: const InputDecoration(
                          hintText: 'Reducing budget item for how long?'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: con.save,
                    child: const Text('Save'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} //end_AddPlanState

class _Controller {
  _AddPlanState state;
  _Controller(this.state);

  void save() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) {
      return;
    }

    currentState.save();
    startCircularProgress(state.context);

    try {
      String docId = await FirestoreController.addPlan()
    } catch (e) {}
  }
}
