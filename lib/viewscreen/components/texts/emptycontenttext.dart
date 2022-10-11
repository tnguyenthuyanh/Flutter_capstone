import 'package:flutter/material.dart';

class EmptyContentText extends StatelessWidget {
  final String message;

  EmptyContentText({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No Budgets to show',
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}
