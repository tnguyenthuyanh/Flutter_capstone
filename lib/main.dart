import 'package:cap_project/viewscreen/editprofile_screen.dart';
import 'package:cap_project/viewscreen/profile_screen.dart';
import 'package:cap_project/viewscreen/signin_screen.dart';
import 'package:cap_project/viewscreen/userlist_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: Constant.devMode,
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
        ProfileScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null at ProfileScreen');
          } else {
            var argument = args as Map;
            var user = argument[ArgKey.user];
            var profile = argument[ArgKey.profile];
            return ProfileScreen(
              user: user,
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
            var user = argument[ArgKey.user];
            var profile = argument[ArgKey.profile];
            return EditProfileScreen(user: user, profile: profile);
          }
        },
        UserListScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null at UserListScreen');
          } else {
            var argument = args as Map;
            var userList = argument[ArgKey.userList];
            return UserListScreen(
              userList: userList,
            );
          }
        },
      },
    );
  }
}
