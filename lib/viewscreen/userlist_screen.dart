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
  final UserProfile userP;

  UserListScreen({
    required this.currentUID,
    required this.userList,
    required this.userP,
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
  Filter filterValue = Filter.AllUsers;
  SearchOption searchOption = SearchOption.email;

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
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 7, 0, 0),
                    child: Container(
                      height: 30,
                      child: TextFormField(
                        style: TextStyle(fontSize: 12.0, height: 1.35),
                        decoration: InputDecoration(
                          hintText: 'Search',
                          fillColor: Theme.of(context).backgroundColor,
                          filled: true,
                        ),
                        autocorrect: true,
                        onSaved: con.saveSearchKey,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: con.search,
                  icon: Icon(
                    Icons.search,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 75),
                  child: Transform.scale(
                    scale: 0.7,
                    child: RadioListTile<SearchOption>(
                      title: Text("email"),
                      value: SearchOption.email,
                      groupValue: searchOption,
                      onChanged: (value) {
                        setState(() {
                          searchOption = value!;
                          con.searchOption = searchOption;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 75),
                  child: Transform.scale(
                    scale: 0.7,
                    child: RadioListTile<SearchOption>(
                      title: Text("name"),
                      value: SearchOption.name,
                      groupValue: searchOption,
                      onChanged: (value) {
                        setState(() {
                          searchOption = value!;
                          con.searchOption = searchOption;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                //width: 130,
                height: 30,
                padding: const EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  color: Colors.grey.withAlpha(100),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Filter>(
                    value: filterValue,
                    onChanged: con.filter,
                    items: [
                      for (var c in Filter.values)
                        DropdownMenuItem<Filter>(
                          child: Text(
                            c.toString().split('.')[1].replaceFirst('_', ' '),
                            style: TextStyle(
                              fontSize: 11,
                            ),
                          ),
                          value: c,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: con.userList.isEmpty
                ? Text(
                    'No User found!',
                    style: Theme.of(context).textTheme.headline6,
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    padding: EdgeInsets.all(10),
                    itemCount: con.userList.length,
                    itemBuilder: (context, index) {
                      return Material(
                        elevation: 17,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.brown[400],
                            border: Border.all(width: 4, color: Colors.green),
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
          ),
        ],
      ),
    );
  }
}

class _Controller {
  late _UserListState state;
  late List<UserInfo> userList;
  late String currentUID;
  String? searchKeyString;
  late SearchOption searchOption;

  _Controller(this.state) {
    userList = state.widget.userList;
    currentUID = state.widget.currentUID;
    searchOption = state.searchOption;
  }

  void seeProfile(int index) async {
    try {
      UserInfo profile =
          await FirestoreController.getProfile(uid: userList[index].uid);
      String isFriendAdded = await FirestoreController.isFriendAdded(
          friendUID: profile.uid, currentUID: currentUID);
      await Navigator.pushNamed(state.context, ProfileScreen.routeName,
          arguments: {
            ArgKey.profile: profile,
            ArgKey.currentUID: currentUID,
            ArgKey.isFriendAdded: isFriendAdded,
            ArgKey.userProfile: state.widget.userP,
          });
      await filter(state.filterValue);
      // Navigator.of(state.context).pop();
    } catch (e) {
      if (Constant.devMode) print('====== ProfileScreen error: $e');
      showSnackBar(
        context: state.context,
        message: 'Failed to get editProfile: $e',
      );
    }
  }

  Future<void> filter(Filter? value) async {
    List<UserInfo> filteredUserList = [];
    startCircularProgress(state.context);

    if (value == Filter.AllUsers) {
      filteredUserList =
          await FirestoreController.getUserList(currentUID: currentUID);
    } else if (value == Filter.MyFriends) {
      filteredUserList =
          await FirestoreController.getFriendList(currentUID: currentUID);
    } else {
      filteredUserList =
          await FirestoreController.getFriendRequest(currentUID: currentUID);
    }

    stopCircularProgress(state.context);
    state.render(() {
      state.filterValue = value!;
      userList = filteredUserList;
    });
  }

  void saveSearchKey(String? value) {
    searchKeyString = value!.toLowerCase();
  }

  Future<void> search() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null) return;
    currentState.save();

    List<UserInfo> newUserList;
    if (searchOption == SearchOption.email) {
      newUserList = await FirestoreController.searchUsersByEmail(
          searchKey: searchKeyString!);
    } else {
      newUserList = await FirestoreController.searchUsersByName(
          searchKey: searchKeyString!);
    }
    state.render(() {
      userList = newUserList;
    });
  }
}
