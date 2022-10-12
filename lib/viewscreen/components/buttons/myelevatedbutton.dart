import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyElevatedButton extends StatelessWidget {
  final String buttonText;
  final Function()? onPressedCallback;

  MyElevatedButton({required this.buttonText, required this.onPressedCallback});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressedCallback,
      child: Text(
        buttonText,
        style: Theme.of(context).textTheme.button,
      ),
    );
  }
}
