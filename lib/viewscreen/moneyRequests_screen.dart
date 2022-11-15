// ignore_for_file: avoid_print, file_names, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:cap_project/model/userTransaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controller/firestore_controller.dart';
import '../model/constant.dart';
import '../model/wallet.dart';
import 'seeRequest_screen.dart';
import 'view/view_util.dart';

class MoneyRequestsScreen extends StatefulWidget {
  final List<UserTransaction> requestList;
  final User user;
  final Wallet wallet;

  MoneyRequestsScreen({
    required this.requestList,
    required this.user,
    required this.wallet,
  });

  static const routeName = '/moneyRequestsScreen';

  @override
  State<StatefulWidget> createState() {
    return _MoneyRequestsState();
  }
}

class _MoneyRequestsState extends State<MoneyRequestsScreen> {
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
        title: const Text('Requests'),
      ),
      body: Column(
        children: [
          Expanded(
            child: con.requestList.isEmpty
                ? Text(
                    'No request at the moment!',
                    style: Theme.of(context).textTheme.headline6,
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    padding: const EdgeInsets.all(10),
                    itemCount: con.requestList.length,
                    itemBuilder: (context, index) {
                      return Material(
                        elevation: 17,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 97, 86, 3),
                            border: Border.all(width: 4, color: Colors.green),
                          ),
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  con.requestList[index].from_email == ""
                                      ? "N/A"
                                      : con.requestList[index].from_email,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.amber[600],
                                  ),
                                ),
                                Text(
                                  '\$${con.requestList[index].request_amount}',
                                  style: const TextStyle(
                                    fontSize: 19.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${con.requestList[index].timestamp}'),
                              ],
                            ),
                            onTap: () => con.payRequest(index),
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
  late _MoneyRequestsState state;
  late List<UserTransaction> requestList;

  _Controller(this.state) {
    requestList = state.widget.requestList;
  }

  void payRequest(int index) async {
    try {
      await Navigator.pushNamed(state.context, SeeRequestScreen.routeName,
          arguments: {
            ArgKey.request: requestList[index],
            ArgKey.user: state.widget.user,
            ArgKey.wallet: state.widget.wallet,
          });
      List<UserTransaction> newRequestList =
          await FirestoreController.getMoneyRequest(
              currentUID: state.widget.user.uid);

      Wallet newWallet =
          await FirestoreController.getWallet(state.widget.user.uid);

      state.render(() {
        requestList = newRequestList;
        state.widget.wallet.balance = newWallet.balance;
      });
    } catch (e) {
      if (Constant.devMode) print('====== MoneyRequestsScreen error: $e');
      showSnackBar(
        context: state.context,
        message: 'Failed to get MoneyRequestsScreen: $e',
      );
    }
  }
}
