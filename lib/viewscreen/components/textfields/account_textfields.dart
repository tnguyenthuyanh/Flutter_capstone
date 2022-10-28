import 'package:cap_project/viewscreen/components/textfields/my_textfield.dart';
import 'package:cap_project/viewscreen/components/texts/detail_text.dart';
import 'package:flutter/material.dart';

import '../../../View_Model/validator.dart';
import '../../../model/account.dart';
import '../../../model/constant.dart';

class AccountTextFields {
  static Widget titleTextField({
    required onSaved,
    required mode,
    Account? account,
  }) {
    if (mode == true) {
      return MyTextField(
        hintText: "Title",
        validator: Validator.validateAccountTitle,
        onSaved: onSaved,
      );
    } else {
      return DetailText(
        labelText: "Title",
        text: account!.title,
      );
    }
  }

  static Widget accountNumberTextField({
    required onSaved,
    required mode,
    Account? account,
  }) {
    if (mode == true) {
      return MyTextField(
        hintText: "Account Number",
        validator: Validator.validateAccountNumber,
        onSaved: onSaved,
      );
    } else {
      return DetailText(
        labelText: "Account Number",
        text: account!.accountNumber,
      );
    }
  }

  static Widget rateTextField({
    required onSaved,
    required mode,
    Account? account,
  }) {
    if (mode == true) {
      return MyTextField(
        hintText: "Rate",
        validator: Validator.validateAccountRate,
        onSaved: onSaved,
      );
    } else {
      return DetailText(
        labelText: "Rate",
        text: account!.rate.toString(),
      );
    }
  }

  static Widget websiteTextField({
    required onSaved,
    required mode,
    Account? account,
  }) {
    if (mode == true) {
      return MyTextField(
        hintText: "Website",
        validator: Validator.validateWebsite,
        onSaved: onSaved,
      );
    } else {
      return DetailText(
        labelText: "Website",
        text: account!.website,
      );
    }
  }
}
