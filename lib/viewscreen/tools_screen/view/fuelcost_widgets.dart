import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FuelCostWidgets {
  static Widget resultContentsContainer(Widget sample) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.cyan.shade700),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: sample,
    );
  }

  static Widget resultContent(
      BuildContext context, String title, String result, double fontSize) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                result,
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
