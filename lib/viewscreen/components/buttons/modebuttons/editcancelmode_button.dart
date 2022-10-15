import 'package:flutter/material.dart';

class EditCancelModeButton extends StatelessWidget {
  final Function()? onPressedCallback;
  final bool editMode;

  EditCancelModeButton({required this.editMode, this.onPressedCallback});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: editMode ? Icon(Icons.cancel) : Icon(Icons.edit),
      onPressed: onPressedCallback,
    );
  }
}
