import 'package:cap_project/viewscreen/view/budgetCategory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetCategoryViewModel extends ChangeNotifier  {
  final TextEditingController textFormValidator = TextEditingController();
  int selectedCategoryIndex = 0;

  List<String> categories = ["Shopping", "Food", "Clothing", 
                            "Housing", "Transportion", "Bills"];

  updateCategories (int value) {
      selectedCategoryIndex = value;
      notifyListeners();
  }

  validateText (String? value) {
    print('at validated text');
    if (value == null) {
      return "Input can not be empty";
    } 
    else if (value.trim().isEmpty) {
      return "Input can't be empty";
    } else {
      return null;
    }
  }
  
  addCategory () {
    categories.add(textFormValidator.text);
    notifyListeners();
  }

  
}