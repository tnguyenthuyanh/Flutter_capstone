// ignore_for_file: avoid_print

import 'package:cap_project/View_Model/homescreen_viewmodel.dart';
import 'package:cap_project/model/budgetmonth.dart';
import 'package:cap_project/model/custom_icons_icons.dart';
import 'package:cap_project/model/user.dart';
import 'package:cap_project/viewscreen/accounts/accounts_screen.dart';
import 'package:cap_project/viewscreen/budgets_screen.dart';
import 'package:cap_project/viewscreen/components/my_listview_tile.dart';
import 'package:cap_project/viewscreen/components/texts/emptycontenttext.dart';
import 'package:cap_project/viewscreen/currency_screen.dart';
import 'package:cap_project/viewscreen/debt_screen.dart';
import 'package:cap_project/model/user.dart' as usr;
import 'package:cap_project/viewscreen/moreInfo_screen.dart';
import 'package:cap_project/viewscreen/plan_screen.dart';
import 'package:cap_project/viewscreen/profile_screen.dart';
import 'package:cap_project/viewscreen/purchases_screen.dart';
import 'package:cap_project/viewscreen/savings_screen.dart';
import 'package:cap_project/viewscreen/signin_screen.dart';
import 'package:cap_project/viewscreen/userlist_screen.dart';
import 'package:cap_project/viewscreen/tools_screen.dart';
import 'package:cap_project/viewscreen/wallet_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../controller/auth_controller.dart';
import '../controller/firestore_controller.dart';
import '../model/constant.dart';
import 'components/sizedboxes/fullwidth_sizedbox.dart';
import '../model/wallet.dart';
import 'view/view_util.dart';
import 'package:oktoast/oktoast.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({
    required this.user,
    required this.userP,
    Key? key,
  }) : super(key: key);
  final User user;
  final UserProfile userP;

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

    Provider.of<HomeScreenViewModel>(context, listen: false).initialize();
  }

  void render(fn) => setState(fn);

  void update() {
    Provider.of<HomeScreenViewModel>(context, listen: false).initialize();
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<HomeScreenViewModel>(context, listen: false).initialize();

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          title: Text("$email's feed"),
        ),
        //        DRAWER      --------------------------------------------------
        drawer: Drawer(
          child: ListView(
            children: [
              //        USER ACCOUNT HEADER      -----------------------------
              UserAccountsDrawerHeader(
                currentAccountPicture: const Icon(
                  Icons.person,
                  size: 70.0,
                ),
                accountName: const Text('no profile'),
                accountEmail: Text(email),
              ),
              //        DEBTS     --------------------------------------------
              ListTile(
                leading: const Icon(CustomIcons.money_check),
                title: const Text('Debts'),
                onTap: con.debtPage,
              ),
              //        BUDGET TEMPLATES      --------------------------------
              ListTile(
                leading: const Icon(Icons.payments),
                title: const Text('Transactions'),
                onTap: con.purchasePage,
              ),
              ListTile(
                leading: const Icon(Icons.savings),
                title: const Text('Savings'),
                onTap: con.savingsPage,
              ),
              ListTile(
                leading: const Icon(Icons.local_atm),
                title: const Text('Budget Templates'),
                onTap: con.budgetsPage,
              ),
              //        ACCOUNTS      ----------------------------------------
              ListTile(
                leading: const Icon(Icons.account_box),
                title: const Text('Accounts'),
                onTap: con.accountsPage,
              ),
              //        TOOLS      -------------------------------------------
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
              //        PLANS      -------------------------------------------

              ListTile(
                leading: const Icon(Icons.book),
                title: const Text('Plans'),
                onTap: () => {
                  Navigator.pushNamed(context, PlanScreen.routeName,
                      arguments: {
                        ArgKey.user: widget.user,
                      }),
                },
              ),
              //        PROFILE      ----------------------------------------
              ListTile(
                leading: const Icon(Icons.account_box_outlined),
                title: const Text('My Profile'),
                onTap: con.seeProfile,
              ),
              //        USERS     --------------------------------------------
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Users List'),
                onTap: con.seeUserList,
              ),
              //        Wallet     --------------------------------------------
              ListTile(
                leading: const Icon(Icons.wallet),
                title: const Text('My Wallet'),
                onTap: con.seeWallet,
              ),
              //        SIGN OUT      --------------------------------------------------
              ListTile(
                leading: const Icon(Icons.currency_exchange),
                title: const Text('Currency Exchange'),
                onTap: con.currencyPage,
              ),
              //        SIGN OUT      --------------------------------------------------
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                onTap: con.signOut,
              ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.google),
                title: const Text('Sign Out with Google'),
                onTap: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.logout();
                  Navigator.pushNamed(context, SignInScreen.routeName);
                },
              ),
            ],
          ),
        ),
        //  BODY
        //----------------------------------------------------------------------
        body: Consumer<HomeScreenViewModel>(
          builder: (context, view, child) {
            // If the user hasn't added any templates
            // TOOD: Change to ask to add, then below if user selects no
            if (view.noTemplates) {
              return EmptyContentText(message: "No Templates. Please add one.");
            }
            // User has templates
            else {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  //------------------------------------------------------------
                  //  View Month Drop Down
                  //------------------------------------------------------------
                  FullWidthSizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      //--------------------------------------------------------
                      // Month selection drop down row
                      //--------------------------------------------------------
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // label
                          const Text("View month: "),
                          // Month selection drop down
                          DropdownButton<String>(
                            value: view.getSelectedMonthString(),
                            icon: const Icon(Icons.expand_more),
                            underline: Container(
                              height: 1,
                            ),
                            onChanged: view.newMonthSelected,
                            items: view.getMonthsMenuItems(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  /*------------------------------------------------------------
                    Month Budget Card
                  ------------------------------------------------------------*/
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(child: Text(view.getCurrentMonthString())),
                            /*--------------------------------------------------
                                Total Income
                            --------------------------------------------------*/
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FullWidthSizedBox(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Total Income:"),
                                    Text("\$ ${view.totalIncomeString}"),
                                  ],
                                ),
                              ),
                            ),
                            /*--------------------------------------------------
                                Total Expenses
                            --------------------------------------------------*/
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FullWidthSizedBox(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Total Expenses:"),
                                    Text("\$ ${view.totalExpensesString}"),
                                  ],
                                ),
                              ),
                            ),
                            /*--------------------------------------------------
                                Categories Section
                            --------------------------------------------------*/
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Categories:"),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: view.currentMonth.categories.length,
                                itemBuilder: (BuildContext context, int index) {
                                  FakeCategory _temp =
                                      view.currentMonth.categories[index];

                                  return MyListViewTile(
                                    middleValue: _temp.title,
                                    rightValue: "\$ ${_temp.amount.toString()}",
                                    backgroundColor: _temp.categoryType ==
                                            FakeCategory.EXPENSE_TYPE
                                        ? Colors.red
                                        : Colors.green,
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, MoreInfoScreen.routeName);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Confused on specific term? Click here to learn more',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  late _UserHomeState state;
  _Controller(this.state);
  late UserProfile userP;

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
    navigateTo(BudgetsScreen.routeName);
  }

  void accountsPage() async {
    navigateTo(AccountsScreen.routeName);
  }

  void currencyPage() async {
    navigateTo(CurrencyScreen.routeName);
  }

  void navigateTo(String routename) async {
    try {
      await Navigator.pushNamed(
        state.context,
        routename,
      );
      Navigator.of(state.context).pop(); // push in drawer
    } catch (e) {
      if (Constant.devMode) {
        print('Could not naviate to $routename');
        print('======== Navigation Error: $e');
      }
      showSnackBar(
        context: state.context,
        seconds: 20,
        message: "An error has occured. Could not navigate to $routename",
      );
    }
    state.update();
  }

  void onTap(int index) async {}

  void seeUserList() async {
    try {
      userP = await FirestoreController.getUser(email: state.email);

      List<usr.UserInfo> userList = await FirestoreController.getUserList(
          currentUID: state.widget.user.uid);
      await Navigator.pushNamed(state.context, UserListScreen.routeName,
          arguments: {
            ArgKey.currentUID: state.widget.user.uid,
            ArgKey.userList: userList,
            ArgKey.userProfile: userP,
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
            ArgKey.userProfile: state.widget.userP,
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

  void seeWallet() async {
    try {
      Wallet wallet =
          await FirestoreController.getWallet(state.widget.user.uid);
      await Navigator.pushNamed(state.context, WalletScreen.routeName,
          arguments: {
            ArgKey.wallet: wallet,
            ArgKey.user: state.widget.user,
          });
      // close the drawer
      Navigator.of(state.context).pop();
    } catch (e) {
      if (Constant.devMode) print('====== WalletScreen error: $e');
      showSnackBar(
        context: state.context,
        message: 'Failed to get walletScreen: $e',
      );
    }
  }

  void purchasePage() async {
    try {
      userP = await FirestoreController.getUser(email: state.email);
      userP.purchases = await FirestoreController.getPurchaseList(user: userP);

      await Navigator.pushNamed(
        state.context,
        PurchasesScreen.routeName,
        arguments: {
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

  void savingsPage() async {
    try {
      userP = await FirestoreController.getUser(email: state.email);
      userP.savings = await FirestoreController.getSavings(user: userP);
      await Navigator.pushNamed(state.context, SavingsScreen.routeName,
          arguments: {
            ArgKey.savings: userP.savings,
            ArgKey.user: state.widget.user,
            ArgKey.userProfile: userP,
          });
    } catch (e) {
      if (Constant.devMode) print('get Savings Error: $e');
      showSnackBar(
        context: state.context,
        message: 'Failed: to get Savings $e',
        seconds: 20,
      );
    }
  }

  void showSelectBudgetMessage() {
    showToast("You need to select a buget to use");
  }
}//end of controller
