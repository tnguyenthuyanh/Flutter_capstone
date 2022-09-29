import 'package:cap_project/viewscreen/editprofile_screen.dart';
import 'package:cap_project/viewscreen/profile_screen.dart';
import 'package:cap_project/viewscreen/addDebt_screen.dart';
import 'package:cap_project/controller/auth_controller.dart';
import 'package:cap_project/viewscreen/debt_screen.dart';
import 'package:cap_project/viewscreen/signin_screen.dart';
import 'package:cap_project/viewscreen/userlist_screen.dart';
import 'package:cap_project/viewscreen/tools_screen.dart';
import 'package:cap_project/viewscreen/tools_screen/tipcalculator_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'controller/auth_controller.dart';
import 'model/constant.dart';
import 'viewscreen/error_screen.dart';
import 'viewscreen/signup_screen.dart';
import 'viewscreen/userhome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Capstone());
}

class Capstone extends StatelessWidget {
  const Capstone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GoogleSignInProvider>(
          create: (BuildContext context) {
            return GoogleSignInProvider();
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: Constant.devMode,
        theme: ThemeData(
            brightness: Constant.DARKMODE ? Brightness.dark : Brightness.light,
            primaryColor: Colors.cyan),
        initialRoute: SignInScreen.routeName,
        routes: {
          SignInScreen.routeName: (context) => const SignInScreen(),
          SignUpScreen.routeName: (context) => const SignUpScreen(),
          UserHomeScreen.routeName: (context) {
            Object? args = ModalRoute.of(context)?.settings.arguments;
            if (args == null) {
              return const ErrorScreen('args is null for UserHomeScreen');
            } else {
              var argument = args as Map;
              var user = argument[ArgKey.user];
              var userP = argument[ArgKey.userProfile];
              return UserHomeScreen(
                user: user, userP: userP,
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
                user: user, userP: userP, // debtList: [],
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
                user: user, userP: userP, debtList: [],
                // profile: profile,
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
              return ProfileScreen(
                currentUID: currentUID,
                profile: profile,
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
              return UserListScreen(
                currentUID: currentUID,
                userList: userList,
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
        },
      ),
    );
  }
}
