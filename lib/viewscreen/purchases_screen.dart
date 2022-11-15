import 'package:cap_project/View_Model/purchases_viewModal.dart';
import 'package:cap_project/controller/firestore_controller.dart';
import 'package:cap_project/model/user.dart';
import 'package:cap_project/viewscreen/addPurchase_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  late PurchaseViewModal purchaseViewModel;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    email = widget.user.email ?? 'No email';
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    purchaseViewModel = Provider.of<PurchaseViewModal>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("$email's Transaction List"),
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
                    subtitle: Text(widget.userP.purchases[index].note +
                        "\n" +
                        widget.userP.purchases[index].category +
                        "\n" +
                        widget.userP.purchases[index].subCategory),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widget.userP.purchases[index].transactionType == "debt"
                            ? const Icon(
                                Icons.arrow_downward,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.arrow_upward,
                                color: Colors.green,
                              ),
                        IconButton(
                          onPressed: () => con.delete(index),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                    //onLongPress: () => con.delete(index),
                    onTap: () => con.addButton(
                        widget.userP.purchases[index].transactionType,
                        index: index),
                  ),
                );
              },
            ),
      bottomNavigationBar:
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red)),
          onPressed: () {
            con.addButton("debt");
          },
          child: const Text(
            'debt',
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green)),
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

  _Controller(this.state);

  void onTap(int index) {
    selected = index;
    state.render(() {});
  }

  void cancelDelete() {
    selected = -1;
  }

  void addButton(String transType, {int index = -1}) async {
    await Navigator.pushNamed(state.context, AddPurchaseScreen.routeName,
        arguments: {
          ArgKey.purchaseList: state.widget.userP.purchases,
          ArgKey.user: state.widget.user,
          ArgKey.userProfile: state.widget.userP,
          ArgKey.transType: transType,
          ArgKey.selected: index,
        });
    state.render(() {}); //rerender the screen
  }

  void delete(int selected) async {
    Purchase test = state.widget.userP.purchases[selected];
    UserProfile testing = state.widget.userP;
    state.widget.userP.purchases.removeAt(selected);
    await FirestoreController.deleteTransaction(test, testing);
    state.purchaseViewModel.render();
    // await Navigator.popAndPushNamed(state.context, PurchasesScreen.routeName,
    //     arguments: {
    //       ArgKey.purchaseList: state.widget.userP.purchases,
    //       ArgKey.user: state.widget.user,
    //       ArgKey.userProfile: state.widget.userP,
    //     });
    // state.render(() {});
  }
}
