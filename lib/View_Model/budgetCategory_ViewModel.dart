import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetCategoryViewModel extends ChangeNotifier  {

  int selectedCategoryIndex = 0;

  List<String> categories = ["Shopping", "Food", "Clothing", 
                            "Housing", "Transportion", "Bills"];

  updateCategories (int value) {
      selectedCategoryIndex = value;
      notifyListeners();
  }

}