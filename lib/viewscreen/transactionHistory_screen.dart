// ignore_for_file: avoid_print, file_names, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:cap_project/model/userTransaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/constant.dart';

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
        title: const Text('Transaction History'),
      ),
      body: Column(
        children: [
          Expanded(
            child: con.transList.isEmpty
                ? Text(
                    'No Transaction found!',
                    style: Theme.of(context).textTheme.headline6,
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    padding: const EdgeInsets.all(10),
                    itemCount: con.transList.length,
                    itemBuilder: (context, index) {
                      return Material(
                        elevation: 17,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 23, 76, 76),
                            border: Border.all(width: 4, color: Colors.blue),
                          ),
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  con.transList[index].to_uid == widget.user.uid
                                      ? con.transList[index].from_email
                                      : con.transList[index].to_email,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.amber[600],
                                  ),
                                ),
                                Text(
                                  ((con.transList[index].type ==
                                                  Transfer.Send.toString() &&
                                              con.transList[index].from_uid ==
                                                  widget.user.uid) ||
                                          (con.transList[index].type ==
                                                  Transfer.Request.toString() &&
                                              con.transList[index].to_uid ==
                                                  widget.user.uid))
                                      ? '- \$${con.transList[index].amount}'
                                      : '+ \$${con.transList[index].amount}',
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    color: ((con.transList[index].type ==
                                                    Transfer.Send.toString() &&
                                                con.transList[index].from_uid ==
                                                    widget.user.uid) ||
                                            (con.transList[index].type ==
                                                    Transfer.Request
                                                        .toString() &&
                                                con.transList[index].to_uid ==
                                                    widget.user.uid))
                                        ? const Color.fromARGB(255, 233, 78, 67)
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
}
