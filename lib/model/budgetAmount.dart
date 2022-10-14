// To parse this JSON data, do
//
//     final BudgetAmount = BudgetAmountFromJson(jsonString);

import 'dart:convert';

BudgetAmount BudgetAmountFromJson(String str) => BudgetAmount.fromJson(json.decode(str));

String BudgetAmountToJson(BudgetAmount data) => json.encode(data.toJson());

class BudgetAmount {
  BudgetAmount({
    required this.ownerId,
    required this.CategoryId,
    required this.CategoryLabel,
     this.SubCategory,
     this.SubCategoryLabel,
    required this.amount,
    required this.budgetAmountId,

  });

  String ownerId;
  String CategoryId;
  String CategoryLabel;
  String? SubCategory;
  String? SubCategoryLabel;
  double amount;
  String budgetAmountId;


  factory BudgetAmount.fromJson(Map<String, dynamic> json) => BudgetAmount(
    ownerId: json["owner_id"],
    CategoryId: json["BudgetAmount_id"],
    CategoryLabel: json["BudgetAmount_label"],
    SubCategory: json["sub_BudgetAmount"],
    SubCategoryLabel: json["sub_BudgetAmount_label"],
    amount: json["amount"],
    budgetAmountId: json["budgetAmountId"],

  );

  Map<String, dynamic> toJson() => {
    "owner_id": ownerId,
    "CategoryId": CategoryId,
    "CategoryLabel": CategoryLabel,
    "SubCategory": SubCategory,
    "SubCategoryLabel": SubCategoryLabel,
    "amount": amount,
    "budgetAmountId":budgetAmountId
  };
}
