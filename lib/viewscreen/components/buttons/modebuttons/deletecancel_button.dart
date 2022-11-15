import 'package:cap_project/model/constant.dart';
import 'package:flutter/material.dart';

class DeleteCancelModeButton extends StatelessWidget {
  final Function()? onPressedCallback;
  final ListMode mode;

  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  DeleteCancelModeButton({required this.mode, this.onPressedCallback});

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print, unnecessary_this
    print(this.mode.toString());

    return IconButton(
      icon: mode == ListMode.delete
          ? const Icon(Icons.cancel)
          : const Icon(Icons.delete),
      onPressed: onPressedCallback,
    );
  }
}
