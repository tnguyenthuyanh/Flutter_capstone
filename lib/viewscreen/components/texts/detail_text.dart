import 'package:flutter/material.dart';

class DetailText extends StatelessWidget {
  final String labelText;
  final String text;

  DetailText({required this.labelText, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Text(
              labelText,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
