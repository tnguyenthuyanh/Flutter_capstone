import 'package:cap_project/viewscreen/tools_screen/tipcalculator_screen.dart';
import 'package:flutter/material.dart';

class ToolsScreen extends StatefulWidget {
  static const routeName = '/toolsScreen';

  const ToolsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ToolsState();
  }
}

class _ToolsState extends State<ToolsScreen> {
  late _Controller con;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: Scaffold(
          appBar: AppBar(
            title: Text("Tools"),
          ),
          body: Container(
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 2),
                  onPressed: () {
                    Navigator.pushNamed(context, TipCalculatorScreen.routeName);
                  },
                  child: Text('Tip Calculator'),
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
