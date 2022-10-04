import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetCategoryViewModel extends ChangeNotifier  {
  List<String> categories = ["Shopping", "Food", "Clothing", 
                            "Housing", "Transportion", "Bill"];
}