import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextInputType textInputType;
  final int flexValue;

  MyTextField({
    required this.hintText,
    required this.validator,
    required this.onSaved,
    this.textInputType = TextInputType.text,
    this.flexValue = 1
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        decoration: InputDecoration(hintText: hintText),
        autocorrect: true,
        validator: validator,
        onSaved: onSaved,
        keyboardType: textInputType,
      ),
    );
  }
}
