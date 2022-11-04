import 'package:cap_project/controller/storagecontrollers/budgetstoragecontroller.dart';
import 'package:cap_project/model/catergories.dart';
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';

class PurchaseViewModal extends ChangeNotifier {
  List <Category> categoriess = [];
  bool load = false;
  late Category selectedCategories;
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

  void getCategories() async{
      try{
        load = true;
        categoriess = await BudgetStorageController.getCategories();
        selectedCategories = categoriess.first;
        notifyListeners();
        load = false; 
      }catch(e){
        load = false;
        notifyListeners();
        showToast(e.toString());
      }
  }


  void onChangedDropDownFn (value) {
    selectedCategories = value; 
    notifyListeners();

  }
}