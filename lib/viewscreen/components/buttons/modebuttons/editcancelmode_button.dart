import 'package:flutter/material.dart';

class EditCancelModeButton extends StatelessWidget {
  final Function()? onPressedCallback;
  final bool editMode;

  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  EditCancelModeButton({required this.editMode, this.onPressedCallback});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: editMode ? const Icon(Icons.cancel) : const Icon(Icons.edit),
      onPressed: onPressedCallback,
    );
  }
}
