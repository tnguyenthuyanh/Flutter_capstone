import 'dart:collection';
import 'package:cap_project/viewscreen/components/texts/emptycontenttext.dart';
import 'package:cap_project/viewscreen/components/texts/titletext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../View_Model/account_data.dart';
import '../../View_Model/accountlistmode_data.dart';
import '../../model/account.dart';
import '../../model/constant.dart';
import '../components/buttons/modebuttons/deletecancel_button.dart';
import 'addaccount_screen.dart';

class AccountsScreen extends StatefulWidget {
  static const routeName = '/accountsScreen';
  static const _screenName = "Accounts";

  const AccountsScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _AccountState();
}

class _AccountState extends State<AccountsScreen> {
  late _Controller _con;

  @override
  void initState() {
    super.initState();
    _con = _Controller(this);
    Provider.of<AccountData>(context).currentMode = ListMode.view; 
  }

  void render(fn) {
    setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountData>(
      builder: (context, accounts, child){
      return WillPopScope(
        onWillPop: _con.onPopScope,
        child: Scaffold(
          //        APPBAR      --------------------------------------------------
          appBar: AppBar(
            title: TitleText(title: AccountsScreen._screenName),
            actions: [
              //              DELETE/CANCEL & SAVE BUTTONS   ---------------------------
          DeleteCancelModeButton(
            mode: accounts.currentMode,
            onPressedCallback: _con.onDeleteButtonPressed,
          ),
          if (accounts.currentMode == ListMode.delete)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _con.onConfirmButtonPressed,
            ),
            ],
          ),
          // Add FloatingActionButton
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: _con.onAddButtonPressed,
          ),
          //        BODY      --------------------------------------------------
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Consumer<AccountData>(
              builder: (context, accounts, child) {
                //no accounts - display a text with the message
                if (accounts.list.isEmpty) {
                  return EmptyContentText(message: "No Accounts");
                } else {
                  return Column(
                    children: <Widget>[
                      Expanded(
                        child:
                            // Account list
                            ListView.builder(
                          itemCount: accounts.list.length,
                          itemBuilder: (BuildContext context, int index) {
                            // get the budget at the selected index
                            Account _temp = accounts.list[index];

                            return AccountListViewTile(
                              currentMode: accounts.currentMode,
                              account: _temp,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  final _AccountState _state;
  _Controller(this._state);

  // button events
  //--------------------------------------------------------------------------
  Future<void> onAddButtonPressed() async {
    if (getCurrentMode() == ListMode.delete) {
      setCurrentMode(ListMode.view);
    }

    await Navigator.pushNamed(_state.context, AddAccountScreen.routeName);
    _state.render(() {});
  }

  // enter delete selection mode
  void onDeleteModeButtonPressed() {
    // if mode is already delete, set mode to view
    if (getCurrentMode() == ListMode.delete) {
      setCurrentMode(ListMode.view);
      Provider.of<AccountData>(_state.context).cancelDeletion();
    } else {
      setCurrentMode(ListMode.delete);
    }
  }

  // // unstage any accounts selected for deletion and set mode to view
  void onDeleteButtonPressed() {
    // if mode is delete then cancel, else if mode is view then set for delete
    if(Provider.of<AccountData>(_state.context, listen: false).currentMode == ListMode.view){
      Provider.of<AccountData>(_state.context, listen: false).currentMode == ListMode.delete;
      return;
    }

    Provider.of<AccountData>(_state.context, listen: false).cancelDeletion();
    setCurrentMode(ListMode.view);
  }

  void onConfirmButtonPressed() {
    // delete staged budgets and set mode to view
    Provider.of<AccountData>(_state.context, listen: false).confirmDeletion();
    setCurrentMode(ListMode.view);
  }

  // if back arrow is pressed
  Future<bool> onPopScope() {
    Provider.of<AccountData>(_state.context).cancelDeletion();

    Navigator.pop(_state.context);
    // TODO: fix this
    throw "I don't know what happened";
  }
  //--------------------------------------------------------------------------

  // Mode methods
  //--------------------------------------------------------------------------
  ListMode getCurrentMode() {
    return Provider.of<AccountData>(_state.context, listen: false)
        .currentMode;
  }

  void setCurrentMode(ListMode mode) {
    Provider.of<AccountData>(_state.context, listen: false).currentMode =
        mode;
  }
  // //-----------------------------------------------------------------------

  // UnmodifiableListView<Account> getAccountListView() {
  //   if (Provider.of<AccountData>(_state.context).accounts != null) {
  //     return Provider.of<AccountData>(_state.context).accounts;
  //   } else {
  //     return UnmodifiableListView(<Account>[]);
  //   }
  // }
  //---------------------------------------------------------------------------
}
