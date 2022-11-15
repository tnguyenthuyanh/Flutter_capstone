// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class OhNoesErrorText extends StatelessWidget {
  final String message;

  OhNoesErrorText({required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(
      'No Budgets to show',
      style: Theme.of(context).textTheme.headline5,
    );
  }
}
