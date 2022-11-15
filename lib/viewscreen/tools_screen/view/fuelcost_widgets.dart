// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class FuelCostWidgets {
  static const BTN_LIST_OF_SAVED_FCC = "Saved Fuel Cost Est.";
  static const BTN_MANAGE_VEHICLES = "Manage Your Vehicles";

  static Widget resultContentsContainer(Widget sample) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.cyan.shade700),
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: sample,
    );
  }

  static PopupMenuItem<String> popupMenuItem(
    String value,
    IconData icon,
    Color textColor,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            color: textColor,
          ),
          const SizedBox(width: 10.0),
          Text(
            value,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ],
      ),
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

  static Widget sliderForMpg(
    IconData icon,
    String title,
    double minValue,
    double maxValue,
    int divisions,
    double mpgValue,
    Function f,
  ) {
    return Row(
      children: [
        Icon(icon),
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: const TextStyle(fontSize: 10),
          ),
        ),
        Expanded(
          flex: 8,
          child: SliderTheme(
            data: SliderThemeData(
              valueIndicatorColor: Colors.grey.shade700,
              trackShape: const RectangularSliderTrackShape(),
            ),
            child: Slider(
              thumbColor: mpgValue <= 15
                  ? Colors.red
                  : mpgValue <= 30
                      ? Colors.yellow.shade800
                      : Colors.green,
              activeColor: mpgValue <= 15
                  ? Colors.red
                  : mpgValue <= 30
                      ? Colors.yellow.shade800
                      : Colors.green,
              min: minValue,
              max: maxValue,
              divisions: divisions,
              label: mpgValue.round().toString(),
              value: mpgValue,
              onChanged: (value) {
                f(value);
              },
            ),
          ),
        ),
        Container(
            padding: const EdgeInsets.all(3),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: mpgValue <= 15
                    ? Colors.red
                    : mpgValue <= 30
                        ? Colors.yellow.shade800
                        : Colors.green,
                borderRadius: BorderRadius.circular(5)),
            child: SizedBox(
                width: 25,
                child: Center(child: Text(mpgValue.round().toString())))),
      ],
    );
  }

  static Widget pickStringDropDownMenu(
    BuildContext context,
    Color color,
    String title,
    String value,
    List<String> setDatabase,
    Function f,
  ) {
    return Container(
      decoration: BoxDecoration(color: (value != "") ? color : null),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 10),
              ),
              Expanded(
                flex: 1,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
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
                    items: setDatabase
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            value.toString(),
                            style: const TextStyle(fontSize: 10),
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
        ],
      ),
    );
  }

  static Widget vehicleLabel(
    Color color,
    String value,
    double size,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(right: 10),
      child: value.length <= 25
          ? Text(
              value,
              style: TextStyle(fontSize: size),
            )
          : Text(
              value.substring(0, 10) +
                  "..." +
                  value.substring(value.length - 10, value.length),
              style: TextStyle(fontSize: size),
            ),
    );
  }

  static Widget cityHwySlider(
    double value,
    Color activeColor,
    Color inactiveColor,
    Color thumbColor,
    Color indicatorColor,
    double minValue,
    double maxValue,
    int divisions,
    Function f,
  ) {
    return Row(
      children: [
        Container(
            padding: const EdgeInsets.all(3),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: activeColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(value.round().toString() + "%")),
        Expanded(
          flex: 5,
          child: SliderTheme(
            data: SliderThemeData(
              valueIndicatorColor: indicatorColor,
              trackShape: const RectangularSliderTrackShape(),
            ),
            child: Slider(
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              thumbColor: thumbColor,
              min: minValue,
              max: maxValue,
              divisions: divisions,
              label: value.round().toString() +
                  " / " +
                  ((100 - value).round().toString()),
              value: value,
              onChanged: (value) {
                f(value);
              },
            ),
          ),
        ),
        Container(
            padding: const EdgeInsets.all(3),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: inactiveColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(((100 - value).round().toString() + "%"))),
      ],
    );
  }

  static Widget switchListTile(
    Color overallColor,
    bool isSwitched,
    IconData firstIcon,
    IconData secondIcon,
    Color firstColor,
    Color secondColor,
    Color offColor,
    String firstLabel,
    String secondLabel,
    Color activeColor,
    Color inactiveThumbColor,
    Color inactiveTrackColor,
    Function f,
    Widget firstWidget,
    Widget secondWidget,
  ) {
    return Container(
      color: overallColor,
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SwitchListTile(
            secondary: isSwitched
                ? Icon(
                    firstIcon,
                    color: firstColor,
                  )
                : Icon(
                    secondIcon,
                    color: secondColor,
                  ),
            value: isSwitched,
            title: isSwitched
                ? Column(
                    children: [
                      Text(
                        firstLabel,
                        style: TextStyle(
                          color: offColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        secondLabel,
                        style: TextStyle(
                          color: firstColor,
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Text(
                        firstLabel,
                        style: TextStyle(
                          color: secondColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        secondLabel,
                        style: TextStyle(
                          color: offColor,
                        ),
                      ),
                    ],
                  ),
            onChanged: (value) {
              f(value);
            },
            activeColor: activeColor,
            inactiveThumbColor: inactiveThumbColor,
            inactiveTrackColor: inactiveTrackColor,
          ),
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: isSwitched ? firstWidget : secondWidget,
          ),
        ],
      ),
    );
  }
}
