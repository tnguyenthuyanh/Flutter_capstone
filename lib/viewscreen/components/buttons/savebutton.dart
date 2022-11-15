import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SaveButton extends StatelessWidget {
  final Function()? onPressedCallback;
  double? size;

  // ignore: use_key_in_widget_constructors
  SaveButton({
    required this.onPressedCallback,
    double this.size = 180,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      child: IconButton(
          icon: const Icon(Icons.save), onPressed: onPressedCallback),
    );
  }
}
