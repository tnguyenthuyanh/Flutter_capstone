import 'package:cap_project/View_Model/account_data.dart';
import 'package:cap_project/View_Model/budgetCategory_ViewModel.dart';
import 'package:cap_project/View_Model/homescreen_viewmodel.dart';
import 'package:cap_project/viewscreen/accounts/accountdetail_screen.dart';
import 'package:cap_project/viewscreen/accounts/accounts_screen.dart';
import 'package:cap_project/viewscreen/addBalance_screen.dart';
import 'package:cap_project/viewscreen/addCard_screen.dart';
import 'package:cap_project/viewscreen/currency_screen.dart';
import 'package:cap_project/viewscreen/debtDetail_screen.dart';
import 'package:cap_project/viewscreen/addPlan_screen.dart';
import 'package:cap_project/viewscreen/addPurchase_screen.dart';
import 'package:cap_project/viewscreen/addSavings_screen.dart';
import 'package:cap_project/viewscreen/editprofile_screen.dart';
import 'package:cap_project/viewscreen/moreInfo_screen.dart';
import 'package:cap_project/viewscreen/plan_screen.dart';
import 'package:cap_project/viewscreen/profile_screen.dart';
import 'package:cap_project/viewscreen/addDebt_screen.dart';
import 'package:cap_project/controller/auth_controller.dart';
import 'package:cap_project/viewscreen/debt_screen.dart';
import 'package:cap_project/viewscreen/purchases_screen.dart';
import 'package:cap_project/viewscreen/savings_screen.dart';
import 'package:cap_project/viewscreen/signin_screen.dart';
import 'package:cap_project/viewscreen/tools_screen/fuelcostestimator_screen.dart';
import 'package:cap_project/viewscreen/tools_screen/paycheckcalculator_screen.dart';
import 'package:cap_project/viewscreen/transactionHistory_screen.dart';
import 'package:cap_project/viewscreen/transferMoney_screen.dart';
import 'package:cap_project/viewscreen/userlist_screen.dart';
import 'package:cap_project/viewscreen/tools_screen.dart';
import 'package:cap_project/viewscreen/tools_screen/tipcalculator_screen.dart';
import 'package:cap_project/View_Model/auth_viewModel.dart';
import 'package:cap_project/viewscreen/ForgotSignIn_screen.dart';
import 'package:cap_project/viewscreen/budgetCategory.dart';
import 'package:cap_project/viewscreen/wallet_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'View_Model/budget_data.dart';
import 'View_Model/budgetlistmode_data.dart';
import 'View_Model/purchases_viewModal.dart';
import 'firebase_options.dart';
import 'package:oktoast/oktoast.dart';
import 'model/constant.dart';
import 'viewscreen/accounts/addaccount_screen.dart';
import 'viewscreen/addbudget_screen.dart';
import 'viewscreen/budgetdetail_screen.dart';
import 'viewscreen/budgets_screen.dart';
import 'viewscreen/error_screen.dart';
import 'viewscreen/moneyRequests_screen.dart';
import 'viewscreen/payoffSchedule_screen.dart';
import 'viewscreen/seeRequest_screen.dart';
import 'viewscreen/signup_screen.dart';
import 'viewscreen/userhome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<GoogleSignInProvider>(
      create: (BuildContext context) {
        return GoogleSignInProvider();
      },
    ),
    ChangeNotifierProvider(create: (_) => AuthViewModel()),
    ChangeNotifierProvider(create: (context) => BudgetData()),
    ChangeNotifierProvider(create: (context) => BudgetListModeData()),
    ChangeNotifierProvider(create: (context) => BudgetCategoryViewModel()),
    ChangeNotifierProvider(create: (context) => AccountData()),
    ChangeNotifierProvider(create: (context) => HomeScreenViewModel()),
    ChangeNotifierProvider(
      create: ((context) => PurchaseViewModal()),
    ),
  ], child: const Capstone()));
}

class Capstone extends StatelessWidget {
  const Capstone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        debugShowCheckedModeBanner: Constant.devMode,
        theme: ThemeData(
            brightness: Constant.DARKMODE ? Brightness.dark : Brightness.light,
            primaryColor: Colors.cyan),
        initialRoute: SignInScreen.routeName,
        routes: {
          SignInScreen.routeName: (context) => const SignInScreen(),
          SignUpScreen.routeName: (context) => const SignUpScreen(),
          ForgotSignIn.routeName: (context) => const ForgotSignIn(),
          MoreInfoScreen.routeName: (context) => const MoreInfoScreen(),
          CurrencyScreen.routeName: (context) => const CurrencyScreen(),
          UserHomeScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen('args is null for UserHomeScreen');
            } else {
              var argument = args as Map;
              var user = argument[ArgKey.user];
              var userP = argument[ArgKey.userProfile];
              return UserHomeScreen(
                user: user,
                userP: userP,
              );
            }
          },
          DebtScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen('args is null for DebtScreen');
            } else {
              var argument = args as Map;
              var user = argument[ArgKey.user];
              var userP = argument[ArgKey.userProfile];
              return DebtScreen(
                user: user,
                userP: userP,
                debtList: const [],
              );
            }
          },
          DebtDetailScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen('args is null for DebtScreen');
            } else {
              var argument = args as Map;
              var user = argument[ArgKey.user];
              var userP = argument[ArgKey.userProfile];
              var debt = argument[ArgKey.singleDebt];
              return DebtDetailScreen(
                user: user,
                userP: userP,
                debt: debt,
              );
            }
          },
          AddDebtScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen('args is null for AddDebtScreen');
            } else {
              var argument = args as Map;
              var user = argument[ArgKey.user];
              var userP = argument[ArgKey.userProfile];
              return AddDebtScreen(
                user: user,
                userP: userP,
                debtList: const [],
              );
            }
          },
          PayoffScheduleScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen('args is null for PayoffScreen');
            } else {
              var argument = args as Map;
              var user = argument[ArgKey.user];
              var debt = argument[ArgKey.singleDebt];
              return PayoffScheduleScreen(
                user: user,
                debt: debt,
              );
            }
          },
          ProfileScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen('args is null at ProfileScreen');
            } else {
              var argument = args as Map;
              var currentUID = argument[ArgKey.currentUID];
              var profile = argument[ArgKey.profile];
              var isFriendAdded = argument[ArgKey.isFriendAdded];
              var userP = argument[ArgKey.userProfile];
              return ProfileScreen(
                currentUID: currentUID,
                profile: profile,
                isFriendAdded: isFriendAdded,
                userP: userP,
              );
            }
          },
          EditProfileScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen('args is null at EditProfileScreen');
            } else {
              var argument = args as Map;
              var profile = argument[ArgKey.profile];
              return EditProfileScreen(profile: profile);
            }
          },
          UserListScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen('args is null at UserListScreen');
            } else {
              var argument = args as Map;
              var userList = argument[ArgKey.userList];
              var currentUID = argument[ArgKey.currentUID];
              var userP = argument[ArgKey.userProfile];
              return UserListScreen(
                currentUID: currentUID,
                userList: userList,
                userP: userP,
              );
            }
          },
          WalletScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen('args is null at WalletScreen');
            } else {
              var argument = args as Map;
              var user = argument[ArgKey.user];
              var wallet = argument[ArgKey.wallet];
              return WalletScreen(
                user: user,
                wallet: wallet,
              );
            }
          },
          TransferMoneyScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen('args is null at TransferMoneyScreen');
            } else {
              var argument = args as Map;
              var user = argument[ArgKey.user];
              var friendList = argument[ArgKey.userList];
              var wallet = argument[ArgKey.wallet];
              return TransferMoneyScreen(
                user: user,
                friendList: friendList,
                wallet: wallet,
              );
            }
          },
          AddCardScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen('args is null at AddCardScreen');
            } else {
              var argument = args as Map;
              var user = argument[ArgKey.user];
              var wallet = argument[ArgKey.wallet];
              return AddCardScreen(
                user: user,
                wallet: wallet,
              );
            }
          },
          AddBalanceScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen('args is null at AddBalanceScreen');
            } else {
              var argument = args as Map;
              var user = argument[ArgKey.user];
              var wallet = argument[ArgKey.wallet];
              return AddBalanceScreen(
                user: user,
                wallet: wallet,
              );
            }
          },
          TransactionHistoryScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen(
                  'args is null at TransactionHistoryScreen');
            } else {
              var argument = args as Map;
              var user = argument[ArgKey.user];
              var transList = argument[ArgKey.transactionList];
              return TransactionHistoryScreen(
                user: user,
                transList: transList,
              );
            }
          },
          MoneyRequestsScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen('args is null at MoneyRequestsScreen');
            } else {
              var argument = args as Map;
              var user = argument[ArgKey.user];
              var requestList = argument[ArgKey.requestList];
              var wallet = argument[ArgKey.wallet];
              return MoneyRequestsScreen(
                user: user,
                requestList: requestList,
                wallet: wallet,
              );
            }
          },
          SeeRequestScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen('args is null at SeeRequestScreen');
            } else {
              var argument = args as Map;
              var user = argument[ArgKey.user];
              var request = argument[ArgKey.request];
              var wallet = argument[ArgKey.wallet];
              return SeeRequestScreen(
                user: user,
                request: request,
                wallet: wallet,
              );
            }
          },
          ToolsScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen('args is null for ToolsScreen');
            } else {
              var argument = args as Map;
              var user = argument[ArgKey.user];
              return ToolsScreen(user: user);
            }
          },
          TipCalculatorScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen('args is null for TipCalculatorScreen');
            } else {
              var argument = args as Map;
              var user = argument[ArgKey.user];
              return TipCalculatorScreen(user: user);
            }
          },
          FuelCostEstimatorScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen(
                  'args is null for FuelCostEstimatorScreen');
            } else {
              var argument = args as Map;
              var user = argument[ArgKey.user];
              return FuelCostEstimatorScreen(user: user);
            }
          },
          PaycheckCalculatorScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen(
                  'args is null for PaycheckCalculatorScreen');
            } else {
              var argument = args as Map;
              var user = argument[ArgKey.user];
              var fedTaxDatabase = argument[Tools.fedTaxDatabase];
              var stateTaxDatabase = argument[Tools.stateTaxDatabase];

              return PaycheckCalculatorScreen(
                user: user,
                fedTaxDatabase: fedTaxDatabase,
                stateTaxDatabase: stateTaxDatabase,
              );
            }
          },
          BudgetsScreen.routeName: (context) => const BudgetsScreen(),
          AddBudgetScreen.routeName: (context) => const AddBudgetScreen(),
          BudgetDetailScreen.routeName: (context) => const BudgetDetailScreen(),
          // ignore: prefer_const_constructors
          AddCategory.routeName: (context) => AddCategory(),
          AccountsScreen.routeName: (context) => const AccountsScreen(),
          AddAccountScreen.routeName: (context) => const AddAccountScreen(),
          AccountDetailScreen.routeName: (context) =>
              const AccountDetailScreen(),
          PurchasesScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen('args is null for PurchasesScreen');
            } else {
              var argument = args as Map;
              var user = argument[ArgKey.user];
              var userP = argument[ArgKey.userProfile];
              return PurchasesScreen(
                user: user,
                userP: userP,
                purchaseList: const [],
              );
            }
          },
          AddPurchaseScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen('args is null for AddPurchaseScreen');
            } else {
              var argument = args as Map;
              var user = argument[ArgKey.user];
              var userP = argument[ArgKey.userProfile];
              var transType = argument[ArgKey.transType];
              var selected = argument[ArgKey.selected];
              return AddPurchaseScreen(
                user: user,
                userP: userP,
                purchaseList: argument[ArgKey.purchaseList],
                transType: transType,
                selected: selected,
              );
            }
          },
          SavingsScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen('args is null for Savings Screen');
            } else {
              var argument = args as Map;
              var user = argument[ArgKey.user];
              var userP = argument[ArgKey.userProfile];
              return SavingsScreen(
                user: user,
                userP: userP,
                savings: const [],
              );
            }
          },
          AddSavingsScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen('args is null for AddSavingsScreen');
            } else {
              var argument = args as Map;
              var user = argument[ArgKey.user];
              var userP = argument[ArgKey.userProfile];
              return AddSavingsScreen(
                user: user,
                userP: userP,
                savings: const [],
              );
            }
          },
          PlanScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen('args is null for PlanScreen');
            } else {
              var argument = args as Map;
              var user = argument[ArgKey.user];
              var planList = argument[ArgKey.planList];
              return PlanScreen(
                user: user,
                //planList: [],
              );
            }
          },
          AddPlanScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen('args is null for AddPlanScreen');
            } else {
              var argument = args as Map;
              var user = argument[ArgKey.user];
              var planList = argument[ArgKey.planList];
              return AddPlanScreen(
                user: user,
                planList: [],
              );
            }
          },
        }, //end of routes
      ),
    );
  }
}
