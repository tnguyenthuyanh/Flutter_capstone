// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class FullWidthSizedBox extends StatelessWidget {
  Widget child;

  FullWidthSizedBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: child,
    );
  }
}
