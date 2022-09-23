import 'package:cap_project/model/debt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/constant.dart';

class DebtScreen extends StatefulWidget {
  const DebtScreen({required this.debtList, required this.user, Key? key})
      : super(key: key);

  final List<Debt> debtList;
  final User user;

  static const routeName = '/debtScreen';

  @override
  State<StatefulWidget> createState() {
    return _DebtState();
  }
}

class _DebtState extends State<DebtScreen> {
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
        title: Text("$email's Debt List"),
      ),
      body: con.debtList.isEmpty
          ? Text(
              'No Debts entered',
              style: Theme.of(context).textTheme.headline6,
            )
          : ListView.builder(
              itemCount: con.debtList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => con.onTap(index),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    elevation: 8.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            con.debtList[index].title,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(con.debtList[index].category),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _Controller {
  _DebtState state;
  late List<Debt> debtList;

  _Controller(this.state) {
    debtList = state.widget.debtList;
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
