import 'package:cap_project/controller/storagecontrollers/budgetstoragecontroller.dart';
import 'package:cap_project/model/budgetAmount.dart';
import 'package:cap_project/model/subcategories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../model/catergories.dart';

class BudgetCategoryViewModel extends ChangeNotifier  {
  final TextEditingController textFormValidator = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  String? selectedBudgetId = null;
  int selectedCategoryIndex = 0;
  int selectedSubCategoryIndex = 0;


  List<String> categories = ["Shopping", "Food", "Clothing",
                            "Housing", "Transportion", "Bills"];
  List<Category> categoriess = [];
  List<SubCategory> subCategoriess = [];



  bool isCategoriesLoading = false;
  bool isBudgetAdding = false;
  bool isSubCategoriesLoading = false;

  bool isCategoriesAdding = false;
  bool isSubCategoriesAdding = false;

  updateCategories (int value) {
    for(Category i in categoriess){
      i.isSelected = false;
    }
    print(value);
    categoriess[value].isSelected = true;
    getSubCategories();
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


  Future<void> getSubCategories()async{
    try{

      Iterable<Category> subcategorytemp = categoriess.where((element) => element.isSelected == true);

      if(subcategorytemp.isNotEmpty){
        isSubCategoriesLoading = true;
        notifyListeners();

        subCategoriess = await BudgetStorageController.getSubCategories(subcategorytemp.first.categoryid);
        isSubCategoriesLoading = false;
        notifyListeners();

      }




    }catch(e){
      showToast("Something went wrong in fetching the sub categories");
      print("in error");

      print(e);
      isSubCategoriesLoading = false;
      notifyListeners();

    }
  }
  updateSubCategories (int value) {
    for(SubCategory i in subCategoriess){
      i.isSelected = false;
    }
    print(value);
    subCategoriess[value].isSelected = true;
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
      isCategoriesAdding = false;

      showToast(e.toString());
    }

    notifyListeners();
  }

  addBudgetAmount ()async {



    try{
      Iterable<Category> categorytemp = categoriess.where((element) => element.isSelected == true);
      if (categories.isNotEmpty) {

      }
      Iterable<SubCategory> subcategorytemp = subCategoriess.where((element) => element.isSelected == true);
      if(categorytemp.isNotEmpty && selectedBudgetId!=null){
        BudgetAmount budgetAmount = await BudgetAmount(ownerId: FirebaseAuth.instance.currentUser!.uid, CategoryId: categorytemp.first.categoryid, CategoryLabel: categorytemp.first.label,
         amount: double.parse(budgetController.text), budgetAmountId: "",SubCategory: subcategorytemp.isEmpty?null:subcategorytemp.first.subcategoryid,SubCategoryLabel: subcategorytemp.isEmpty?null:subcategorytemp.first.label);
        //BudgetAmount budgetAmount = await BudgetAmount(ownerId: FirebaseAuth.instance.currentUser!.uid, CategoryId: categorytemp.first.categoryid, CategoryLabel: categorytemp.first.label, amount: double.parse(budgetController.text), budgetAmountId: "",SubCategory: "",SubCategoryLabel: "");
        budgetController.clear();
        isBudgetAdding = true;
        notifyListeners();
        bool status = await BudgetStorageController.addBudgetAmount(budgetAmount,selectedBudgetId!);
        if(status){
          showToast("Budget amount added successfully!");
        }
        
        isBudgetAdding = false;
        notifyListeners();

      }
      else{
        showToast("please select the categories");
      }




    }catch(e){
      isCategoriesAdding = false;

      showToast(e.toString());
    }

    notifyListeners();
  }


  deleteSubCategoryy(int index)async{
    try{
      print(subCategoriess[index].toJson());
      await BudgetStorageController.deleteSubCategories(subCategoriess[index]);
      showToast("sub Category deleted successfully");

      await getSubCategories();

    }catch(e){
      showToast(e.toString());
    }

    notifyListeners();
  }


  addSubCategoryy ()async {

    Iterable<Category> subcategorytemp = categoriess.where((element) => element.isSelected == true);


    try{
      Iterable<Category> subcategorytemp = categoriess.where((element) => element.isSelected == true);
      if(subcategorytemp.isNotEmpty){
        SubCategory subCategory = SubCategory(subcategoryid: "", label: textFormValidator.text.trim(), categoryid: subcategorytemp.first.categoryid,userid: FirebaseAuth.instance.currentUser?.uid);
        textFormValidator.clear();
        isSubCategoriesAdding = true;
        notifyListeners();
        await BudgetStorageController.addSubCategory(subCategory);
        isSubCategoriesAdding = false;
        notifyListeners();


      }
      else{
        showToast("Please select category to add subcategory");
      }



    }catch(e){
      isSubCategoriesAdding = false;
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
      await getSubCategories();


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