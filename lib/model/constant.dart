import 'package:flutter/material.dart';

class Constant {
  static const devMode = true;
  static const users = 'Users';
  static const DARKMODE = true;
  static const debts = 'Debts';
  static const List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text('Mortgage'), value: 'Mortgage'),
    DropdownMenuItem(child: Text('Car loan'), value: 'Car loan'),
    DropdownMenuItem(child: Text('Credit Card'), value: 'Credit Card'),
    DropdownMenuItem(child: Text('Medical Bill'), value: 'Medical Bill'),
  ];
  static const USERPROFILE_COLLECTION = 'userProfile';

  static const savedTipCalc = 'SavedTipCalc';
}

enum ArgKey {
  user,
  filename,
  debtList,
  onePhotoMemo,
  userProfile,
  replies,
  comments,
  profile,
  userList,
  currentUID,
  singleDebt
}

List<DropdownMenuItem<String>> menuItems = [
  DropdownMenuItem(child: Text('Mortgage'), value: 'Mortgage'),
  DropdownMenuItem(child: Text('Car loan'), value: 'Car loan'),
  DropdownMenuItem(child: Text('Credit Card'), value: 'Credit Card'),
  DropdownMenuItem(child: Text('Medical Bill'), value: 'Medical Bill'),
];

List<DropdownMenuItem<String>> get dropdownItems {
  return menuItems;
}

// view mode for budget lists
enum BudgetListMode { view, add, delete, edit }

class ValidationError {
  static String requiredFieldError = 'Required';
  static String budgetTitleLengthError = 'Minimum 4 characters';
  static String itemTitleLengthError = 'Title can not be empty';
  static String dateOutOfBoundsError = 'Date Due not valid';
  static String amountLengthError = 'Amount can not be empty';
  static String monthTooLongError = 'Must be 1 or 2 characters';
  static String monthValueError = 'Must be a valid number for a month';
  static String notANumberError = 'Must be a number';
  static String yearLengthError = 'Must be 4 characters';
  static String yearValueError = 'Must be a valid number for a year';
  static String yearRangeError = 'Really? You a budget THAT year?';
  static String pinLengthError = 'PIN must be at least 4 characters';
  static String invalidPINError = 'Invalid PIN. Try again.';
  static String invalidEmailLengthError = 'Email must be at least 8 characters';
  static String invalidEmailFormatError = 'Invalid Email Address';
}
