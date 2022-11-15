// ignore_for_file: constant_identifier_names

class FuelCostCalc {
  String? docId;
  String? createdBy;
  DateTime? timestamp;
  double? averageDailyDistance;
  int? numOfCommutingDays;
  int? cityOverHighway;
  int? cityMpg;
  int? highwayMpg;
  int? combinedMpg;
  double? fuelPrice;

  double? lowestEstimatedCost;
  double? highestEstimateCost;

  FuelCostCalc({
    this.docId,
    this.createdBy,
    this.timestamp,
    this.averageDailyDistance,
    this.numOfCommutingDays,
    this.cityOverHighway,
    this.cityMpg,
    this.highwayMpg,
    this.combinedMpg,
    this.fuelPrice,
    this.lowestEstimatedCost,
    this.highestEstimateCost,
  });

  static const CREATED_BY = 'createdBy';
  static const TIMESTAMP = 'timestamp';
  static const AVERAGE_DAILY_DISTANCE = 'avgDailyDistance';
  static const NUM_OF_COMMUTING_DAYS = 'numOfCommutingDays';
  static const CITY_OVER_HIGHWAY = 'cityOverHighway';
  static const CITY_MPG = 'cityMpg';
  static const HIGHWAY_MPG = 'highwayMpg';
  static const COMBINED_MPG = 'combinedMpg';
  static const FUEL_PRICE = 'fuelPrice';
  static const LOWEST_ESTIMATED_COST = 'lowestEstimatedCost';
  static const HIGHEST_ESTIMATED_COST = 'highestEstimatedCost';

  // serialization
  Map<String, dynamic> toFirestoreDoc() {
    return {
      CREATED_BY: createdBy,
      TIMESTAMP: timestamp,
      AVERAGE_DAILY_DISTANCE: averageDailyDistance,
      NUM_OF_COMMUTING_DAYS: numOfCommutingDays,
      CITY_OVER_HIGHWAY: cityOverHighway,
      CITY_MPG: cityMpg,
      HIGHWAY_MPG: highwayMpg,
      COMBINED_MPG: combinedMpg,
      FUEL_PRICE: fuelPrice,
      LOWEST_ESTIMATED_COST: lowestEstimatedCost,
      HIGHEST_ESTIMATED_COST: highestEstimateCost,
    };
  }

  //deserialization
  static FuelCostCalc fromFirestoreDoc(
      {required String docId, required Map<String, dynamic> doc}) {
    return FuelCostCalc(
      docId: docId,
      createdBy: doc[CREATED_BY],
      timestamp: doc[TIMESTAMP] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
              doc[TIMESTAMP].millisecondsSinceEpoch),
      averageDailyDistance: doc[AVERAGE_DAILY_DISTANCE],
      numOfCommutingDays: doc[NUM_OF_COMMUTING_DAYS],
      cityOverHighway: doc[CITY_OVER_HIGHWAY],
      cityMpg: doc[CITY_MPG],
      highwayMpg: doc[HIGHWAY_MPG],
      combinedMpg: doc[COMBINED_MPG],
      fuelPrice: doc[FUEL_PRICE],
      lowestEstimatedCost: doc[LOWEST_ESTIMATED_COST],
      highestEstimateCost: doc[HIGHEST_ESTIMATED_COST],
    );
  }

  static String? validateAverageDailyDistance(String? value) {
    if (double.tryParse(value!) == null || double.parse(value) == 0) {
      return 'Insert a number';
    }
    return null;
  }

  void estimate() {
    // numOfDays * ((dailyMiles/combinedMpg) * fuelPrice)
    double combinedMpgResult = numOfCommutingDays! *
        ((averageDailyDistance! / combinedMpg!) * fuelPrice!);

    // numOfCommutingDays * (((dailyMiles * cityOverHighway)/cityMpg + (dailyMiles * (100-cityOverHighway))/highwayMpg) * fuelPrice)
    // number of commuting days * ((gal of fuel needed for city drive + gal of fuel needed for highway drive) * fuelPrice)
    double galOfFuelForCity =
        (averageDailyDistance! * cityOverHighway! / 100) / cityMpg!;

    double galOfFuelForHighway =
        (averageDailyDistance! * (1 - cityOverHighway! / 100)) / highwayMpg!;

    double customedMpgResult = numOfCommutingDays! *
        ((galOfFuelForCity + galOfFuelForHighway) * fuelPrice!);
    if (cityOverHighway! > 55) {
      lowestEstimatedCost = combinedMpgResult;
      highestEstimateCost = customedMpgResult;
    } else if (cityOverHighway! < 55) {
      lowestEstimatedCost = customedMpgResult;
      highestEstimateCost = combinedMpgResult;
    } else {
      lowestEstimatedCost = highestEstimateCost = combinedMpgResult;
    }
  }
}
