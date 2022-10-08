import 'package:cap_project/viewscreen/budgetCategory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetCategoryViewModel extends ChangeNotifier  {
  final TextEditingController textFormValidator = TextEditingController();
  final TextEditingController budgetController = TextEditingController();

  int selectedCategoryIndex = 0;
  int selectedSubCategoryIndex = 0;


  List<String> categories = ["Shopping", "Food", "Clothing", 
                            "Housing", "Transportion", "Bills"];

  updateCategories (int value) {
      selectedCategoryIndex = value;
      notifyListeners();
  }
  updateSubCategories (int value) {
    selectedSubCategoryIndex = value;
    notifyListeners();
  }
  getSelectedCategory(){
    return categories[selectedCategoryIndex];
  }


  Map<String,dynamic> subcategories = {
    "Shopping":[
      {"a"},
      {"b"},
      {"c"},


    ],
    "Food":[
      {"a"},
      {"b"},
      {"c"},


    ],
    "Clothing":[
      {"a"},
      {"b"},
    ],
  };

  isLastSubcategory(int counter){
    if(subcategories[getSelectedCategory()] == null && counter == 0){
      return true;
    }
    else if(subcategories[getSelectedCategory()].length == counter){
      return true;
    }
    else{
      return false;
    }
  }

  validateText (String? value) {
    
    if (value == null) {
      return "Input can not be empty";
    } 
    else if (value.trim().isEmpty) {
      return "Input can't be empty";
    } else if(categories.contains(value)){
      return "Category already exist";
    }
    else {
      return null;
    }
  }



  addCategory () {
    categories.add(textFormValidator.text);
    textFormValidator.clear();
    notifyListeners();
  }
  addSubCategory () {
    var subCat = <String>{textFormValidator.text};
    subcategories[getSelectedCategory()].add(subCat);
    textFormValidator.clear();
    notifyListeners();
  }
  deleteCategory(int index){
    categories.removeAt(index);
    notifyListeners();
  }
  deleteSubCategory(int index){
    subcategories[getSelectedCategory()].removeAt(index);
    notifyListeners();
  }
  validateBudget(String? value){
    if(value == null) return "Number is not valid";
    if(value.isEmpty == null) return "Number is not valid";

    try{
      double.parse(value!);
      return null;

    }catch(e){
      return "Number is not valid";
    }
  }
}