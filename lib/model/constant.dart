import 'package:flutter/material.dart';

class Constant {
  static const devMode = true;
  static const users = 'Users';
  static const DARKMODE = true;
  static const debts = 'Debts';
  static const purchases = 'Purchases';
  static const List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text('Mortgage'), value: 'Mortgage'),
    DropdownMenuItem(child: Text('Car loan'), value: 'Car loan'),
    DropdownMenuItem(child: Text('Credit Card'), value: 'Credit Card'),
    DropdownMenuItem(child: Text('Medical Bill'), value: 'Medical Bill'),
  ];
}

enum ArgKey {
  user,
  downloadURL,
  filename,
  debtList,
  purchaseList,
  onePhotoMemo,
  userProfile,
  replies,
  comments
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
