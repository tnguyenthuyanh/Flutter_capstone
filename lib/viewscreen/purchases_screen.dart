import 'package:cap_project/model/custom_icons_icons.dart';
import 'package:cap_project/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/constant.dart';
import 'addDebt_screen.dart';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen(
      {required this.userP,
      required this.user,
      //required this.purchaseList,
      Key? key})
      : super(key: key);

  //final List<Purchases> purchaseList;
  final User user;
  final UserProfile userP;

  static const routeName = '/transactionScreen';

  @override
  State<StatefulWidget> createState() {
    return _PurchasesState();
  }
}

class _PurchasesState extends State<PurchasesScreen> {
  late _Controller con;
  late String email;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    email = widget.user.email ?? 'No email';
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$email's Transaction List"),
      ),
      body: const Text('Body'),
    );
  }
}

class _Controller {
  _PurchasesState state;
  late List<dynamic> purchaseList;

  _Controller(this.state) {
    List<dynamic> purchaseList = state.widget.userP.debts;
  }

  void addButton() async {
    await Navigator.pushNamed(state.context, AddDebtScreen.routeName,
        arguments: {
          ArgKey.purchaseList: state.widget.userP.debts,
          ArgKey.user: state.widget.user,
          ArgKey.userProfile: state.widget.userP,
        });
    state.render(() {}); //rerender the screen
  }

  void onTap(int index) async {}
  /*await Navigator.pushNamed(state.context, FollowerViewScreen.routeName,
        arguments: {
          ArgKey.user: state.widget.user,
          ArgKey.onePhotoMemo: photoMemoList[index],
        });
    state.render(() {});
  }*/
}
