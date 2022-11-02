import 'package:cap_project/controller/firestore_controller.dart';
import 'package:cap_project/model/user.dart';
import 'package:cap_project/viewscreen/addPurchase_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
        actions: con.selected == -1
            ? null
            : [
                IconButton(
                  onPressed: con.delete,
                  icon: const Icon(Icons.delete),
                ),
                IconButton(
                  onPressed: con.cancelDelete,
                  icon: const Icon(Icons.cancel),
                ),
              ],
      ),
      body: widget.userP.purchases.isEmpty
          ? Text(
              'No Transactions',
              style: Theme.of(context).textTheme.headline6,
            )
          : ListView.builder(
              itemCount: widget.userP.purchases.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  // color: con.selected ==
                  //     ? con.selectedColor
                  //     : con.unselectedColor,
                  margin: const EdgeInsets.all(17.0),
                  child: ListTile(
                    title: Text(widget.userP.purchases[index].amount),
                    subtitle: Text(widget.userP.purchases[index].note),
                    //onLongPress: () => con.delete(index),
                    onTap: () => con.onTap(index),
                  ),
                );
              },
            ),
      bottomNavigationBar:
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        ElevatedButton(
          style:  ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
          onPressed: () {
            con.addButton("debt");
          },
          child: const Text(
            'debt',
          ),
        ),
        ElevatedButton(
          style:  ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
          onPressed: () {
            con.addButton("credit");
          },
          child: const Text(
            'credit',
          ),
          
        ),
      ]),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: con.addButton,
      // ),
    );
  }
}

class _Controller {
  _PurchasesState state;
  late List<dynamic> purchaseList;
  int selected = -1;

  final selectedColor = Colors.black12;
  final unselectedColor = Colors.black87;

  _Controller(this.state) {
    List<dynamic> purchaseList = state.widget.userP.purchases;
  }

  void onTap(int index) {
    selected = index;
    state.render(() {});
  }

  void cancelDelete() {
    selected = -1;
  }

  void addButton(String transType) async {
    await Navigator.pushNamed(state.context, AddPurchaseScreen.routeName,
        arguments: {
          ArgKey.purchaseList: state.widget.userP.purchases,
          ArgKey.user: state.widget.user,
          ArgKey.userProfile: state.widget.userP,
          ArgKey.transType: transType,
        });
    state.render(() {}); //rerender the screen
  }

  void delete() async {
    Purchase test = state.widget.userP.purchases[selected];
    UserProfile testing = state.widget.userP;
    await FirestoreController.deleteTransaction(test, testing);
    state.render(() {});
    await Navigator.popAndPushNamed(state.context, PurchasesScreen.routeName,
        arguments: {
          ArgKey.purchaseList: state.widget.userP.purchases,
          ArgKey.user: state.widget.user,
          ArgKey.userProfile: state.widget.userP,
        });
    state.render(() {});
  }
}
