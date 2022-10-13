import 'package:cap_project/model/fuelcostcalc.dart';
import 'package:cap_project/viewscreen/tools_screen/assets/vehicles.dart';
import 'package:cap_project/viewscreen/tools_screen/view/fuelcost_widgets.dart';
import 'package:cap_project/viewscreen/tools_screen/view/popup_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../controller/firestore_controller.dart';

class FuelCostEstimatorScreen extends StatefulWidget {
  static const routeName = '/fuelCostEstimatorScreen';

  const FuelCostEstimatorScreen({required this.user, Key? key}) : super(key: key);
  final User user;

  @override
  State<StatefulWidget> createState() {
    return _FuelCostEstimatorState();
  }
}

class _FuelCostEstimatorState extends State<FuelCostEstimatorScreen> {
  late _Controller con;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isSwitched = false;
  List<Vehicle> vehicleCSVDatabase = <Vehicle>[];
  List<Vehicle> savedPersonalVehicle = <Vehicle>[];
  List<int> days = <int>[];

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    // final vehicleCSVDatabase = Vehicle.getVehicleDatabase();
    // vehicleCSVDatabase.then((value) => print(value.isNotEmpty));
    for (int i = 1; i <= 31; i++) {
      days.add(i);
    }
    con.numOfCommutingDays = days.first;
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Fuel Cost Estimator"),
          // actions: [

          // ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.grey.shade700,
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("Average Daily Commute Distance (miles)"),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "0.0",
                          ),
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          validator: (value) {
                            return FuelCostCalc.validateAverageDailyDistance(value);
                          },
                          onChanged: (value) => {formKey.currentState!.validate()},
                          onSaved: (value) {
                            con.saveAverageDailyDistance(value);
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                      color: Colors.grey.shade900.withAlpha(90),
                      padding: const EdgeInsets.fromLTRB(30, 15, 30, 10),
                      child: Row(
                        children: [
                          Text("Commute Days Per Month: "),
                          SizedBox(width: 20),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton<int>(
                                  menuMaxHeight: MediaQuery.of(context).size.width * 0.6,
                                  value: con.numOfCommutingDays,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.white),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.cyan,
                                  ),
                                  items: days.map<DropdownMenuItem<int>>((int value) {
                                    return DropdownMenuItem<int>(
                                      value: value,
                                      child: Text(value.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (int? value) {
                                    setState(() {
                                      con.numOfCommutingDays = value!;
                                    });
                                  },
                                ))),
                          ),
                        ],
                      )),
                  Container(
                    color: con.cityDriveOverHighway <= 50
                        ? Colors.green.shade900
                            .withAlpha(100 - (con.cityDriveOverHighway * 2).toInt())
                        : Colors.cyan.shade900
                            .withAlpha((con.cityDriveOverHighway - 50).toInt()),
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_city),
                            SizedBox(width: 20),
                            Text("Estimated City Drive / Highway Drive"),
                            SizedBox(width: 20),
                            Icon(Icons.edit_road),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                                padding: EdgeInsets.all(3),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.cyan,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                    con.cityDriveOverHighway.round().toString() + "%")),
                            Expanded(
                              flex: 5,
                              child: SliderTheme(
                                data: SliderThemeData(
                                  valueIndicatorColor: Colors.grey.shade700,
                                  trackShape: RectangularSliderTrackShape(),
                                ),
                                child: Slider(
                                  activeColor: Colors.cyan,
                                  inactiveColor: Colors.green,
                                  thumbColor: Colors.yellow.shade800,
                                  min: 0.0,
                                  max: 100.0,
                                  divisions: 100,
                                  label: con.cityDriveOverHighway.round().toString() +
                                      " / " +
                                      ((100 - con.cityDriveOverHighway)
                                          .round()
                                          .toString()),
                                  value: con.cityDriveOverHighway,
                                  onChanged: (value) {
                                    setState(() {
                                      con.cityDriveOverHighway = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.all(3),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                    ((100 - con.cityDriveOverHighway).round().toString() +
                                        "%"))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey.shade900,
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SwitchListTile(
                          secondary: isSwitched
                              ? Icon(
                                  Icons.speed,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.directions_car,
                                  color: Colors.cyan.shade600,
                                ),
                          value: isSwitched,
                          title: isSwitched
                              ? Column(
                                  children: [
                                    Text(
                                      "Pick Your Vehicle",
                                      style: TextStyle(
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Enter Fuel Efficency",
                                      style: TextStyle(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Text(
                                      "Pick Your Vehicle",
                                      style: TextStyle(
                                        color: Colors.cyan.shade600,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Enter Fuel Efficency",
                                      style: TextStyle(
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                              // print(isSwitched);
                            });
                          },
                          activeColor: Colors.green,
                          inactiveThumbColor: Colors.cyan.shade600,
                          inactiveTrackColor: Colors.cyan.shade900,
                        ),
                        SizedBox(height: 10),
                        isSwitched
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.location_city),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "City Mpg",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: SliderTheme(
                                          data: SliderThemeData(
                                            valueIndicatorColor: Colors.grey.shade700,
                                            trackShape: RectangularSliderTrackShape(),
                                          ),
                                          child: Slider(
                                            thumbColor: con.cityMpg <= 15
                                                ? Colors.red
                                                : con.cityMpg <= 30
                                                    ? Colors.yellow.shade800
                                                    : Colors.green,
                                            activeColor: con.cityMpg <= 15
                                                ? Colors.red
                                                : con.cityMpg <= 30
                                                    ? Colors.yellow.shade800
                                                    : Colors.green,
                                            min: 1,
                                            max: 100,
                                            divisions: 99,
                                            label: con.cityMpg.round().toString(),
                                            value: con.cityMpg,
                                            onChanged: (value) {
                                              setState(() {
                                                con.cityMpg = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      Container(
                                          padding: EdgeInsets.all(3),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: con.cityMpg <= 15
                                                  ? Colors.red
                                                  : con.cityMpg <= 30
                                                      ? Colors.yellow.shade800
                                                      : Colors.green,
                                              borderRadius: BorderRadius.circular(5)),
                                          child: SizedBox(
                                              width: 25,
                                              child: Center(
                                                  child: Text(
                                                      con.cityMpg.round().toString())))),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.edit_road),
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            "Hwy Mpg",
                                            style: TextStyle(fontSize: 10),
                                          )),
                                      Expanded(
                                        flex: 8,
                                        child: SliderTheme(
                                          data: SliderThemeData(
                                            valueIndicatorColor: Colors.grey.shade700,
                                            trackShape: RectangularSliderTrackShape(),
                                          ),
                                          child: Slider(
                                            thumbColor: con.highwayMpg <= 15
                                                ? Colors.red
                                                : con.highwayMpg <= 30
                                                    ? Colors.yellow.shade800
                                                    : Colors.green,
                                            activeColor: con.highwayMpg <= 15
                                                ? Colors.red
                                                : con.highwayMpg <= 30
                                                    ? Colors.yellow.shade800
                                                    : Colors.green,
                                            min: 1,
                                            max: 100,
                                            divisions: 99,
                                            label: con.highwayMpg.round().toString(),
                                            value: con.highwayMpg,
                                            onChanged: (value) {
                                              setState(() {
                                                con.highwayMpg = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      Container(
                                          padding: EdgeInsets.all(3),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: con.highwayMpg <= 15
                                                  ? Colors.red
                                                  : con.highwayMpg <= 30
                                                      ? Colors.yellow.shade800
                                                      : Colors.green,
                                              borderRadius: BorderRadius.circular(5)),
                                          child: SizedBox(
                                              width: 25,
                                              child: Center(
                                                  child: Text(con.highwayMpg
                                                      .round()
                                                      .toString())))),
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Container(
                                    color: Colors.grey.shade800.withAlpha(90),
                                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: DropdownButtonHideUnderline(
                                        child: savedPersonalVehicle.isNotEmpty
                                            ? DropdownButton<Vehicle>(
                                                value: con.pickedVehicle,
                                                icon: const Icon(Icons.arrow_drop_down),
                                                elevation: 16,
                                                style:
                                                    const TextStyle(color: Colors.white),
                                                underline: Container(
                                                  height: 2,
                                                  color: Colors.cyan,
                                                ),
                                                items: savedPersonalVehicle
                                                    .map<DropdownMenuItem<Vehicle>>(
                                                        (Vehicle value) {
                                                  return DropdownMenuItem<Vehicle>(
                                                    value: value,
                                                    child: Text(value.year.toString() +
                                                        " " +
                                                        value.make.toString() +
                                                        " " +
                                                        value.model.toString()),
                                                  );
                                                }).toList(),
                                                onChanged: (Vehicle? value) {
                                                  setState(() {
                                                    con.pickedVehicle = value!;
                                                  });
                                                },
                                              )
                                            : DropdownButton<String>(
                                                value: "",
                                                icon: const Icon(Icons.arrow_drop_down),
                                                elevation: 16,
                                                style:
                                                    const TextStyle(color: Colors.white),
                                                underline: Container(
                                                  height: 2,
                                                  color: Colors.cyan,
                                                ),
                                                items: [
                                                  DropdownMenuItem<String>(
                                                    value: "",
                                                    child: Text(
                                                        "Manage Your Vehicles . . ."),
                                                  )
                                                ],
                                                onChanged: (value) {
                                                  con.showManageVehicles(context);
                                                },
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(height: 10),
                        Container(
                          color: Colors.grey.shade800.withAlpha(90),
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.local_gas_station),
                                  SizedBox(width: 10),
                                  Text("Fuel Price (\$/gal)"),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: SliderTheme(
                                      data: SliderThemeData(
                                        trackShape: RectangularSliderTrackShape(),
                                      ),
                                      child: Slider(
                                        min: 0.01,
                                        max: 15,
                                        label:
                                            con.fuelPrice.toStringAsFixed(2).toString(),
                                        value: con.fuelPrice,
                                        onChanged: (value) {
                                          setState(() {
                                            con.fuelPrice = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Text("\$ " +
                                          con.fuelPrice.toStringAsFixed(2).toString() +
                                          "/gal")),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.3,
                        20, MediaQuery.of(context).size.width * 0.3, 20),
                    child: Card(
                      color: Colors.green.shade900,
                      child: InkWell(
                        splashColor: Colors.red.shade500.withAlpha(50),
                        onTap: () {
                          con.estimate(context);
                        },
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Estimate "),
                              const Icon(Icons.sync),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _FuelCostEstimatorState state;
  _Controller(this.state);
  double averageDailyDistance = 0;
  int numOfCommutingDays = 1;
  double cityDriveOverHighway = 50;
  double cityMpg = 1;
  double highwayMpg = 1;
  double combinedMpg = 0;
  double fuelPrice = 0.01;

  late Vehicle pickedVehicle;
  FuelCostCalc fuelCostCalc = FuelCostCalc();

  static const animationTransitionDelay = 500;

  void saveAverageDailyDistance(String? value) {
    averageDailyDistance = double.parse(value!).abs();
  }

  void saveFuelCostCalc(BuildContext context) async {
    PopupDialog.circularProgressStart(context);
    try {
      String id = await FirestoreController.saveFuelCostCalc(fuelCostCalc);
      fuelCostCalc.docId = id;
      // state.fccList.insert(0, fuelCostCalc);
      state.setState(() {
        averageDailyDistance = 0;
        numOfCommutingDays = 1;
        cityDriveOverHighway = 50;
        cityMpg = 1;
        highwayMpg = 1;
        combinedMpg = 0;
        fuelPrice = 0.01;
      });
      state.formKey.currentState!.reset();
      PopupDialog.circularProgressStop(context);
      Navigator.pop(context, true);
      PopupDialog.info(context: context, title: "YAY!", content: 'Saved! =)');
    } catch (e) {
      PopupDialog.circularProgressStop(context);
      PopupDialog.info(
        context: context,
        title: "Save failed",
        content: '$e',
      );
    }
  }

  void estimate(BuildContext context) {
    if (!state.formKey.currentState!.validate()) return;
    state.formKey.currentState!.save();

    fuelCostCalc.averageDailyDistance = averageDailyDistance;
    fuelCostCalc.numOfCommutingDays = numOfCommutingDays;
    fuelCostCalc.timestamp = DateTime.now();
    fuelCostCalc.createdBy = state.widget.user.email;
    fuelCostCalc.cityMpg = cityMpg.toInt();
    fuelCostCalc.highwayMpg = highwayMpg.toInt();
    fuelCostCalc.cityOverHighway = cityDriveOverHighway.toInt();
    fuelCostCalc.combinedMpg = Vehicle.getCombinedMPG(highwayMpg, cityMpg).toInt();
    fuelCostCalc.fuelPrice = fuelPrice;

    fuelCostCalc.estimate();
    PopupDialog.statefulPopUp(
        context: context,
        title: "Estimated Result",
        animationTransitionDelay: animationTransitionDelay,
        widgetList: showEstimatedResult(context));
  }

  List<Widget> showEstimatedResult(BuildContext context) {
    return <Widget>[
      FuelCostWidgets.resultContentsContainer(
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(
            children: [
              FuelCostWidgets.resultContent(context, "Avg. Daily Distance:",
                  fuelCostCalc.averageDailyDistance.toString() + " miles", 10),
              FuelCostWidgets.resultContent(context, "Commute Per Month:",
                  fuelCostCalc.numOfCommutingDays.toString() + " day(s)", 10),
            ],
          ),
        ),
      ),
      FuelCostWidgets.resultContentsContainer(
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(
            children: [
              FuelCostWidgets.resultContent(
                  context, "City Mpg:", fuelCostCalc.cityMpg.toString(), 10),
              FuelCostWidgets.resultContent(
                  context, "Highway Mpg:", fuelCostCalc.highwayMpg.toString(), 10),
              FuelCostWidgets.resultContent(
                  context, "Combined Mpg:", fuelCostCalc.combinedMpg.toString(), 10),
            ],
          ),
        ),
      ),
      FuelCostWidgets.resultContentsContainer(SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: FuelCostWidgets.resultContent(context, "Fuel Price:",
            "\$" + fuelCostCalc.fuelPrice!.toStringAsFixed(2).toString() + "/gal", 10),
      )),
      FuelCostWidgets.resultContentsContainer(
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(
            children: [
              FuelCostWidgets.resultContent(
                  context,
                  "Lowest Fuel Cost:",
                  "\$" +
                      fuelCostCalc.lowestEstimatedCost!.toStringAsFixed(2).toString() +
                      "/mo",
                  10),
              FuelCostWidgets.resultContent(
                  context,
                  "Highest Fuel Cost:",
                  "\$" +
                      fuelCostCalc.highestEstimateCost!.toStringAsFixed(2).toString() +
                      "/mo",
                  10),
            ],
          ),
        ),
      ),
      Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          color: Colors.cyan.shade500.withAlpha(90),
          child: InkWell(
            splashColor: Colors.red.shade500.withAlpha(50),
            onTap: () => saveFuelCostCalc(context),
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Save "),
                  SizedBox(width: 5),
                  Icon(Icons.cloud_upload),
                ],
              ),
            ),
          ),
        ),
      ),
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        color: Colors.red.shade900.withAlpha(90),
        child: InkWell(
          splashColor: Colors.red.shade500.withAlpha(50),
          onTap: () => Navigator.of(context).pop(),
          child: SizedBox(
            child: Icon(Icons.close),
          ),
        ),
      ),
    ];
  }

  void showManageVehicles(BuildContext context) {
    PopupDialog.statefulPopUp(
        context: context,
        title: "Manage Your Vehicles",
        animationTransitionDelay: animationTransitionDelay,
        widgetList: manageVehicleWidget(context));
  }

  List<Widget> manageVehicleWidget(BuildContext context) {
    return <Widget>[
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        color: Colors.cyan.shade900.withAlpha(90),
        child: InkWell(
          splashColor: Colors.red.shade500.withAlpha(50),
          onTap: () => Navigator.of(context).pop(),
          child: SizedBox(
            child: Icon(Icons.arrow_back),
          ),
        ),
      ),
    ];
  }
}
