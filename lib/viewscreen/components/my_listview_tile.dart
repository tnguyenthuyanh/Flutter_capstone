import 'package:flutter/material.dart';

class MyListViewTile extends StatelessWidget {
  // final String leftValue;
  final String middleValue;
  final String rightValue;
  final Color backgroundColor;
  final bool isSelected;
  final Function()? onTapCallback;
  final Color _textColor = Colors.black;
  final double _leftSize = 38.0;
  final double _middleSize = 24.0;
  final double _rightSize = 24.0;

  const MyListViewTile({
    // required this.leftValue,
    required this.middleValue,
    required this.rightValue,
    required this.backgroundColor,
    this.isSelected = false,
    this.onTapCallback
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        gradient: LinearGradient(
          colors: [Colors.white, backgroundColor],
          begin: Alignment.centerRight,
          end: Alignment.center,
        ),
        border: Border.all(style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(8),
      ),
      // List Tile
      child: ListTile(
        onTap: onTapCallback,
        // onTap: () {print('not implemented yet');},
        // day Text
        // leading: Text(
        //   leftValue,
        //   style: TextStyle(
        //     fontSize: _leftSize,
        //     fontWeight: FontWeight.bold,
        //     color: _textColor,
        //   ),
        // ),
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
