// ignore_for_file: avoid_print

import 'package:cap_project/model/user.dart';
import 'package:cap_project/viewscreen/profile_screen.dart';
import 'package:flutter/material.dart';
import '../controller/firestore_controller.dart';
import '../model/constant.dart';
import 'view/view_util.dart';

class UserListScreen extends StatefulWidget {
  final List<UserInfo> userList;

  UserListScreen({
    required this.userList,
  });

  static const routeName = '/userListScreen';

  @override
  State<StatefulWidget> createState() {
    return _UserListState();
  }
}

class _UserListState extends State<UserListScreen> {
  late _Controller con;
  late String email;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Users List'),
        ),
        body: Text(
          'work to be done!',
          style: Theme.of(context).textTheme.headline6,
        ));
  }
}

class _Controller {
  _UserListState state;

  _Controller(this.state) {}

  void seeProfile() async {
    // try {
    //   Map profile =
    //       await FirestoreController.getProfile(uid: state.widget.user.uid);
    //   await Navigator.pushNamed(state.context, ProfileScreen.routeName,
    //       arguments: {
    //         ArgKey.profile: profile,
    //         ArgKey.user: state.widget.user,
    //       });
    //   // close the drawer
    //   Navigator.of(state.context).pop();
    // } catch (e) {
    //   if (Constant.devMode) print('====== ProfileScreen error: $e');
    //   showSnackBar(
    //     context: state.context,
    //     message: 'Failed to get editProfile: $e',
    //   );
    // }
  }
}
