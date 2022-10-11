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
        actions: con.selected.isEmpty
            ? null
            : [
                IconButton(
                  onPressed: con.deleteTransactions,
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
              'test: ${widget.userP.purchases.length}',
              style: Theme.of(context).textTheme.headline6,
            )
          : ListView.builder(
              itemCount: widget.userP.purchases.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: con.selected.contains(index)
                      ? con.selectedColor
                      : con.unselectedColor,
                  margin: const EdgeInsets.all(17.0),
                  child: ListTile(
                    title: Text(widget.userP.purchases[index].amount),
                    subtitle: Text(widget.userP.purchases[index].note),
                    onLongPress: () => con.onLongPress(index),
                    onTap: () => con.delete(index),
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
  List<int> selected = [];

  final selectedColor = Colors.black12;
  final unselectedColor = Colors.black87;

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

  void onTap(int index) {
    if (selected.isNotEmpty) {
      onLongPress(index);
    } else {}
  }

  void onLongPress(int index) {
    state.render(() {
      if (selected.contains(index)) {
        selected.remove(index);
      } else {
        selected.add(index);
      }
    });
  }

  void deleteTransactions() {
    selected.sort();
    for (int i = selected.length - 1; i >= 0; i--) {
      state.widget.userP.purchases.removeAt(selected[i]);
    }
    state.render(() {
      selected.clear();
    });
  }

  void delete(int index) async {
    Purchase purchase = state.widget.userP.purchases[index];
    await FirestoreController.deleteTransaction(purchase);
  }

  void cancelDelete() {
    state.render(() => selected.clear());
  }
}
