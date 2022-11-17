// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:cap_project/model/userTransaction.dart';
import 'package:cap_project/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../controller/firestore_controller.dart';
import '../model/constant.dart';
import '../model/wallet.dart';

class SeeRequestScreen extends StatefulWidget {
  static const routeName = '/seeRequestScreen';
  final User user;
  final Wallet wallet;
  final UserTransaction request;

  SeeRequestScreen({
    required this.user,
    required this.wallet,
    required this.request,
  });

  @override
  State<StatefulWidget> createState() {
    return _SeeRequestState();
  }
}

class _SeeRequestState extends State<SeeRequestScreen> {
  late _Controller con;

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
        title: const Text('Request Info'),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Wallet balance',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            TextFormField(
              initialValue: '\$${widget.wallet.balance}',
              decoration: InputDecoration(hintText: '${widget.wallet.balance}'),
              enabled: false,
            ),
            const SizedBox(height: 14),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Request From',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            TextFormField(
              initialValue: widget.request.from_email,
              decoration: InputDecoration(hintText: widget.request.from_email),
              enabled: false,
            ),
            const SizedBox(height: 14),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Amount',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            TextFormField(
              initialValue: '\$${widget.request.request_amount.toString()}',
              decoration: InputDecoration(
                  hintText: widget.request.request_amount.toString()),
              enabled: false,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${widget.request.timestamp}',
                style: const TextStyle(color: Colors.green, fontSize: 15),
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                // backgroundColor: const Color.fromARGB(255, 74, 125, 193),
              ),
              child: Container(
                margin: const EdgeInsets.all(12),
                child: const Text('Pay'),
              ),
              onPressed: con.pay,
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  late _SeeRequestState state;
  late double? amount;
  late UserTransaction request;

  _Controller(this.state) {
    request = state.widget.request;
  }

  Future<void> pay() async {
    try {
      if (state.widget.wallet.balance < state.widget.request.request_amount) {
        showSnackBar(
          context: state.context,
          message: 'Insufficient balance',
        );
      } else {
        Map<String, dynamic> updateInfo = {};
        updateInfo[UserTransaction.IS_REQUEST_PAID] = 1;
        updateInfo[UserTransaction.TIMESTAMP] = DateTime.now();
        await FirestoreController.payRequest(
            state.widget.request.docId!, updateInfo);
        await FirestoreController.adjustBalance(
          request.to_uid,
          request.from_uid,
          request.request_amount,
          state.widget.wallet.docId!,
        );
        showSnackBar(
          context: state.context,
          message: 'Request paid',
        );
        Navigator.of(state.context).pop();
      }
    } catch (e) {
      // ignore: avoid_print
      if (Constant.devMode) print('====== error: $e');
      showSnackBar(
        context: state.context,
        message: 'error: $e',
      );
    }
  }
}
