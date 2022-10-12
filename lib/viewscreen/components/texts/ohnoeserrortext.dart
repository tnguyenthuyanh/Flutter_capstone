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
