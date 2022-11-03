import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PaycheckCalculatorScreen extends StatefulWidget {
  static const routeName = '/paycheckCalculatorScreen';

  const PaycheckCalculatorScreen({required this.user, Key? key}) : super(key: key);
  final User user;

  @override
  State<StatefulWidget> createState() {
    return _PaycheckCalculatorState();
  }
}

class _PaycheckCalculatorState extends State<PaycheckCalculatorScreen> {
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
            title: const Text("Paycheck Calculator"),
            actions: [],
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("This is new"),
                ],
              ),
            ),
          ),
        ));
  }
}

class _Controller {
  _PaycheckCalculatorState state;
  _Controller(this.state);
}
