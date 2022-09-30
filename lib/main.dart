import 'package:cap_project/viewscreen/addDebt_screen.dart';
import 'package:cap_project/viewscreen/addPurchase_screen.dart';
import 'package:cap_project/viewscreen/debt_screen.dart';
import 'package:cap_project/viewscreen/error_screen.dart';
import 'package:cap_project/viewscreen/signin_screen.dart';
import 'package:cap_project/viewscreen/purchases_screen.dart';
import 'package:cap_project/viewscreen/userhome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'View_Model/auth_viewModel.dart';
import 'firebase_options.dart';
import 'model/constant.dart';
import 'viewscreen/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AuthViewModel()),
  ], child: const Capstone()));
}

class Capstone extends StatelessWidget {
  const Capstone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: Constant.devMode,
      initialRoute: SignInScreen.routeName,
      routes: {
        SignInScreen.routeName: (context) => const SignInScreen(),
        PurchasesScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for PurchasesScreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            var userP = argument[ArgKey.userProfile];
            return PurchasesScreen(
              user: user, userP: userP, // purchaseList: [],
              // profile: profile,
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
              user: user, userP: userP, purchaseList: [],
              // profile: profile,
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
              user: user, userP: userP, debtList: [],
              // profile: profile,
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
        SignUpScreen.routeName: (context) => const SignUpScreen(),
      },
    );
  }
}
