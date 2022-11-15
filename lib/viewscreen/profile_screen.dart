import 'dart:async';

import 'package:cap_project/model/constant.dart';
import 'package:cap_project/model/savings.dart';
import 'package:cap_project/model/savingsBadge.dart';
import 'package:cap_project/model/user.dart';
import 'package:cap_project/viewscreen/view/view_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';

import '../controller/firestore_controller.dart';
import 'editprofile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(
      {required this.currentUID,
      required this.profile,
      required this.isFriendAdded,
      required this.userP,
      Key? key})
      : super(key: key);

  final String currentUID;
  final UserInfo profile;
  final String isFriendAdded;
  final UserProfile userP;

  static const routeName = '/bioScreen';

  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<ProfileScreen> {
  late _Controller con;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool added = false;

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
        title: const Text(
          'Profile',
        ),
        backgroundColor: Color.fromARGB(255, 80, 123, 210),
        actions: widget.profile.uid == widget.currentUID
            ? [IconButton(onPressed: con.edit, icon: Icon(Icons.edit))]
            : null,
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomLeft,
                        colors: [
                      Color.fromARGB(255, 217, 139, 165),
                      Color.fromARGB(255, 56, 103, 156),
                      Colors.orange[200]!,
                    ])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.brown.shade100,
                      child: Text(
                        widget.profile.name == ""
                            ? "N/A"
                            : widget.profile.name[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Satisfy-Regular',
                          color: Colors.blueAccent,
                        ),
                      ),
                      radius: 50,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      widget.profile.name == "" ? "N/A" : widget.profile.name,
                      style: TextStyle(
                        fontSize: 25.0,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      widget.profile.email,
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    widget.profile.uid == widget.currentUID
                        ? SizedBox()
                        : con.isFriendAdded == 'canAdd'
                            ? Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  height: 40,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    gradient: LinearGradient(colors: [
                                      Color.fromARGB(255, 205, 91, 129),
                                      Color.fromARGB(255, 102, 192, 94)
                                    ]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: con.addFriend,
                                    child: Text('Add Friend',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.transparent,
                                        shadowColor: Colors.transparent),
                                  ),
                                ),
                              )
                            : con.isFriendAdded == 'Pending'
                                ? Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: SizedBox(
                                      height: 30,
                                      width: 110,
                                      child: ElevatedButton(
                                        onPressed: null,
                                        child: Text('Pending',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white)),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                                side: BorderSide(
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : con.isFriendAdded == 'Accept'
                                    ? Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: SizedBox(
                                          height: 30,
                                          width: 110,
                                          child: ElevatedButton(
                                            onPressed: con.acceptFriend,
                                            child: Text('Accept',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white)),
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.0),
                                                    side: BorderSide(
                                                        color: Colors.green)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : con.isFriendAdded == 'isFriend'
                                        ? Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: SizedBox(
                                              height: 30,
                                              width: 110,
                                              child: ElevatedButton.icon(
                                                onPressed: null,
                                                label: Text('Friend',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black)),
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.lightGreen),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50.0),
                                                        side: BorderSide(
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ),
                                                icon: Icon(
                                                    Icons.people_alt_outlined),
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                    widget.userP.hasSpouse.compareTo('false') == 0 &&
                            widget.profile.uid != widget.currentUID
                        ? Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              height: 30,
                              width: 110,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                gradient: LinearGradient(colors: [
                                  Color.fromARGB(255, 205, 91, 129),
                                  Color.fromARGB(255, 102, 192, 94)
                                ]),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                              ),
                              child: ElevatedButton(
                                onPressed: con.addSpouse,
                                child: Text('Add Spouse',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.transparent,
                                    shadowColor: Colors.transparent),
                              ),
                            ),
                          )
                        : SizedBox(),
                    Divider(
                      color: Colors.yellow,
                      height: 20.0, // space betwen top or bottom item
                    ),
                    Container(
                      height: 120,
                      child: Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 2.0),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.green[50],
                        elevation: 14.0,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 15.0),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        widget.profile.bio,
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 60, 98, 169),
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.yellow,
                      height: 30.0, // space betwen top or bottom item
                    ),
                    widget.profile.uid == widget.currentUID
                        ? Column(
                            children: [
                              Text('Share budget with spouse?',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white)),
                              Checkbox(
                                value: widget.userP.shareBudget
                                            .compareTo('true') ==
                                        0
                                    ? true
                                    : false,
                                onChanged: con.updateShare,
                              ),
                            ],
                          )
                        : const SizedBox(),
                    const Divider(
                      color: Colors.yellow,
                      height: 30.0, // space betwen top or bottom item
                    ),
                    if (con.isFriendAdded == 'isFriend')
                      const Text('Friend\'s Saving Badge'),
                    if (con.isFriendAdded == 'isFriend')
                      SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: Image.network(con.getBadge()),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  late _ProfileState state;
  late String isFriendAdded;
  double savingsAmt = 1;
  String url =
      'https://www.imprintlogo.com/images/products/saving-money-is-smart-sticker-rolls_11979.jpg';
  List<String> valueList = [];
  _Controller(this.state) {
    isFriendAdded = state.widget.isFriendAdded;
  }

  void edit() async {
    try {
      UserInfo profile =
          await FirestoreController.getProfile(uid: state.widget.currentUID);
      await Navigator.pushNamed(state.context, EditProfileScreen.routeName,
          arguments: {
            ArgKey.profile: profile,
          });
    } catch (e) {
      if (Constant.devMode) print('====== editProfile error: $e');
      showSnackBar(
        context: state.context,
        message: 'Failed to get editProfile: $e',
      );
    }
  }

  void addFriend() async {
    UserFriends userFriends = UserFriends(
      uid_send: state.widget.currentUID,
      uid_receive: state.widget.profile.uid,
      accept: 0,
    );

    startCircularProgress(state.context);
    await FirestoreController.addFriend(userFriends: userFriends);
    stopCircularProgress(state.context);

    state.render(() {
      isFriendAdded = 'Pending';
    });
  }

  void acceptFriend() async {
    await FirestoreController.acceptFriend(
        friendUID: state.widget.profile.uid,
        currentUID: state.widget.currentUID);

    state.render(() {
      isFriendAdded = 'isFriend';
    });
  }

  void addSpouse() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null) return;
    if (!currentState.validate()) return;
    currentState.save();

    state.widget.userP.spouseUid = state.widget.profile.uid;
    state.widget.userP.hasSpouse = 'true';

    try {
      Map<String, dynamic> update = {};
      //update Firestore doc
      update[DocKeyUserprof.spouseUid.name] = state.widget.userP.spouseUid;
      update[DocKeyUserprof.hasSpouse.name] = state.widget.userP.hasSpouse;

      if (update.isNotEmpty) {
        //change has been made
        await FirestoreController.updateUserProfile(
            docId: state.widget.userP.docId!, update: update);
      }

      stopCircularProgress(state.context);
    } catch (e) {
      stopCircularProgress(state.context);
      if (Constant.devMode) print('======== failed to get update: $e');
      showSnackBar(
          context: state.context, seconds: 20, message: 'failed to update: $e');
    }
  }

  void updateShare(bool? share) async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null) return;
    if (!currentState.validate()) return;
    currentState.save();

    state.widget.userP.shareBudget = share.toString();

    UserProfile spouseProfile =
        await FirestoreController.getUser(email: state.widget.userP.spouseUid);

    print(spouseProfile.shareBudgetEmail);

    if (spouseProfile.shareBudgetEmail == '') {
      state.widget.userP.shareBudgetEmail = state.widget.userP.spouseUid;
    } else {
      state.widget.userP.shareBudgetEmail = state.widget.userP.email;
    }

    try {
      Map<String, dynamic> update = {};
      //update Firestore doc
      update[DocKeyUserprof.shareBudget.name] = state.widget.userP.shareBudget;
      update[DocKeyUserprof.shareBudgetEmail.name] =
          state.widget.userP.shareBudgetEmail;

      if (update.isNotEmpty) {
        //change has been made
        await FirestoreController.updateUserProfile(
            docId: state.widget.userP.docId!, update: update);
      }

      await Navigator.pushNamed(state.context, ProfileScreen.routeName,
          arguments: {
            ArgKey.profile: state.widget.profile,
            ArgKey.currentUID: state.widget.currentUID,
            ArgKey.isFriendAdded: 'N/A',
            ArgKey.userProfile: state.widget.userP,
          });

      stopCircularProgress(state.context);
    } catch (e) {
      stopCircularProgress(state.context);
      if (Constant.devMode) print('======== failed to get update: $e');
      showSnackBar(
          context: state.context, seconds: 20, message: 'failed to update: $e');
    }
  }

  void getBadgeNumber() async {
    UserProfile friend =
        await FirestoreController.getUser(email: state.widget.profile.email);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Constant.users)
        .doc(friend.docId)
        .collection(Constant.savings)
        .orderBy(DocKeySavings.amount.name, descending: false)
        .get();
    String tmp = '  ';
    Map<String, dynamic> data = {};

    querySnapshot.docs.forEach((e) {
      data = e.data() as Map<String, dynamic>;

      data.forEach((key, value) {
        tmp = value.toString();
        valueList.add(tmp.toString());
      });
    });

    for (int i = 0; i < valueList.length; i++) {
      if (savingsAmt < double.parse(valueList[i])) {
        savingsAmt = double.parse(valueList[i]);
        //print(savingsAmt);
      }
    }
    state.render(() {});
    valueList.clear();
  }

  String getBadge() {
    // return url;
    state.render(() {
      getBadgeNumber();
      //print(savingsAmt);
      double target = 0;
      badgeList.forEach(
        (element) {
          if (element.amount <= savingsAmt) {
            target = element.amount;
            //print(target);
            if (element.amount == target) {
              url = element.badgeUrl;
            }
          }
        },
      );
    });

    return url;
    //return 'https://www.pikpng.com/pngl/b/99-992927_money-emoji-png.png';
  }
}
