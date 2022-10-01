import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../View_Model/auth_viewModel.dart';

class ForgotSignIn extends StatefulWidget {
  const ForgotSignIn({Key? key}) : super(key: key);
  static const routeName = '/ForgotSignIn';
  @override
  State<StatefulWidget> createState() => _ForgotName();
}

class _ForgotName extends State<ForgotSignIn> {
  late AuthViewModel authViewModel;
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Email/Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const Text('Provide Email for Reset Password Link'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter email',
                  ),
                   validator: (value) =>  authViewModel.validateEmail(value),
                   controller: authViewModel.emailCon,
                  //onSaved: con.saveEmail,
                ),
              ),

              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  //Navigator.pushNamed(context, ForgotSignIn.routeName);
                  if(formKey.currentState!.validate()){
                    authViewModel.resetPassword(context);
                  }
                },
                child: authViewModel.load_forget_password?Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                  child: CircularProgressIndicator(color: Colors.white,),
                ): Text(
                  'Submit',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
