import 'package:cap_project/viewscreen/tools_screen/fuelcostestimator_screen.dart';
import 'package:cap_project/viewscreen/tools_screen/paycheckcalculator_screen.dart';
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
          title: const Text("Tools"),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.1,
            5.0,
            MediaQuery.of(context).size.width * 0.1,
            5.0,
          ),
          child: Center(
            child: Column(
              children: [
                con.button(
                  context,
                  Icons.attach_money,
                  50,
                  'Tip Calculator',
                  () {
                    Navigator.pushNamed(context, TipCalculatorScreen.routeName,
                        arguments: {ArgKey.user: widget.user});
                  },
                ),
                con.button(
                  context,
                  Icons.local_gas_station,
                  20,
                  'Fuel Cost Estimator',
                  () {
                    Navigator.pushNamed(context, FuelCostEstimatorScreen.routeName,
                        arguments: {ArgKey.user: widget.user});
                  },
                ),
                con.button(
                  context,
                  Icons.credit_card,
                  20,
                  'Paycheck Calculator',
                  () {
                    Navigator.pushNamed(context, PaycheckCalculatorScreen.routeName,
                        arguments: {ArgKey.user: widget.user});
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _ToolsState state;
  _Controller(this.state);

  Widget button(
    BuildContext context,
    IconData icon,
    double width,
    String title,
    Function f,
  ) {
    return Card(
      color: Colors.green.shade900,
      child: InkWell(
        splashColor: Colors.green.shade500.withAlpha(50),
        onTap: () {
          f();
        },
        child: SizedBox(
          width: 300,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              SizedBox(width: width),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
