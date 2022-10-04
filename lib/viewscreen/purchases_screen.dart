import 'package:cap_project/model/user.dart';
import 'package:cap_project/viewscreen/addPurchase_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/constant.dart';
import '../model/purchase.dart';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({
    required this.userP,
    required this.user,
    required this.purchaseList,
    Key? key,
  }) : super(key: key);

  final List<Purchase> purchaseList;
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
      body: widget.userP.purchases.isEmpty
          ? Text(
              'No Transactions entered',
              style: Theme.of(context).textTheme.headline6,
            )
          : ListView.builder(
              itemCount: widget.userP.purchases.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: Colors.black26,
                  margin: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text(widget.userP.purchases[index].amount),
                    subtitle: Text(widget.userP.purchases[index].note),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: con.addButton,
      ),
    );
  }
}

class _Controller {
  _PurchasesState state;
  late List<dynamic> purchaseList;

  _Controller(this.state) {
    List<dynamic> purchaseList = state.widget.userP.purchases;
  }

  void addButton() async {
    await Navigator.pushNamed(state.context, AddPurchaseScreen.routeName,
        arguments: {
          ArgKey.purchaseList: state.widget.userP.purchases,
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
