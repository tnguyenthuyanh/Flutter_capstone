// To parse this JSON data, do
//
//     final BudgetAmount = BudgetAmountFromJson(jsonString);

import 'dart:convert';

BudgetAmount BudgetAmountFromJson(String str) => BudgetAmount.fromJson(json.decode(str));

String BudgetAmountToJson(BudgetAmount data) => json.encode(data.toJson());

enum budgetCats {
  owner_id,
  CategoryId,
  CategoryLabel,
  SubCategory,
  SubCategoryLabel,
  amount,
  BudgetAmount_id,
  budgetId,
}

class BudgetAmount {
  BudgetAmount({
    required this.ownerId,
    required this.CategoryId,
    required this.CategoryLabel,
     this.SubCategory,
     this.SubCategoryLabel,
    required this.amount,
    required this.budgetAmountId,
    required this.budgetId,

  });

  String ownerId;
  String CategoryId;
  String CategoryLabel;
  String? SubCategory;
  String? SubCategoryLabel;
  double amount;
  String budgetAmountId;
  String budgetId;

  


  factory BudgetAmount.fromJson(Map<String, dynamic> json) => BudgetAmount(
    ownerId: json[budgetCats.owner_id],
    CategoryId: json[budgetCats.CategoryId],
    CategoryLabel: json[budgetCats.CategoryLabel],
    SubCategory: json[budgetCats.SubCategory],
    SubCategoryLabel: json[budgetCats.SubCategoryLabel],
    amount: json[budgetCats.amount],
    budgetAmountId: json[budgetCats.BudgetAmount_id],
    budgetId: json[budgetCats.budgetId],

  );
  
  Map<String, dynamic> toJson() => {
    "owner_id": ownerId,
    "CategoryId": CategoryId,
    "CategoryLabel": CategoryLabel,
    "SubCategory": SubCategory,
    "SubCategoryLabel": SubCategoryLabel,
    "amount": amount,
    "BudgetAmount_id":budgetAmountId,
    "budgetId":budgetId,
  };

  Map<String, dynamic> toJsonForUpdating(double amount1) => {
    "owner_id": ownerId,
    "CategoryId": CategoryId,
    "CategoryLabel": CategoryLabel,
    "SubCategory": SubCategory,
    "SubCategoryLabel": SubCategoryLabel,
    "amount": amount + amount1,
    "budgetAmountId":budgetAmountId,
    "budgetId":budgetId,
  };

   Map<String, dynamic> toJsonForDeleting(double amount1) => {
    "owner_id": ownerId,
    "CategoryId": CategoryId,
    "CategoryLabel": CategoryLabel,
    "SubCategory": SubCategory,
    "SubCategoryLabel": SubCategoryLabel,
    "amount": amount - amount1,
    "budgetAmountId":budgetAmountId,
    "budgetId":budgetId,
  };

  Map<String, dynamic> toJsonforSubCat() => {
    "SubCategory": SubCategory,
    "SubCategoryLabel": SubCategoryLabel,
    "amount": amount,
  };
}
