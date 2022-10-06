import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

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
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.deepPurpleAccent,
                ),
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
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.deepOrangeAccent,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
} //end_AddPlanState

class _Controller {
  _AddPlanState state;
  _Controller(this.state);
}
