// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class DetailText extends StatelessWidget {
  final String labelText;
  final String text;

  DetailText({required this.labelText, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Text(
            labelText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(text),
        ],
      ),
    );
  }
}
