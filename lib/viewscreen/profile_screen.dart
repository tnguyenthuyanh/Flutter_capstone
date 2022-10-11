import 'package:cap_project/model/constant.dart';
import 'package:cap_project/viewscreen/view/view_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';

import '../controller/firestore_controller.dart';
import 'editprofile_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/bioScreen';
  final String currentUID;
  final Map profile;

  ProfileScreen({
    required this.currentUID,
    required this.profile,
  });

  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<ProfileScreen> {
  late _Controller con;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
        actions: widget.profile['uid'] == widget.currentUID
            ? [IconButton(onPressed: con.edit, icon: Icon(Icons.edit))]
            : null,
      ),
      body: Column(
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
                    height: 20.0,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.brown.shade100,
                    child: Text(
                      widget.profile['name'] == ""
                          ? "N/A"
                          : widget.profile['name'][0].toUpperCase(),
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Satisfy-Regular',
                        color: Colors.blueAccent,
                      ),
                    ),
                    radius: 50,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    widget.profile['name'] == ""
                        ? "N/A"
                        : widget.profile['name'],
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    widget.profile['email'],
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  widget.profile['uid'] != widget.currentUID
                      ? Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: AnimatedButton(
                            height: 40,
                            width: 100,
                            text: 'Add friend',
                            textStyle:
                                TextStyle(fontSize: 14, color: Colors.white),
                            isReverse: true,
                            selectedTextColor: Colors.black,
                            transitionType: TransitionType.LEFT_TO_RIGHT,
                            // textStyle: submitTextStyle,
                            backgroundColor: Color.fromARGB(255, 52, 117, 98),

                            borderColor: Colors.white,
                            borderRadius: 50,
                            borderWidth: 2,
                            onPress: () {},
                          ),
                        )
                      : SizedBox(),
                  Divider(
                    color: Colors.yellow,
                    height: 30.0, // space betwen top or bottom item
                  ),
                  Container(
                    height: 150,
                    child: Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15.0, vertical: 2.0),
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
                                      widget.profile['bio'],
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 60, 98, 169),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Controller {
  late _ProfileState state;
  _Controller(this.state);

  void edit() async {
    try {
      Map profile =
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
}
