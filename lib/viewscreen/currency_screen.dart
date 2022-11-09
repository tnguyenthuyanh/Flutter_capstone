import 'dart:convert';

import 'package:cap_project/model/convert_repo.dart';
import 'package:cap_project/model/country.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// class CurrencyScreen extends StatefulWidget {
//   static const routeName = '/CurrencyScreen';

//   const CurrencyScreen({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() {
//     return _CurrencyScreen();
//   }
// }

// class _CurrencyScreen extends State<CurrencyScreen> {
//   late _Controller con;
//   String? usdToInr;
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   String? dropValue = null;

//   @override
//   void initState() {
//     //use this as constructor for state
//     super.initState();
//     con = _Controller(this);
//   }

//   void render(fn) => setState(fn);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Currency Exchange'),
//       ),
//       body: Form(
//         key: formKey,
//         child: Container(
//           width: double.infinity,
//           alignment: Alignment.center,
//           margin: const EdgeInsets.all(8.0),
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * .4,
//                 child: TextFormField(
//                   decoration: const InputDecoration(hintText: 'USD'),
//                   autocorrect: true,
//                 ),
//               ),
//               const Divider(
//                 color: Colors.grey,
//                 thickness: 1,
//                 indent: 20,
//                 endIndent: 0,
//               ),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * .4,
//                 child: TextFormField(
//                   decoration:
//                       const InputDecoration(hintText: 'Foreign Currency'),
//                   autocorrect: true,
//                 ),
//               ),
//               DropdownButton(
//                 value: dropValue,
//                 items: Constant.currencies,
//                 onChanged: con.saveCurrency,
//                 hint: const Text('Select a currency'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _Controller {
//   _CurrencyScreen state;

//   _Controller(this.state);

//   void saveCurrency(String? value) {}

//   void convert() async {
//     Currency myCurrency = await CurrencyConverter.getMyCurrency();
//     var usdConvert = await CurrencyConverter.convert(
//       from: Currency.usd,
//       to: myCurrency,
//       amount: 1,
//     );
//     setState(() {
//       usdToInr = usdConvert.toString();
//     });
//   }
// }

class CurrencyScreen extends StatefulWidget {
  static const routeName = '/CurrencyScreen';

  const CurrencyScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CurrencyScreen();
  }
}

class _CurrencyScreen extends State<CurrencyScreen> {
  Country fromCountry = data[0];
  Country toCountry = data[1];
  double value = 1;
  late Future<double> resFuture;

  @override
  void initState() {
    super.initState();
    _requestConvert();
  }

  _requestConvert() {
    resFuture = ConvertRepo().convert(
        fromCurr: fromCountry.currency,
        toCurr: toCountry.currency,
        value: value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Currency Conversion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            _currencyView(
              fromCountry,
              false,
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: 10,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ]),
                  child: const Center(
                    child: Text(
                      '=',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState((() {
                      final temp = fromCountry;
                      fromCountry = toCountry;
                      toCountry = temp;
                      _requestConvert();
                    }));
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Image.network(
                            'https://www.kindpng.com/picc/m/459-4595699_reverse-logo-hd-png-download.png',
                            height: 30,
                          ),
                          const Text(
                            'Swap Currency',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            FutureBuilder<double>(
              future: resFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _currencyView(toCountry, true, res: snapshot.data);
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  Container _currencyView(Country country, bool isDestination, {double? res}) {
    return Container(
      height: 200.0,
      decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              spreadRadius: 10,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => _buildMenuCurrency(isDestination),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      country.urlFlag!,
                      height: 100,
                      width: 100,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          country.name!,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          country.currency!,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            TextFormField(
              key: isDestination ? Key(res.toString()) : Key(value.toString()),
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              initialValue: isDestination ? res.toString() : value.toString(),
              onFieldSubmitted: (val) {
                if (double.parse(val) != null) {
                  setState((() {
                    value = double.parse(val);
                    _requestConvert();
                  }));
                }
              },
              decoration: InputDecoration(
                hintText: '0.0',
                enabled: isDestination,
                suffixIcon: Text(
                  country.currency!,
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
                suffixIconConstraints:
                    BoxConstraints(minWidth: 0, minHeight: 0),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildMenuCurrency(bool isDestination) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: _buildListActions(onPressed: (index) {
          setState(() {
            isDestination ? toCountry = data[index] : fromCountry = data[index];
            _requestConvert();
            Navigator.pop(context);
          });
        }),
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  List<Widget> _buildListActions({Function(int)? onPressed}) {
    var listActions = <Widget>[];
    for (var i = 0; i < data.length; i++) {
      listActions.add(CupertinoActionSheetAction(
          onPressed: () => onPressed!(i), child: Text(data[i].name!)));
    }
    return listActions;
  }
}//end
