import 'package:cap_project/viewscreen/tools_screen/view/star_rating.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TipCalculatorScreen extends StatefulWidget {
  static const routeName = '/tipCalculatorScreen';

  const TipCalculatorScreen({required this.user, Key? key}) : super(key: key);
  final User user;

  @override
  State<StatefulWidget> createState() {
    return _TipCalculatorState();
  }
}

class _TipCalculatorState extends State<TipCalculatorScreen> {
  late _Controller con;
  double rating = 0;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    final Object? args = ModalRoute.of(context)!.settings.arguments;
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Tip Calculator"),
          ),
          body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(hintText: "Amount"),
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                      ),
                      StarRating(
                        rating: rating,
                        onRatingChanged: (rating) => setState(() => this.rating = rating),
                        color: Colors.cyan,
                      )
                    ],
                  ),
                ),
              ))),
    );
  }
}

class _Controller {
  _TipCalculatorState state;
  _Controller(this.state);
}
