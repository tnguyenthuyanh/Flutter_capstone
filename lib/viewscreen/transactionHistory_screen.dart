// ignore_for_file: avoid_print

import 'package:cap_project/model/userTransaction.dart';
import 'package:cap_project/viewscreen/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controller/firestore_controller.dart';
import '../model/constant.dart';
import 'view/view_util.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final List<UserTransaction> transList;
  final User user;

  TransactionHistoryScreen({
    required this.transList,
    required this.user,
  });

  static const routeName = '/transactionHistoryScreen';

  @override
  State<StatefulWidget> createState() {
    return _TransactionHistoryState();
  }
}

class _TransactionHistoryState extends State<TransactionHistoryScreen> {
  late _Controller con;
  var formKey = GlobalKey<FormState>();
  Filter filterValue = Filter.AllUsers;
  SearchOption searchOption = SearchOption.email;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: Column(
        children: [
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: Padding(
          //     padding: const EdgeInsets.all(6.0),
          //     child: Container(
          //       //width: 130,
          //       height: 30,
          //       padding: const EdgeInsets.only(left: 10.0),
          //       decoration: BoxDecoration(
          //         borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          //         border: Border.all(
          //           color: Colors.black,
          //           width: 1,
          //         ),
          //         color: Colors.grey.withAlpha(100),
          //       ),
          //       child: DropdownButtonHideUnderline(
          //         child: DropdownButton<Filter>(
          //           value: filterValue,
          //           onChanged: con.filter,
          //           items: [
          //             for (var c in Filter.values)
          //               DropdownMenuItem<Filter>(
          //                 child: Text(
          //                   c.toString().split('.')[1].replaceFirst('_', ' '),
          //                   style: TextStyle(
          //                     fontSize: 11,
          //                   ),
          //                 ),
          //                 value: c,
          //               ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
            child: con.transList.isEmpty
                ? Text(
                    'No Transaction found!',
                    style: Theme.of(context).textTheme.headline6,
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    padding: EdgeInsets.all(10),
                    itemCount: con.transList.length,
                    itemBuilder: (context, index) {
                      return Material(
                        elevation: 17,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 23, 76, 76),
                            border: Border.all(width: 4, color: Colors.blue),
                          ),
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  con.transList[index].to_email == ""
                                      ? "N/A"
                                      : con.transList[index].to_email,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.amber[600],
                                  ),
                                ),
                                Text(
                                  con.transList[index].type ==
                                          Transfer.Send.toString()
                                      ? '- \$${con.transList[index].amount}'
                                      : '+ \$${con.transList[index].amount}',
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    color: con.transList[index].type ==
                                            Transfer.Send.toString()
                                        ? Color.fromARGB(255, 233, 78, 67)
                                        : Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${con.transList[index].timestamp}'),
                              ],
                            ),
                            // trailing: Container(
                            //   height: 40,
                            //   width: 40,
                            //   // decoration: BoxDecoration(
                            //   //     shape: BoxShape.circle, color: Colors.purple),
                            //   child: Center(
                            //     child: Wrap(
                            //       children: [
                            // Text(
                            //   con.transList[index].type ==
                            //           Transfer.Send.toString()
                            //       ? '+ \$${con.transList[index].amount}'
                            //       : '- \$${con.transList[index].amount}',
                            //   style: TextStyle(
                            //     fontSize: 10,
                            //   ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            onTap: () => ({}),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _Controller {
  late _TransactionHistoryState state;
  late List<UserTransaction> transList;

  _Controller(this.state) {
    transList = state.widget.transList;
  }

  void filter(String? value) {}
}
