import 'package:cap_project/viewscreen/components/buttons/myelevatedbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SaveButton extends StatelessWidget {
  final Function()? onPressedCallback;
  double? size;

  SaveButton({
    required this.onPressedCallback,
    double this.size = 180,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      child: IconButton(icon: Icon(Icons.save), onPressed: onPressedCallback),
    );
  }
}
