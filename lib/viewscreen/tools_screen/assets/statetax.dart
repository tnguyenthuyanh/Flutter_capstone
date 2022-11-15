// ignore_for_file: constant_identifier_names

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class StateTax {
  String? state;
  String? abbreviation;
  double? rate;

  StateTax({
    this.state,
    this.abbreviation,
    this.rate,
  });

  static const STATE = 'state';
  static const ABBREVIATION = 'abbreviation';
  static const RATE = 'rate';

  static Future<List<StateTax>> getStateTaxDatabase() async {
    var stateTaxList = <StateTax>[];
    final _rawData = await rootBundle
        .loadString("lib/viewscreen/tools_screen/assets/statetax_data.csv");
    List<List<dynamic>> _rawList = const CsvToListConverter().convert(_rawData);
    for (var rowData in _rawList) {
      var oneStateTaxRow = StateTax(
        state: rowData[0].toString(),
        abbreviation: rowData[1].toString(),
        rate: rowData[2].toDouble(),
      );
      stateTaxList.add(oneStateTaxRow);
    }
    return stateTaxList;
  }
}
