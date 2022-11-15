// To parse this JSON data, do
//
//     final BudgetAmount = BudgetAmountFromJson(jsonString);

// ignore_for_file: file_names, non_constant_identifier_names, camel_case_types, constant_identifier_names

import 'dart:convert';

BudgetAmount BudgetAmountFromJson(String str) =>
    BudgetAmount.fromJson(json.decode(str));

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

extension ParseToString on budgetCats {
  String toShortString() {
    return this.toString().split('.').last;
  }
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

  factory BudgetAmount.fromJson(Map<String, dynamic> json) {
    print(json);
    return BudgetAmount(
      ownerId: json[budgetCats.owner_id.toShortString()],
      CategoryId: json[budgetCats.CategoryId.toShortString()],
      CategoryLabel: json[budgetCats.CategoryLabel.toShortString()],
      SubCategory: json[budgetCats.SubCategory.toShortString()],
      SubCategoryLabel: json[budgetCats.SubCategoryLabel.toShortString()],
      amount: double.parse(json[budgetCats.amount.toShortString()].toString()),
      budgetAmountId: json[budgetCats.BudgetAmount_id.toShortString()],
      budgetId: json[budgetCats.budgetId.toShortString()],
    );
  }

  Map<String, dynamic> toJson() => {
        budgetCats.owner_id.toShortString(): ownerId,
        budgetCats.CategoryId.toShortString(): CategoryId,
        budgetCats.CategoryLabel.toShortString(): CategoryLabel,
        budgetCats.SubCategory.toShortString(): SubCategory,
        budgetCats.SubCategoryLabel.toShortString(): SubCategoryLabel,
        budgetCats.amount.toShortString(): amount,
        budgetCats.BudgetAmount_id.toShortString(): budgetAmountId,
        budgetCats.budgetId.toShortString(): budgetId,
      };

  Map<String, dynamic> toJsonForUpdating(double amount1,
          {double oldAmount = 0}) =>
      {
        budgetCats.owner_id.toShortString(): ownerId,
        budgetCats.CategoryId.toShortString(): CategoryId,
        budgetCats.CategoryLabel.toShortString(): CategoryLabel,
        budgetCats.SubCategory.toShortString(): SubCategory,
        budgetCats.SubCategoryLabel.toShortString(): SubCategoryLabel,
        budgetCats.amount.toShortString(): (amount + amount1) - oldAmount,
        // budgetCats.BudgetAmount_id.toShortString(): budgetAmountId,
        budgetCats.budgetId.toShortString(): budgetId,
      };

  Map<String, dynamic> toJsonForDeleting(double amount1) => {
        budgetCats.owner_id.toShortString(): ownerId,
        budgetCats.CategoryId.toShortString(): CategoryId,
        budgetCats.CategoryLabel.toShortString(): CategoryLabel,
        budgetCats.SubCategory.toShortString(): SubCategory,
        budgetCats.SubCategoryLabel.toShortString(): SubCategoryLabel,
        budgetCats.amount.toShortString(): amount - amount1,
        // budgetCats.BudgetAmount_id.toShortString(): budgetAmountId,
        budgetCats.budgetId.toShortString(): budgetId,
      };

  Map<String, dynamic> toJsonforSubCat() => {
        budgetCats.SubCategory.toShortString(): SubCategory,
        budgetCats.SubCategoryLabel.toShortString(): SubCategoryLabel,
        budgetCats.amount.toShortString(): amount,
      };
}
