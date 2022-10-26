import 'package:cap_project/View_Model/account_data.dart';
import 'package:cap_project/View_Model/budgetCategory_ViewModel.dart';
import 'package:cap_project/viewscreen/accounts/accounts_screen.dart';
import 'package:cap_project/viewscreen/debtDetail_screen.dart';
import 'package:cap_project/model/savingsBadge.dart';
import 'package:cap_project/viewscreen/addPlan_screen.dart';
import 'package:cap_project/viewscreen/addPurchase_screen.dart';
import 'package:cap_project/viewscreen/addSavings_screen.dart';
import 'package:cap_project/viewscreen/editprofile_screen.dart';
import 'package:cap_project/viewscreen/plan_screen.dart';
import 'package:cap_project/viewscreen/profile_screen.dart';
import 'package:cap_project/viewscreen/addDebt_screen.dart';
import 'package:cap_project/controller/auth_controller.dart';
import 'package:cap_project/viewscreen/debt_screen.dart';
import 'package:cap_project/viewscreen/purchases_screen.dart';
import 'package:cap_project/viewscreen/savings_screen.dart';
import 'package:cap_project/viewscreen/signin_screen.dart';
import 'package:cap_project/viewscreen/tools_screen/fuelcostestimator_screen.dart';
import 'package:cap_project/viewscreen/userlist_screen.dart';
import 'package:cap_project/viewscreen/tools_screen.dart';
import 'package:cap_project/viewscreen/tools_screen/tipcalculator_screen.dart';
import 'package:cap_project/View_Model/auth_viewModel.dart';
import 'package:cap_project/viewscreen/ForgotSignIn_screen.dart';
import 'package:cap_project/viewscreen/budgetCategory.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'View_Model/budget_data.dart';
import 'View_Model/budgetlistmode_data.dart';
import 'firebase_options.dart';
import 'package:oktoast/oktoast.dart';
import 'model/constant.dart';
import 'viewscreen/accounts/addaccount_screen.dart';
import 'viewscreen/addbudget_screen.dart';
import 'viewscreen/budgetdetail_screen.dart';
import 'viewscreen/budgets_screen.dart';
import 'viewscreen/error_screen.dart';
import 'viewscreen/payoffSchedule_screen.dart';
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
          UserHomeScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen('args is null for UserHomeScreen');
            } else {
              var argument = args as Map;
              var user = argument[ArgKey.user];
              return UserHomeScreen(
                user: user,
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
                debtList: [],
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
                debtList: [],
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
          BudgetsScreen.routeName: (context) => const BudgetsScreen(),
          AddBudgetScreen.routeName: (context) => const AddBudgetScreen(),
          BudgetDetailScreen.routeName: (context) => const BudgetDetailScreen(),
          // ignore: prefer_const_constructors
          AddCategory.routeName: (context) => AddCategory(),
          AccountsScreen.routeName: (context) => const AccountsScreen(),
          AddAccountScreen.routeName: (context) => const AddAccountScreen(),
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
                purchaseList: [],
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
              return AddPurchaseScreen(
                user: user,
                userP: userP,
                purchaseList: [],
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
                savings: [],
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
                savings: [],
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
