// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:cap_project/controller/auth_controller.dart';
import 'package:cap_project/model/user.dart';
import 'package:cap_project/viewscreen/view/view_util.dart';
import 'package:flutter/material.dart';

import '../controller/firestore_controller.dart';
import '../model/constant.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/editProfileScreen';
  final UserInfo profile;

  EditProfileScreen({required this.profile});

  @override
  State<StatefulWidget> createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfileScreen> {
  late _Controller con;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool editMode = false;

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
        title: const Text('Edit Profile'),
        actions: [
          editMode
              ? IconButton(onPressed: con.update, icon: const Icon(Icons.check))
              : IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: con.edit,
                )
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 5),
              TextFormField(
                decoration: InputDecoration(
                  hintText: widget.profile.email,
                ),
                enabled: false,
              ),
              const SizedBox(height: 5),
              const Text(
                'Name',
                style: TextStyle(color: Colors.green, fontSize: 20),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
                initialValue: con.orgName,
                autocorrect: false,
                onSaved: con.saveName,
                maxLength: 20,
                enabled: editMode,
              ),
              const Text(
                'Bio',
                style: TextStyle(color: Colors.green, fontSize: 20),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Introduce yourself...',
                ),
                initialValue: con.orgBio,
                autocorrect: false,
                onSaved: con.saveBio,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                maxLength: 200,
                enabled: editMode,
              ),
              const SizedBox(
                height: 20.0,
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirmation'),
                        content: const Text(
                            'Are you sure you want to delete this account?'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: con.deleteAccount,
                            child: const Text('Yes'),
                          ),
                        ],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                    child: Text(
                      'Delete Account',
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  late _EditProfileState state;
  late String orgName;
  late String orgBio;
  late String uid;

  _Controller(this.state) {
    orgName = state.widget.profile.name;
    orgBio = state.widget.profile.bio;
    uid = state.widget.profile.uid;
  }

  String? name;
  String? bio;

  void saveName(String? value) {
    if (value != null) name = value;
  }

  void saveBio(String? value) {
    if (value != null) bio = value;
  }

  void edit() async {
    state.render(() => state.editMode = true);
  }

  void update() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    startCircularProgress(state.context);

    try {
      await FirestoreController.addUpdateProfile(
          uid: state.widget.profile.uid, name: name!, bio: bio!);
      stopCircularProgress(state.context);
      state.render(() => state.editMode = false);
      Navigator.of(state.context).pop();
      Navigator.of(state.context).pop();
    } catch (e) {
      stopCircularProgress(state.context);
      // ignore: avoid_print
      if (Constant.devMode) print('====== update bio error: $e');
      showSnackBar(
        context: state.context,
        message: 'Update bio error: $e',
      );
    }
  }

  void deleteAccount() async {
    await FirestoreController.deleteProfile(uid: uid);
    await AuthController.deleteAccount();
    Navigator.of(state.context).pop();
    Navigator.of(state.context).pop();
    Navigator.of(state.context).pop();
    Navigator.of(state.context).pop();
  }
}
