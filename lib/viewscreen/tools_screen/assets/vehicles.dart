// year,make,model,trany,highway08,city08,comb08,displ,drive,fuelType
// ignore_for_file: constant_identifier_names

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class Vehicle {
  String? docId;
  String? createdBy;

  String? year;
  String? make;
  String? model;
  String? trany;
  int? highwayMpg;
  int? cityMpg;
  int? combinedMpg;
  String? displ;
  String? drive;
  String? fuelType;

  Vehicle({
    this.docId,
    this.createdBy,
    this.year,
    this.make,
    this.model,
    this.trany,
    this.highwayMpg,
    this.cityMpg,
    this.combinedMpg,
    this.displ,
    this.drive,
    this.fuelType,
  }) {}

  static const CREATED_BY = 'createdBy';
  static const YEAR = 'year';
  static const MAKE = 'make';
  static const MODEL = 'model';
  static const TRANY = 'trany';
  static const HIGHWAYMPG = 'highwayMpg';
  static const CITYMPG = 'cityMpg';
  static const COMBINEDMPG = 'combinedMpg';
  static const DISPL = 'displ';
  static const DRIVE = 'drive';
  static const FUELTYPE = 'fuelType';

  // serialization
  Map<String, dynamic> toFirestoreDoc() {
    return {
      CREATED_BY: createdBy,
      YEAR: year,
      MAKE: make,
      MODEL: model,
      TRANY: trany,
      HIGHWAYMPG: highwayMpg,
      CITYMPG: cityMpg,
      COMBINEDMPG: combinedMpg,
      DISPL: displ,
      DRIVE: drive,
      FUELTYPE: fuelType,
    };
  }

  // deserialization
  static Vehicle fromFirestoreDoc(
      {required String docId, required Map<String, dynamic> doc}) {
    return Vehicle(
      docId: docId,
      createdBy: doc[CREATED_BY],
      year: doc[YEAR],
      make: doc[MAKE],
      model: doc[MODEL],
      trany: doc[TRANY],
      highwayMpg: doc[HIGHWAYMPG],
      cityMpg: doc[CITYMPG],
      combinedMpg: doc[COMBINEDMPG],
      displ: doc[DISPL],
      drive: doc[DRIVE],
      fuelType: doc[FUELTYPE],
    );
  }

  static Future<List<Vehicle>> getVehicleDatabase() async {
    var vehicleList = <Vehicle>[];
    final _rawData =
        await rootBundle.loadString("lib/viewscreen/tools_screen/assets/vehicles.csv");
    List<List<dynamic>> _rawList = const CsvToListConverter().convert(_rawData);
    _rawList.forEach((rowData) {
      var oneVehicle = Vehicle(
        year: rowData[0].toString(),
        make: rowData[1].toString(),
        model: rowData[2].toString(),
        trany: rowData[3].toString(),
        highwayMpg: rowData[4].toInt(),
        cityMpg: rowData[5].toInt(),
        combinedMpg: rowData[6].toInt(),
        displ: rowData[7].toString(),
        drive: rowData[8].toString(),
        fuelType: rowData[9].toString(),
      );
      vehicleList.add(oneVehicle);
    });
    return vehicleList;
  }

  static double getCombinedMPG(double highwayMpg, double cityMpg) {
    return (0.45 * highwayMpg + 0.55 * cityMpg);
  }
}
