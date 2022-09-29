// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controller/auth_controller.dart';
import '../model/constant.dart';
import 'view/view_util.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen(
      {required this.user,
      //required this.profile,
      Key? key})
      : super(key: key);

  final User user;
  //final Userprof profile;

  static const routeName = '/userHomeScreen';

  @override
  State<StatefulWidget> createState() {
    return _UserHomeState();
  }
}

class _UserHomeState extends State<UserHomeScreen> {
  late _Controller con;
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
                  leading: const Icon(Icons.logout),
                  title: const Text('Sign Out'),
                  onTap: con.signOut,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: con.addButton,
          ),
          body: Text(
            'work to be done!',
            style: Theme.of(context).textTheme.headline6,
          )),
    );
  }
}

class _Controller {
  _UserHomeState state;

  _Controller(this.state) {}

  void addButton() async {}

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

  void onTap(int index) async {}
}
