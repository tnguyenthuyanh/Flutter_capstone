import 'package:cap_project/View_Model/auth_viewModel.dart';
import 'package:cap_project/viewscreen/ForgotSignIn_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'model/constant.dart';
import 'viewscreen/error_screen.dart';
import 'viewscreen/signin_screen.dart';
import 'viewscreen/signup_screen.dart';
import 'viewscreen/userhome_screen.dart';
import 'package:cap_project/firebase_options.dart';
import 'package:provider/provider.dart';

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
    return OKToast(
      child: MaterialApp(
        debugShowCheckedModeBanner: Constant.devMode,
        theme: ThemeData(
            brightness: Constant.DARKMODE ? Brightness.dark : Brightness.light,
            primaryColor: Colors.cyan),
        initialRoute: SignUpScreen.routeName,
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
          ForgotSignIn.routeName: (context) => const ForgotSignIn(),
        },
      ),
    );
  }
}
