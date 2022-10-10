import 'package:cap_project/viewscreen/budgetCategory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oktoast/oktoast.dart';

import '../controller/storagecontrollers/budgetstoragecontroller.dart';
import '../model/catergories.dart';

class BudgetCategoryViewModel extends ChangeNotifier  {
  final TextEditingController textFormValidator = TextEditingController();
  final TextEditingController budgetController = TextEditingController();

  int selectedCategoryIndex = 0;
  int selectedSubCategoryIndex = 0;


  List<String> categories = ["Shopping", "Food", "Clothing",
                            "Housing", "Transportion", "Bills"];
  List<Category> categoriess = [];


  bool isCategoriesLoading = false;
  bool isCategoriesAdding = false;

  updateCategories (int value) {
    for(Category i in categoriess){
      i.isSelected = false;
    }
    print(value);
    categoriess[value].isSelected = true;
    notifyListeners();
  }


  Future<void> getCategories()async{
    try{
      isCategoriesLoading = true;
      notifyListeners();
      categoriess = await BudgetStorageController.getCategories();
      isCategoriesLoading = false;
      notifyListeners();


    }catch(e){
      showToast("Something went wrong in fetching the categories");

      isCategoriesLoading = false;
      notifyListeners();

    }
  }



  updateSubCategories (int value) {
    for(Category i in categoriess){
      i.isSelected = false;
    }
    print(value);
    categoriess[value].isSelected = true;
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
    print('at validated text');
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



  addCategory ()async {

    Category category = Category(type: "user", label: textFormValidator.text.trim(), categoryid: "");
    category.userid = FirebaseAuth.instance.currentUser?.uid;
    textFormValidator.clear();

    try{
      isCategoriesAdding = true;
      notifyListeners();
      await BudgetStorageController.addCategory(category);
      isCategoriesAdding = false;
      notifyListeners();



    }catch(e){
      showToast(e.toString());
    }

    notifyListeners();
  }
  addSubCategory () {
    var subCat = <String>{textFormValidator.text};
    subcategories[getSelectedCategory()].add(subCat);
    textFormValidator.clear();
    notifyListeners();
  }
  deleteCategory(int index)async{
    try{
      await BudgetStorageController.deleteCategory(categoriess[index].categoryid);
      showToast("Category deleted successfully");

      await getCategories();

    }catch(e){
      showToast(e.toString());
    }

    notifyListeners();
  }
  deleteSubCategory(int index){
    if(categoriess[index].type.toLowerCase() == "global"){
      showToast("Global category can't be deleted");
    }
    else{
      subcategories[getSelectedCategory()].removeAt(index);

    }
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