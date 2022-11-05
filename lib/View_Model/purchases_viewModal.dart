import 'package:cap_project/controller/storagecontrollers/budgetstoragecontroller.dart';
import 'package:cap_project/model/catergories.dart';
import 'package:cap_project/model/subcategories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class PurchaseViewModal extends ChangeNotifier {
  List<Category> categoriess = [];
  List<SubCategory> subcategoriess = [];
  bool load = false;
  bool subcatLoad = false;
  late Category selectedCategories;
  late SubCategory selectedsubCategories;
  String? validateAmount(String? input) {
    if (input == null || input.isEmpty) {
      return "No amount Provided";
    }
    // final amountRegex = RegExp(r'^[0-9]+$');
    try {
      double.parse(input);
      return null;
    } catch (e) {
      return "Amount must be a number";
    }

    //   return amountRegex.hasMatch(input)
    //       ? null
    //       : "Amount must be a number";
    // }
  }

  void getCategories() async {
    try {
      print('hello from getcats');
      load = true;
      notifyListeners();
      categoriess = await BudgetStorageController.getCategories();
      selectedCategories = categoriess.first;
      notifyListeners();
      load = false;
      getSubCategories();
    } catch (e) {
      load = false;
      notifyListeners();
      showToast(e.toString());
    }
  }

  void getSubCategories() async {
    try {
      subcatLoad = true;
      selectedsubCategories = SubCategory(subcategoryid: "", label: "Select", categoryid: "");
      
      subcategoriess = await BudgetStorageController.getSubCategories(
          selectedCategories.categoryid);
      subcategoriess.insert(0, selectedsubCategories);
      // if (subcategoriess.isEmpty ) {
      //   subcatLoad = false;
      //   notifyListeners();
      //   selectedsubCategories = SubCategory(subcategoryid: "", label: "does not exist", categoryid: "");
      //   subcategoriess.add(selectedsubCategories);
      //   return;
      // }
      if (subcategoriess.isNotEmpty) {
        selectedsubCategories = subcategoriess.first;
        notifyListeners();
        subcatLoad = false;
      }
      subcatLoad = false;
      notifyListeners();
    } catch (e) {
      subcatLoad = false;
      notifyListeners();
      showToast(e.toString());
    }
  }

  void onChangedDropDownFn(value) {
    selectedCategories = value;
    getSubCategories();
    notifyListeners();
  }

  void onChangedSubCatDropDownFn(value) {
    selectedsubCategories = value;
    notifyListeners();
  }
}
