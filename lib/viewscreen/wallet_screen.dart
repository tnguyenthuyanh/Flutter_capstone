import 'package:cap_project/model/user.dart' as usr;
import 'package:cap_project/viewscreen/transferMoney_screen.dart';
import 'package:cap_project/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../controller/firestore_controller.dart';
import '../model/constant.dart';

class WalletScreen extends StatefulWidget {
  static const routeName = '/walletScreen';
  final User user;
  final usr.UserInfo profile;
  // final int numberOfPhotos;

  WalletScreen({
    required this.user,
    required this.profile,
  });

  @override
  State<StatefulWidget> createState() {
    return _WalletState();
  }
}

class _WalletState extends State<WalletScreen> {
  late _Controller con;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
        title: Text('Wallet'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Colors.black,
                    Colors.blueAccent,
                  ])),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 300.0,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.profile.email,
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 110.0, vertical: 5.0),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.green[50],
                        elevation: 7.0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 22.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "Current Balance",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 19.0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "\$5000",
                                      style: TextStyle(
                                        fontSize: 27.0,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 40,
                        width: 110,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 184, 145, 158),
                            Color.fromARGB(255, 104, 87, 176)
                          ]),
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        ),
                        child: ElevatedButton(
                          onPressed: con.addMoney,
                          child: Text('Add Money',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.amber)),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              shadowColor: Colors.transparent),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.45,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Colors.blueAccent,
                    Colors.grey,
                  ])),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      color: Colors.yellow,
                      height: 30.0, // space betwen top or bottom item
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 40,
                          width: 110,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            gradient: LinearGradient(colors: [
                              Colors.green,
                              Color.fromARGB(255, 3, 65, 5),
                            ]),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                          ),
                          child: ElevatedButton(
                            onPressed: con.send,
                            child: Text('Send',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.transparent,
                                shadowColor: Colors.transparent),
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 110,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            gradient: LinearGradient(colors: [
                              Colors.blue,
                              Color.fromARGB(255, 12, 22, 131)
                            ]),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                          ),
                          child: ElevatedButton(
                            onPressed: con.request,
                            child: Text('Request',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.transparent,
                                shadowColor: Colors.transparent),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.yellow,
                      height: 30.0, // space betwen top or bottom item
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  late _WalletState state;
  _Controller(this.state);

  void addMoney() async {}
  void send() async {
    try {
      usr.UserInfo profile =
          await FirestoreController.getProfile(uid: state.widget.user.uid);
      await Navigator.pushNamed(state.context, TransferMoneyScreen.routeName,
          arguments: {
            ArgKey.profile: profile,
          });
      // close the drawer
      Navigator.of(state.context).pop();
    } catch (e) {
      if (Constant.devMode) print('====== TransferMoneyScreen error: $e');
      showSnackBar(
        context: state.context,
        message: 'Failed to get TransferMoneyScreen: $e',
      );
    }
  }

  void request() async {}
}
