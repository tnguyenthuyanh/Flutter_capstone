import 'package:cap_project/viewscreen/components/buttons/myelevatedbutton.dart';
import 'package:flutter/widgets.dart';

class MySizedButton extends StatelessWidget {
  final String buttonText;
  final Function()? onPressedCallback;
  double? size;

  MySizedButton(
      {required this.buttonText,
      required this.onPressedCallback,
      double this.size = 180});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      child: MyElevatedButton(
          buttonText: buttonText, onPressedCallback: onPressedCallback),
    );
  }
}
