import 'package:cap_project/viewscreen/components/textfields/my_textfield.dart';
import 'package:flutter/material.dart';

import '../../../View_Model/validator.dart';

class AccountTextFields {
  static Widget titleTextField({
    required onSaved,
  }) {
    return MyTextField(
      hintText: "Title",
      validator: Validator.validateAccountTitle,
      onSaved: onSaved,
    );
  }
}
