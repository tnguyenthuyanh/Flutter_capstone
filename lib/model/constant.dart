import 'package:flutter/material.dart';

class Constant {
  static const devMode = true;
  static const users = 'Users';
  static const USERPROFILE_COLLECTION = 'userProfile';
  static const USERFRIENDS_COLLECTION = 'UserFriends';
  static const WALLET_COLLECTION = 'VirtualWallet';
  static const TRANSACTION_COLLECTION = 'UserTransactions';
  static const DARKMODE = true;
  static const debts = 'Debts';
  static const budgets = 'budgets';
  static const accounts = 'accounts';
  static const categories = 'categories';
  static const purchases = 'Purchases';
  static const savings = "Savings";
  static const plans = 'Plans';
  static const savedTipCalc = 'SavedTipCalc';
  static const savedFuelCostCalc = 'SavedFuelCostCalc';

  static const List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text('Mortgage'), value: 'Mortgage'),
    DropdownMenuItem(child: Text('Car loan'), value: 'Car loan'),
    DropdownMenuItem(child: Text('Credit Card'), value: 'Credit Card'),
    DropdownMenuItem(child: Text('Medical Bill'), value: 'Medical Bill'),
  ];
}

enum ArgKey {
  user,
  filename,
  debtList,
  purchaseList,
  savings,
  planList,
  onePhotoMemo,
  userProfile,
  replies,
  comments,
  profile,
  userList,
  currentUID,
  singleDebt,
  isFriendAdded,
  wallet,
  transactionList
}

enum Filter {
  MyFriends,
  AllUsers,
  FriendRequest,
}

enum SearchOption {
  email,
  name,
}

enum Transfer {
  Send,
  Request,
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

// view mode for lists
enum ListMode { view, add, delete, edit }

enum BudgetListMode { view, add, delete, edit }

class ValidationError {
  static String requiredFieldError = 'Required';
  static String budgetTitleLengthError = 'Minimum 4 characters';
  static String titleLengthError = 'Title can not be empty';
  static String dateOutOfBoundsError = 'Date Due not valid';
  static String amountLengthError = 'Amount can not be empty';
  static String monthTooLongError = 'Must be 1 or 2 characters';
  static String monthValueError = 'Must be a valid number for a month';
  static String notANumberError = 'Must be a number';
  static String yearLengthError = 'Must be 4 characters';
  static String yearValueError = 'Must be a valid number for a year';
  static String yearRangeError = 'Really? You a budget THAT year?';
  static String invalidEmailLengthError = 'Email must be at least 8 characters';
  static String invalidEmailFormatError = 'Invalid Email Address';
}
