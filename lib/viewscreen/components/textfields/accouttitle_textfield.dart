import 'package:cap_project/viewscreen/components/textfields/my_textfield.dart';
import 'package:flutter/material.dart';

import '../../../View_Model/validator.dart';

class AccountTitleTextField extends StatelessWidget {
  final void Function(String?)? onSaved;

  AccountTitleTextField({required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      hintText: "Account title",
      validator: Validator.validateAccountTitle,
      onSaved: onSaved,
    );
  }
}
