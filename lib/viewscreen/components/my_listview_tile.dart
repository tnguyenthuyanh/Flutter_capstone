// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class MyListViewTile extends StatelessWidget {
  final String middleValue;
  final String rightValue;
  final Color backgroundColor;
  final bool isSelected;
  final Function()? onTapCallback;
  final Color _textColor = Colors.black;
  final double _rightSize = 24.0;

  const MyListViewTile({
    required this.middleValue,
    required this.rightValue,
    required this.backgroundColor,
    this.isSelected = false,
    this.onTapCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(8),
      ),
      // List Tile
      child: ListTile(
        onTap: onTapCallback,
        // title text
        title: Text(
          middleValue,
          style: TextStyle(color: _textColor),
        ),
        // amount for item, year for budget
        trailing: Text(
          rightValue,
          style: TextStyle(
            fontSize: _rightSize,
            fontWeight: FontWeight.bold,
            color: _textColor,
          ),
        ),
      ),
    );
  }
}
