import 'package:cap_project/viewscreen/tools_screen.dart';
import 'package:cap_project/viewscreen/tools_screen/tipcalculator_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'model/constant.dart';
import 'viewscreen/error_screen.dart';
import 'viewscreen/signin_screen.dart';
import 'viewscreen/signup_screen.dart';
import 'viewscreen/userhome_screen.dart';
import 'package:cap_project/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Capstone());
}

class Capstone extends StatelessWidget {
  const Capstone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: Constant.devMode,
      theme: ThemeData(
          brightness: Constant.DARKMODE ? Brightness.dark : Brightness.light,
          primaryColor: Colors.cyan),
      initialRoute: SignInScreen.routeName,
      routes: {
        SignInScreen.routeName: (context) => const SignInScreen(),
        UserHomeScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for UserHomeScreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            //var profile = argument[ArgKey.userProf];
            return UserHomeScreen(
              user: user,
              // profile: profile,
            );
          }
        },
        SignUpScreen.routeName: (context) => const SignUpScreen(),
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
    );
  }
}
