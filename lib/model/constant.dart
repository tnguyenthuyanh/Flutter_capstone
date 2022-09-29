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
}

enum ArgKey {
  user,
  downloadURL,
  filename,
  debtList,
  onePhotoMemo,
  userProfile,
  replies,
  comments,
  profile,
  userList,
  currentUID,
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
