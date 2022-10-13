import 'package:cap_project/model/constant.dart';
import 'package:flutter/material.dart';

class DeleteCancelModeButton extends StatelessWidget {
  final Function()? onPressedCallback;
  final ListMode mode;

  DeleteCancelModeButton({required this.mode, this.onPressedCallback});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: mode == ListMode.delete ? Icon(Icons.cancel) : Icon(Icons.delete),
      onPressed: onPressedCallback,
    );
  }
}
