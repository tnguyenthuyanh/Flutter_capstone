import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyElevatedButton extends StatelessWidget {
  final String buttonText;
  final Function()? onTapCallback;

  MyElevatedButton({required this.buttonText, required this.onTapCallback});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTapCallback,
      child: Text(
        buttonText,
        style: Theme.of(context).textTheme.button,
      ),
    );
  }
}
