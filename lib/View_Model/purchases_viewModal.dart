import 'package:flutter/cupertino.dart';

class PurchaseViewModal extends ChangeNotifier {
  List <String> categories = ["item1", "item2", "item3"]; 
  String? validateAmount(String? input){
    if (input == null || input.isEmpty) {
      return "No amount Provided";
    }
    // final amountRegex = RegExp(r'^[0-9]+$');
    try{
        double.parse(input);
        return null;
    } catch(e) {
      return "Amount must be a number";
    }
  
  //   return amountRegex.hasMatch(input) 
  //       ? null
  //       : "Amount must be a number";
  // }
  }

  
}