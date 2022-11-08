import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaycheckWidgets {
  static Widget pickStringDropDownMenu(
    BuildContext context,
    Color color,
    String title,
    String value,
    List<String> setDatabase,
    Function f,
  ) {
    return Container(
      color: color,
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
      child: Row(
        children: [
          Text(title + ": "),
          Expanded(
            flex: 4,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: const Icon(
                  Icons.arrow_drop_down,
                ),
                elevation: 16,
                style: const TextStyle(color: Colors.white),
                underline: Container(
                  height: 2,
                  color: Colors.cyan,
                ),
                items: setDatabase.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        value.toString(),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  f(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget resultContentsContainer(
    Color backgroundColor,
    Widget sample,
  ) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), color: backgroundColor),
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
