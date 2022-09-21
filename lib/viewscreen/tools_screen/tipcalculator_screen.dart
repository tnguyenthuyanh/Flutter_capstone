import 'package:flutter/material.dart';

class TipCalculatorScreen extends StatefulWidget {
  static const routeName = '/tipCalculatorScreen';

  const TipCalculatorScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TipCalculatorState();
  }
}

class _TipCalculatorState extends State<TipCalculatorScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Tip Calculator"),
        ),
        body: const Text("This is tip calc screen"),
      ),
    );
  }
}
