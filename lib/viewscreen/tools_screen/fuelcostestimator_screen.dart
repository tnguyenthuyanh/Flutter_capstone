import 'package:cap_project/model/fuelcostcalc.dart';
import 'package:cap_project/viewscreen/tools_screen/assets/vehicles.dart';
import 'package:cap_project/viewscreen/tools_screen/view/fuelcost_widgets.dart';
import 'package:cap_project/viewscreen/tools_screen/view/popup_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../controller/firestore_controller.dart';

class FuelCostEstimatorScreen extends StatefulWidget {
  static const routeName = '/fuelCostEstimatorScreen';

  const FuelCostEstimatorScreen({required this.user, Key? key})
      : super(key: key);
  final User user;

  @override
  State<StatefulWidget> createState() {
    return _FuelCostEstimatorState();
  }
}

class _FuelCostEstimatorState extends State<FuelCostEstimatorScreen> {
  late _Controller con;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isSwitched = true;
  List<Vehicle> vehicleCSVDatabase = <Vehicle>[];
  List<Vehicle> savedPersonalVehicle = <Vehicle>[];
  List<FuelCostCalc> savedFCC = <FuelCostCalc>[];
  List<int> days = <int>[];

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    for (int i = 1; i <= 31; i++) {
      days.add(i);
    }
    con.numOfCommutingDays = days.first;
    getSavedFCC();
    getSavedPersonalVehicle();
  }

  void getSavedPersonalVehicle() async {
    savedPersonalVehicle = await FirestoreController.getSavedVehicleList(
        email: widget.user.email.toString());
  }

  void getSavedFCC() async {
    savedFCC = await FirestoreController.getSavedFuelCostCalcList(
        email: widget.user.email.toString());
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Fuel Cost Estimator"),
          actions: [
            PopupMenuButton<String>(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              icon: const Icon(Icons.list),
              color: Colors.cyan.shade800,
              onSelected: con.setSelected,
              itemBuilder: (context) => <PopupMenuEntry<String>>[
                FuelCostWidgets.popupMenuItem(
                  FuelCostWidgets.BTN_LIST_OF_SAVED_FCC,
                  Icons.cloud,
                  Colors.white,
                ),
                FuelCostWidgets.popupMenuItem(
                  FuelCostWidgets.BTN_MANAGE_VEHICLES,
                  Icons.directions_car_outlined,
                  Colors.white,
                ),
              ],
            ),
          ],
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
                            return FuelCostCalc.validateAverageDailyDistance(
                                value);
                          },
                          onChanged: (value) =>
                              {formKey.currentState!.validate()},
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
                        const Text("Commute Days Per Month: "),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                menuMaxHeight:
                                    MediaQuery.of(context).size.width * 0.6,
                                value: con.numOfCommutingDays,
                                icon: const Icon(Icons.arrow_drop_down),
                                elevation: 16,
                                style: const TextStyle(color: Colors.white),
                                underline: Container(
                                  height: 2,
                                  color: Colors.cyan,
                                ),
                                items: days
                                    .map<DropdownMenuItem<int>>((int value) {
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
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: con.cityDriveOverHighway <= 50
                        ? Colors.green.shade900.withAlpha(
                            100 - (con.cityDriveOverHighway * 2).toInt())
                        : Colors.cyan.shade900
                            .withAlpha((con.cityDriveOverHighway - 50).toInt()),
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.location_city),
                            SizedBox(width: 20),
                            Text("Estimated City Drive / Highway Drive"),
                            SizedBox(width: 20),
                            Icon(Icons.edit_road),
                          ],
                        ),
                        FuelCostWidgets.cityHwySlider(
                          con.cityDriveOverHighway,
                          Colors.cyan,
                          Colors.green,
                          Colors.yellow.shade800,
                          Colors.grey.shade700,
                          0.0,
                          100.0,
                          100,
                          (value) {
                            setState(() {
                              con.cityDriveOverHighway = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  FuelCostWidgets.switchListTile(
                    Colors.grey.shade900,
                    isSwitched,
                    Icons.speed,
                    Icons.directions_car,
                    Colors.green,
                    Colors.cyan.shade600,
                    Colors.grey.shade800,
                    "Pick Your Vehicle",
                    "Enter Fuel Efficency",
                    Colors.green,
                    Colors.cyan.shade600,
                    Colors.cyan.shade900,
                    (value) {
                      setState(() {
                        isSwitched = value;
                        con.pickedVehicle = Vehicle();
                        con.cityMpg = 1;
                        con.highwayMpg = 1;
                      });
                    },
                    // widget 1
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FuelCostWidgets.sliderForMpg(
                          Icons.location_city,
                          "City Mpg",
                          1,
                          100,
                          99,
                          con.cityMpg,
                          (value) {
                            setState(() {
                              con.cityMpg = value;
                            });
                          },
                        ),
                        FuelCostWidgets.sliderForMpg(
                          Icons.edit_road,
                          "Hwy Mpg",
                          1,
                          100,
                          99,
                          con.highwayMpg,
                          (value) {
                            setState(() {
                              con.highwayMpg = value;
                            });
                          },
                        ),
                      ],
                    ),
                    // widget 2
                    Container(
                      color: Colors.grey.shade800.withAlpha(90),
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                      child: savedPersonalVehicle.isNotEmpty
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                        flex: 2, child: Text("Browse: ... ")),
                                    Expanded(
                                      flex: 4,
                                      child: SizedBox(
                                          // width: MediaQuery.of(context).size.width,
                                          width: 200,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<Vehicle>(
                                              isExpanded: true,
                                              icon: const Icon(
                                                  Icons.arrow_drop_down),
                                              elevation: 16,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              underline: Container(
                                                height: 2,
                                                color: Colors.cyan,
                                              ),
                                              items: savedPersonalVehicle.map<
                                                      DropdownMenuItem<
                                                          Vehicle>>(
                                                  (Vehicle value) {
                                                return DropdownMenuItem<
                                                    Vehicle>(
                                                  value: value,
                                                  child: Text(value.year
                                                          .toString() +
                                                      " " +
                                                      value.make.toString() +
                                                      " " +
                                                      value.model.toString()),
                                                );
                                              }).toList(),
                                              onChanged: (Vehicle? value) {
                                                setState(() {
                                                  con.pickedVehicle = value!;
                                                  con.highwayMpg = value
                                                      .highwayMpg!
                                                      .toDouble();
                                                  con.cityMpg =
                                                      value.cityMpg!.toDouble();
                                                });
                                              },
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    (con.pickedVehicle.year != null)
                                        ? Text(
                                            con.pickedVehicle.year.toString() +
                                                " " +
                                                con.pickedVehicle.make
                                                    .toString() +
                                                " " +
                                                con.pickedVehicle.model
                                                    .toString(),
                                            style:
                                                const TextStyle(fontSize: 14),
                                          )
                                        : const Text("Default",
                                            style: TextStyle(fontSize: 14)),
                                    Text(
                                      con.cityMpg.toInt().toString() +
                                          " City - " +
                                          con.highwayMpg.toInt().toString() +
                                          " Hwy ",
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Card(
                              color: Colors.green.shade900,
                              child: InkWell(
                                splashColor: Colors.red.shade500.withAlpha(50),
                                onTap: () {
                                  con.showManageVehicles(context);
                                },
                                child: SizedBox(
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text("Manage Your Vehicles "),
                                      Icon(Icons.directions_car_outlined),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  Container(
                    color: Colors.grey.shade800.withAlpha(90),
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
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
                                data: const SliderThemeData(
                                  trackShape: RectangularSliderTrackShape(),
                                ),
                                child: Slider(
                                  min: 0.01,
                                  max: 15,
                                  label: con.fuelPrice
                                      .toStringAsFixed(2)
                                      .toString(),
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
                                    con.fuelPrice
                                        .toStringAsFixed(2)
                                        .toString() +
                                    "/gal")),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.3,
                        20,
                        MediaQuery.of(context).size.width * 0.3,
                        20),
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
                            children: const [
                              Text("Estimate "),
                              Icon(Icons.sync),
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

  late Vehicle pickedVehicle = Vehicle();
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
      state.savedFCC.insert(0, fuelCostCalc);
      // ignore: invalid_use_of_protected_member
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

  void setSelected(String val) async {
    if (val == FuelCostWidgets.BTN_LIST_OF_SAVED_FCC) {
      showSavedFCC(state.context);
    } else if (val == FuelCostWidgets.BTN_MANAGE_VEHICLES) {
      showManageVehicles(state.context);
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

    fuelCostCalc.combinedMpg = state.isSwitched
        ? Vehicle.getCombinedMPG(highwayMpg, cityMpg).toInt()
        : pickedVehicle.combinedMpg;
    fuelCostCalc.fuelPrice = fuelPrice;

    fuelCostCalc.estimate();
    PopupDialog.statefulPopUpWithoutSetState(
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
              FuelCostWidgets.resultContent(context, "Highway Mpg:",
                  fuelCostCalc.highwayMpg.toString(), 10),
              FuelCostWidgets.resultContent(context, "Combined Mpg:",
                  fuelCostCalc.combinedMpg.toString(), 10),
            ],
          ),
        ),
      ),
      FuelCostWidgets.resultContentsContainer(SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: FuelCostWidgets.resultContent(
            context,
            "Fuel Price:",
            "\$" +
                fuelCostCalc.fuelPrice!.toStringAsFixed(2).toString() +
                "/gal",
            10),
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
                      fuelCostCalc.lowestEstimatedCost!
                          .toStringAsFixed(2)
                          .toString() +
                      "/mo",
                  10),
              FuelCostWidgets.resultContent(
                  context,
                  "Highest Fuel Cost:",
                  "\$" +
                      fuelCostCalc.highestEstimateCost!
                          .toStringAsFixed(2)
                          .toString() +
                      "/mo",
                  10),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Center(
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
      ),
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        color: Colors.red.shade900.withAlpha(90),
        child: InkWell(
          splashColor: Colors.red.shade500.withAlpha(50),
          onTap: () => Navigator.of(context).pop(),
          child: const SizedBox(
            child: Icon(Icons.close),
          ),
        ),
      ),
    ];
  }

  void showSavedFCC(BuildContext context) {
    PopupDialog.statefulPopUpWithSetState(
        context: context,
        animationTransitionDelay: animationTransitionDelay,
        widget: savedFCC(context));
  }

  StatefulBuilder savedFCC(BuildContext context) {
    return StatefulBuilder(
      builder: ((context, setState) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
          title: const Center(child: Text("Saved Fuel Cost Est.")),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.height * 0.9,
              margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.savedFCC.length,
                itemBuilder: (context, index) {
                  return FuelCostWidgets.resultContentsContainer(
                    ListTile(
                      // Each item
                      title: Text('Date: ' +
                          state.savedFCC[index].timestamp!
                              .toString()
                              .substring(5, 7) + // mm
                          state.savedFCC[index].timestamp!
                              .toString()
                              .substring(7, 10) + // dd
                          '-' +
                          state.savedFCC[index].timestamp!
                              .toString()
                              .substring(0, 4)),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            FuelCostWidgets.resultContent(
                                context,
                                "Avg. Daily Distance:",
                                state.savedFCC[index].averageDailyDistance!
                                        .toString() +
                                    " miles",
                                10),
                            FuelCostWidgets.resultContent(
                                context,
                                "Commute Per Month:",
                                state.savedFCC[index].numOfCommutingDays!
                                        .toString() +
                                    " day(s)",
                                10),
                            FuelCostWidgets.resultContent(context, "City Mpg:",
                                state.savedFCC[index].cityMpg!.toString(), 10),
                            FuelCostWidgets.resultContent(
                                context,
                                "Highway Mpg:",
                                state.savedFCC[index].highwayMpg!.toString(),
                                10),
                            FuelCostWidgets.resultContent(
                                context,
                                "Combined Mpg:",
                                state.savedFCC[index].combinedMpg!.toString(),
                                10),
                            FuelCostWidgets.resultContent(
                                context,
                                "Fuel Price:",
                                "\$" +
                                    state.savedFCC[index].fuelPrice!
                                        .toStringAsFixed(2)
                                        .toString() +
                                    "/gal",
                                10),
                            FuelCostWidgets.resultContent(
                                context,
                                "Lowest Fuel Cost:",
                                "\$" +
                                    state.savedFCC[index].lowestEstimatedCost!
                                        .toStringAsFixed(2)
                                        .toString() +
                                    "/mo",
                                10),
                            FuelCostWidgets.resultContent(
                                context,
                                "Highest Fuel Cost:",
                                "\$" +
                                    state.savedFCC[index].highestEstimateCost!
                                        .toStringAsFixed(2)
                                        .toString() +
                                    "/mo",
                                10),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              color: Colors.red.shade900.withAlpha(90),
                              child: InkWell(
                                splashColor: Colors.red.shade500.withAlpha(50),
                                onTap: () {
                                  deleteSavedFCC(context,
                                      state.savedFCC[index].docId.toString());
                                  setState(
                                      () => state.savedFCC.removeAt(index));
                                },
                                child: const SizedBox(
                                  child: Icon(Icons.close),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ]),
        );
      }),
    );
  }

  void deleteSavedFCC(BuildContext context, String docId) async {
    PopupDialog.circularProgressStart(context);
    try {
      await FirestoreController.deleteSavedFCCItem(docId);
      PopupDialog.circularProgressStop(context);
      PopupDialog.info(
          context: context, title: "YAY!", content: "Removed successfully!");
    } catch (e) {
      PopupDialog.info(
          context: context,
          title: "Oops!",
          content: "Something went wrong! $e");
    }
  }

  void showManageVehicles(BuildContext context) async {
    if (state.vehicleCSVDatabase.isEmpty) {
      state.vehicleCSVDatabase = await Vehicle.getVehicleDatabase();
    }
    PopupDialog.statefulPopUpWithSetState(
        context: context,
        animationTransitionDelay: animationTransitionDelay,
        widget: manageVehicleWidget(context));
  }

  StatefulBuilder manageVehicleWidget(BuildContext context) {
    final Color yearColor = Colors.green.shade800.withAlpha(50);
    final Color makeColor = Colors.yellow.shade800.withAlpha(50);
    final Color modelColor = Colors.blue.shade800.withAlpha(50);
    var yearSet = <int>[];
    var makeSet = <String>[];
    var modelSet = <Vehicle>[];

    late String selectedYear = "";
    late String selectedMake = "";
    late String selectedModel = "";
    late Vehicle picked;

    for (var vehicle in state.vehicleCSVDatabase) {
      yearSet.add(int.parse(vehicle.year!));
      makeSet.add(vehicle.make!);
    }
    yearSet = ({...yearSet}.toList());
    yearSet.sort((b, a) => a.compareTo(b));
    makeSet = ({...makeSet}).toList();
    makeSet.sort((a, b) => a.compareTo(b));

    return StatefulBuilder(
      builder: ((context, setState) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          title: const Center(child: Text("Manage Your Vehicles")),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FuelCostWidgets.resultContentsContainer(
                Column(
                  children: [
                    FuelCostWidgets.pickStringDropDownMenu(
                      context,
                      yearColor,
                      "Year",
                      selectedYear,
                      yearSet.map((e) => e.toString()).toList(),
                      (value) {
                        setState(
                          () {
                            selectedModel = "";
                            modelSet.clear();
                            selectedYear = value.toString();
                            if (selectedYear != "" && selectedMake != "") {
                              modelSet =
                                  getModelSet(selectedYear, selectedMake);
                            }
                          },
                        );
                      },
                    ),
                    FuelCostWidgets.pickStringDropDownMenu(
                      context,
                      makeColor,
                      "Make",
                      selectedMake,
                      makeSet,
                      (value) {
                        setState(
                          () {
                            selectedModel = "";
                            picked = Vehicle();
                            modelSet.clear();
                            selectedMake = value.toString();
                            if (selectedYear != "" && selectedMake != "") {
                              modelSet =
                                  getModelSet(selectedYear, selectedMake);
                            }
                          },
                        );
                      },
                    ),
                    if (modelSet.isNotEmpty)
                      FuelCostWidgets.pickStringDropDownMenu(
                        context,
                        modelColor,
                        "Model",
                        selectedModel,
                        modelSet
                            .map((e) =>
                                e.model.toString() +
                                "," +
                                e.displ.toString() +
                                "," +
                                e.drive.toString() +
                                "," +
                                e.trany.toString())
                            .toList(),
                        (value) {
                          setState(() {
                            selectedModel = value.toString();
                            var el = selectedModel.split(",");
                            for (var vehicle in modelSet) {
                              if (vehicle.model == el[0] &&
                                  vehicle.displ == el[1] &&
                                  vehicle.drive == el[2] &&
                                  vehicle.trany == el[3]) {
                                picked = vehicle;
                              }
                            }
                          });
                        },
                      ),
                  ],
                ),
              ),
              FuelCostWidgets.resultContentsContainer(
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (selectedYear != "")
                          FuelCostWidgets.vehicleLabel(
                              yearColor, selectedYear, 10),
                        if (selectedMake != "")
                          FuelCostWidgets.vehicleLabel(
                              makeColor, selectedMake, 10),
                        if (selectedModel != "")
                          FuelCostWidgets.vehicleLabel(
                              modelColor, selectedModel, 10),
                      ],
                    ),
                    selectedModel != ""
                        ? Center(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              color: Colors.cyan.shade500.withAlpha(90),
                              child: InkWell(
                                splashColor: Colors.red.shade500.withAlpha(50),
                                onTap: () {
                                  saveVehicle(context, picked);
                                  setState(() {
                                    state.savedPersonalVehicle
                                        .insert(0, picked);
                                    selectedYear = "";
                                    selectedMake = "";
                                    selectedModel = "";
                                    modelSet.clear();
                                  });
                                },
                                child: SizedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text("Add "),
                                      SizedBox(width: 5),
                                      Icon(Icons.plus_one),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              if (state.savedPersonalVehicle.isNotEmpty)
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.savedPersonalVehicle.length,
                    itemBuilder: (context, index) {
                      return FuelCostWidgets.resultContentsContainer(
                        ListTile(
                          // Each item
                          title: Text(state.savedPersonalVehicle[index].year
                                  .toString() +
                              " " +
                              state.savedPersonalVehicle[index].make
                                  .toString()),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                FuelCostWidgets.resultContent(
                                    context,
                                    "Model: ",
                                    state.savedPersonalVehicle[index].model
                                        .toString(),
                                    10),
                                FuelCostWidgets.resultContent(
                                    context,
                                    "Displacement: ",
                                    state.savedPersonalVehicle[index].displ
                                        .toString(),
                                    10),
                                FuelCostWidgets.resultContent(
                                    context,
                                    "Transmission: ",
                                    state.savedPersonalVehicle[index].trany
                                        .toString(),
                                    10),
                                FuelCostWidgets.resultContent(
                                    context,
                                    "Drive: ",
                                    state.savedPersonalVehicle[index].drive
                                        .toString(),
                                    10),
                                FuelCostWidgets.resultContent(
                                    context,
                                    "Fuel Type: ",
                                    state.savedPersonalVehicle[index].fuelType
                                        .toString(),
                                    10),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40.0),
                                  ),
                                  color: Colors.red.shade900.withAlpha(90),
                                  child: InkWell(
                                    splashColor:
                                        Colors.red.shade500.withAlpha(50),
                                    onTap: () {
                                      setState(() {
                                        deleteSavedVehicle(
                                            context,
                                            state.savedPersonalVehicle[index]
                                                .docId
                                                .toString());
                                        state.savedPersonalVehicle
                                            .removeAt(index);
                                      });
                                    },
                                    child: const SizedBox(
                                      child: Icon(Icons.close),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                color: Colors.cyan.shade900.withAlpha(90),
                child: InkWell(
                  splashColor: Colors.red.shade500.withAlpha(50),
                  onTap: () => Navigator.of(context).pop(),
                  child: const SizedBox(
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  List<Vehicle> getModelSet(String selectedYear, String selectedMake) {
    var result = <Vehicle>[];
    for (var vehicle in state.vehicleCSVDatabase) {
      if (vehicle.year == selectedYear && vehicle.make == selectedMake) {
        result.add(vehicle);
      }
    }
    return result;
  }

  void saveVehicle(BuildContext context, Vehicle vehicle) async {
    PopupDialog.circularProgressStart(context);
    try {
      vehicle.createdBy = state.widget.user.email;
      String id = await FirestoreController.saveVehicle(vehicle);
      fuelCostCalc.docId = id;
      // ignore: invalid_use_of_protected_member
      state.setState(() {});
      PopupDialog.circularProgressStop(context);
    } catch (e) {
      PopupDialog.circularProgressStop(context);
      PopupDialog.info(
        context: context,
        title: "Save failed",
        content: '$e',
      );
    }
  }

  void deleteSavedVehicle(BuildContext context, String docId) async {
    try {
      await FirestoreController.deleteSavedVehicle(docId);
      // ignore: invalid_use_of_protected_member
      state.setState(() {
        cityMpg = 1;
        highwayMpg = 1;
        pickedVehicle = Vehicle();
      });
    } catch (e) {
      PopupDialog.info(
          context: context,
          title: "Oops!",
          content: "Something went wrong! $e");
    }
  }
}
