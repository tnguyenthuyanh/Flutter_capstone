import 'package:flutter/material.dart';

class BudgetDetailField extends StatelessWidget {
  final String titleText;
  final String fieldText;

  BudgetDetailField({required this.titleText, required this.fieldText});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Text(
              titleText,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(fieldText),
          ],
        ),
      ),
    );
  }
}
