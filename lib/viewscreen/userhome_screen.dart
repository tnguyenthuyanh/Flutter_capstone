import 'package:cap_project/model/custom_icons_icons.dart';
import 'package:cap_project/model/debt.dart';
import 'package:cap_project/model/user.dart';
import 'package:cap_project/viewscreen/budgets_screen.dart';
import 'package:cap_project/viewscreen/debt_screen.dart';
import 'package:cap_project/model/user.dart' as usr;
import 'package:cap_project/viewscreen/profile_screen.dart';
import 'package:cap_project/viewscreen/purchases_screen.dart';
import 'package:cap_project/viewscreen/userlist_screen.dart';
import 'package:cap_project/viewscreen/tools_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controller/auth_controller.dart';
import '../controller/firestore_controller.dart';
import '../model/constant.dart';
import 'view/view_util.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({required this.user, Key? key}) : super(key: key);

  final User user;

  static const routeName = '/userHomeScreen';

  @override
  State<StatefulWidget> createState() {
    return _UserHomeState();
  }
}

class _UserHomeState extends State<UserHomeScreen> {
  late _Controller con;
  late UserProfile userP;
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
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
          appBar: AppBar(
            title: Text("$email's feed"),
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: const Icon(
                    Icons.person,
                    size: 70.0,
                  ),
                  accountName: const Text('no profile'),
                  accountEmail: Text(email),
                ),
                ListTile(
                  leading: const Icon(CustomIcons.money_check),
                  title: const Text('Debts'),
                  onTap: con.debtPage,
                ),
                ListTile(
                  leading: const Icon(Icons.payments),
                  title: const Text('Transactions'),
                  onTap: con.purchasePage,
                ),
                ListTile(
                  leading: const Icon(Icons.local_atm),
                  title: const Text('Budgets'),
                  onTap: con.budgetsPage,
                ),
                ListTile(
                  leading: const Icon(Icons.build),
                  title: const Text('Tools'),
                  onTap: () => {
                    Navigator.pushNamed(context, ToolsScreen.routeName,
                        arguments: {
                          ArgKey.user: widget.user,
                        })
                  },
                ),
                ListTile(
                  leading: Icon(Icons.account_box_outlined),
                  title: Text('My Profile'),
                  onTap: con.seeProfile,
                ),
                ListTile(
                  leading: Icon(Icons.people),
                  title: Text('Users List'),
                  onTap: con.seeUserList,
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Sign Out'),
                  onTap: con.signOut,
                ),
              ],
            ),
          ),
          body: Text(
            'work to be done!',
            style: Theme.of(context).textTheme.headline6,
          )),
    );
  }
}

class _Controller {
  late _UserHomeState state;
  _Controller(this.state);
  late UserProfile userP;

  //void addButton() async {}

  Future<void> signOut() async {
    try {
      await AuthController.signOut();
    } catch (e) {
      if (Constant.devMode) print('+++++++++++++++ Sign out error: $e');
      showSnackBar(context: state.context, message: 'Sign out error: $e');
    }
    Navigator.of(state.context).pop(); // close drawer
    Navigator.of(state.context).pop(); // return to start screen
  }

  void debtPage() async {
    try {
      userP = await FirestoreController.getUser(email: state.email);

      userP.debts = await FirestoreController.getDebtList(
        user: userP,
      );
      await Navigator.pushNamed(
        state.context,
        DebtScreen.routeName,
        arguments: {
          ArgKey.debtList: userP.debts,
          ArgKey.user: state.widget.user,
          ArgKey.userProfile: userP,
        },
      );
      Navigator.of(state.context).pop(); // push in drawer
    } catch (e) {
      if (Constant.devMode) print('======== get Debt list error: $e');
      showSnackBar(
        context: state.context,
        seconds: 20,
        message: 'Failed to get Debt list: $e',
      );
    }
  }

  void budgetsPage() async {
    try {
      await Navigator.pushNamed(
        state.context,
        BudgetsScreen.routeName,
      );
      Navigator.of(state.context).pop(); // push in drawer
    } catch (e) {
      if (Constant.devMode) print('======== get Budgets error: $e');
      showSnackBar(
        context: state.context,
        seconds: 20,
        message: 'Failed to get Budgets list: $e',
      );
    }
  }

  void onTap(int index) async {}

  void seeUserList() async {
    try {
      List<usr.UserInfo> userList = await FirestoreController.getUserList(
          currentUID: state.widget.user.uid);
      await Navigator.pushNamed(state.context, UserListScreen.routeName,
          arguments: {
            ArgKey.currentUID: state.widget.user.uid,
            ArgKey.userList: userList,
          });
      // close the drawer
      Navigator.of(state.context).pop();
    } catch (e) {
      if (Constant.devMode) print('====== userListScreen error: $e');
      showSnackBar(
        context: state.context,
        message: 'Failed to get userList: $e',
      );
    }
  }

  void seeProfile() async {
    try {
      usr.UserInfo profile =
          await FirestoreController.getProfile(uid: state.widget.user.uid);
      await Navigator.pushNamed(state.context, ProfileScreen.routeName,
          arguments: {
            ArgKey.profile: profile,
            ArgKey.currentUID: state.widget.user.uid,
            ArgKey.isFriendAdded: 'N/A',
          });
      // close the drawer
      Navigator.of(state.context).pop();
    } catch (e) {
      if (Constant.devMode) print('====== ProfileScreen error: $e');
      showSnackBar(
        context: state.context,
        message: 'Failed to get editProfile: $e',
      );
    }
  }

  void purchasePage() async {
    try {
      userP = await FirestoreController.getUser(email: state.email);

      userP.debts = await FirestoreController.getPurchaseList(user: userP);

      // state.userP.purchases = await FirestoreController.getPurchaseList(
      //   user: state.userP,
      // );
      await Navigator.pushNamed(
        state.context,
        PurchasesScreen.routeName,
        arguments: {
          //ArgKey.transactionList: transactionList,
          ArgKey.purchaseList: userP.purchases,
          ArgKey.user: state.widget.user,
          ArgKey.userProfile: userP,
        },
      );
      Navigator.of(state.context).pop(); // close drawer
    } catch (e) {
      if (Constant.devMode) print('get Purchase List Error: $e');
      showSnackBar(
        context: state.context,
        message: 'Failed: get Purchase List $e',
        seconds: 20,
      );
    }
  }
}
