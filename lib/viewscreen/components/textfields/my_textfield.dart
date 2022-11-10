import 'package:flutter/material.dart';

import '../../../model/debt.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextInputType textInputType;
  final int flexValue;
  final String? initialValue;

  MyTextField(
      {required this.hintText,
      required this.validator,
      required this.onSaved,
      this.textInputType = TextInputType.text,
      this.flexValue = 1,
      this.initialValue = ""});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(hintText: hintText),
        autocorrect: true,
        validator: validator,
        onSaved: onSaved,
        keyboardType: textInputType,
      ),
    );
  }
}

class DebtTextField extends StatelessWidget {
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextInputType textInputType;
  final bool editable;
  final String initialvalue;

  DebtTextField({
    required this.hintText,
    required this.validator,
    required this.onSaved,
    this.textInputType = TextInputType.text,
    required this.editable,
    required this.initialvalue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: editable,
      style: Theme.of(context).textTheme.headline6,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      initialValue: initialvalue,
      validator: validator,
      onSaved: onSaved,
    );
  }
}
