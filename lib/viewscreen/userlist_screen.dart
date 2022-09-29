// ignore_for_file: avoid_print

import 'package:cap_project/model/user.dart';
import 'package:cap_project/viewscreen/profile_screen.dart';
import 'package:flutter/material.dart';
import '../controller/firestore_controller.dart';
import '../model/constant.dart';
import 'view/view_util.dart';

class UserListScreen extends StatefulWidget {
  final List<UserInfo> userList;
  final String currentUID;

  UserListScreen({
    required this.currentUID,
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
      body: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 10),
        padding: EdgeInsets.all(10),
        itemCount: con.userList.length,
        itemBuilder: (context, index) {
          return Material(
            elevation: 17,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.pink[50],
                border: Border.all(width: 4, color: Colors.pink[200]!),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.brown.shade100,
                  child: Text(
                    con.userList[index].name == ""
                        ? "N/A"
                        : con.userList[index].name[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Satisfy-Regular',
                      color: Colors.blueAccent,
                    ),
                  ),
                  radius: 50,
                ),
                title: Text(
                  con.userList[index].name == ""
                      ? "N/A"
                      : con.userList[index].name,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.amber[600],
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(con.userList[index].email),
                  ],
                ),
                onTap: () => con.seeProfile(index),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Controller {
  late _UserListState state;
  late List<UserInfo> userList;
  late String currentUID;

  _Controller(this.state) {
    userList = state.widget.userList;
    currentUID = state.widget.currentUID;
  }

  void seeProfile(int index) async {
    try {
      Map profile =
          await FirestoreController.getProfile(uid: userList[index].uid);
      await Navigator.pushNamed(state.context, ProfileScreen.routeName,
          arguments: {
            ArgKey.profile: profile,
            ArgKey.currentUID: currentUID,
          });
      // Navigator.of(state.context).pop();
    } catch (e) {
      if (Constant.devMode) print('====== ProfileScreen error: $e');
      showSnackBar(
        context: state.context,
        message: 'Failed to get editProfile: $e',
      );
    }
  }
}
