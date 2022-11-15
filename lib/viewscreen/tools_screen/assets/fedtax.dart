// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class FedTax {
  String? status;
  double? wageThreshold;
  double? baseWithholding;
  double? rateOverThreshold;

  FedTax({
    this.status,
    this.wageThreshold,
    this.baseWithholding,
    this.rateOverThreshold,
  });

  static const STATUS = 'status';
  static const WAGE_THRESHOLD = 'wageThreshold';
  static const BASE_WITHHOLDING = 'baseWithholding';
  static const RATEOVERTHRESHOLD = 'rateOverThreshold';

  static var PAY_PERIOD = [
    PayPeriod('Weekly', 52),
    PayPeriod('Biweekly', 26),
    PayPeriod('Semimonthly', 24),
    PayPeriod('Monthly', 12),
    PayPeriod('Daily', 260),
  ];

  static const DEFAULT_FILING_STATUS = 'Single';
  static const FICA_SSN_RATE = 6.2;
  static const FICA_MEDICARE_RATE = 1.45;

  static Future<List<FedTax>> getFedTaxDatabase() async {
    var fedTaxList = <FedTax>[];
    final _rawData = await rootBundle
        .loadString("lib/viewscreen/tools_screen/assets/fedtax_data.csv");
    List<List<dynamic>> _rawList = const CsvToListConverter().convert(_rawData);
    for (var rowData in _rawList) {
      var oneFedTaxRow = FedTax(
        status: rowData[0].toString(),
        wageThreshold: rowData[1].toDouble(),
        baseWithholding: rowData[2].toDouble(),
        rateOverThreshold: rowData[3].toDouble(),
      );
      fedTaxList.add(oneFedTaxRow);
    }
    return fedTaxList;
  }
}

class PayPeriod {
  String? period;
  int? total;

  PayPeriod(String p, int t) {
    period = p;
    total = t;
  }
}
