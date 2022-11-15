// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class BudgetDetailField extends StatelessWidget {
  final String titleText;
  final String fieldText;

  // ignore: use_key_in_widget_constructors
  BudgetDetailField({required this.titleText, required this.fieldText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Text(
            titleText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(fieldText),
        ],
      ),
    );
  }
}
