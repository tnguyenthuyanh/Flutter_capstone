import 'package:cap_project/controller/auth_controller.dart';
import 'package:cap_project/model/user.dart';
import 'package:cap_project/viewscreen/view/view_util.dart';
import 'package:flutter/material.dart';

import '../controller/firestore_controller.dart';
import '../model/constant.dart';

class TransferMoneyScreen extends StatefulWidget {
  static const routeName = '/transferMoneyScreen';
  final UserInfo profile;

  TransferMoneyScreen({required this.profile});

  @override
  State<StatefulWidget> createState() {
    return _TransferMoneyState();
  }
}

class _TransferMoneyState extends State<TransferMoneyScreen> {
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
        title: Text('Send/Request Money'),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 5),
              TextFormField(
                decoration: InputDecoration(
                  hintText: '${widget.profile.email}',
                ),
                enabled: false,
              ),
              SizedBox(height: 5),
              Text(
                'Amount: ',
                style: TextStyle(color: Colors.green, fontSize: 20),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: '\$',
                ),
                initialValue: con.orgName,
                autocorrect: false,
                onSaved: con.saveName,
                maxLength: 20,
                enabled: editMode,
              ),
              Text(
                'Bio',
                style: TextStyle(color: Colors.green, fontSize: 20),
              ),
              TextFormField(
                decoration: InputDecoration(
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
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  late _TransferMoneyState state;
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

  void update() async {}
}
