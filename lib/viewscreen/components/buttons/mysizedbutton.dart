import 'package:cap_project/viewscreen/components/buttons/myelevatedbutton.dart';
import 'package:flutter/widgets.dart';

class MySizedButton extends StatelessWidget {
  final String buttonText;
  final Function()? onTapCallback;
  double? size;

  MySizedButton(
      {required this.buttonText,
      required this.onTapCallback,
      double this.size = 180});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      child: MyElevatedButton(
          buttonText: buttonText, onTapCallback: onTapCallback),
    );
  }
}
