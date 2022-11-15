import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final String buttonText;
  final Function()? onPressedCallback;

  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
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
