// ignore_for_file: avoid_print

import 'package:cap_project/model/user.dart' as usr;
import 'package:cap_project/viewscreen/profile_screen.dart';
import 'package:cap_project/viewscreen/userlist_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controller/auth_controller.dart';
import '../controller/firestore_controller.dart';
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
                ListTile(
                  leading: Icon(Icons.account_box_outlined),
                  title: Text('My Profile'),
                  onTap: con.seeProfile,
                ),
                ListTile(
                  leading: Icon(Icons.account_box_outlined),
                  title: Text('Users List'),
                  onTap: con.seeUserList,
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

  void seeUserList() async {
    try {
      List<usr.UserInfo> userList = await FirestoreController.getUserList();
      await Navigator.pushNamed(state.context, UserListScreen.routeName,
          arguments: {
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
      Map profile =
          await FirestoreController.getProfile(uid: state.widget.user.uid);
      await Navigator.pushNamed(state.context, ProfileScreen.routeName,
          arguments: {
            ArgKey.profile: profile,
            ArgKey.user: state.widget.user,
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
}
