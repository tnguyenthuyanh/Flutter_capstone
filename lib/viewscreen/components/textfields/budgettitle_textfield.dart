import 'package:cap_project/viewscreen/components/textfields/my_textfield.dart';
import 'package:flutter/material.dart';

import '../../../View_Model/validator.dart';

class BudgetTitleTextField extends StatelessWidget {
  final void Function(String?)? onSaved;

  BudgetTitleTextField({required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      hintText: "Budget title",
      validator: Validator.validateBudgetTitle,
      onSaved: onSaved,
    );
  }
}
