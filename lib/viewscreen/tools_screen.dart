import 'package:cap_project/viewscreen/tools_screen/tipcalculator_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/constant.dart';

class ToolsScreen extends StatefulWidget {
  static const routeName = '/toolsScreen';

  const ToolsScreen({required this.user, Key? key}) : super(key: key);
  final User user;

  @override
  State<StatefulWidget> createState() {
    return _ToolsState();
  }
}

class _ToolsState extends State<ToolsScreen> {
  late _Controller con;
  late String email;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    email = widget.user.email ?? 'No email';
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: Scaffold(
          appBar: AppBar(
            title: Text("Tools of $email"),
          ),
          body: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 2),
                  onPressed: () {
                    Navigator.pushNamed(context, TipCalculatorScreen.routeName,
                        arguments: {ArgKey.user: widget.user});
                  },
                  child: const Text('Tip Calculator'),
                )
              ],
            ),
          )),
    );
  }
}

class _Controller {
  _ToolsState state;
  _Controller(this.state);
}
