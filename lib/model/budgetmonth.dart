// ignore_for_file: constant_identifier_names

import 'package:cap_project/model/budgetAmount.dart';
import 'package:cap_project/model/docKeys/docKeys.dart';
import 'enhanceddatetime.dart';

class BudgetMonth {
  String? docId;
  List<String> ownerUids = [];
  String templateId;
  late EnhancedDateTime startDate;
  late EnhancedDateTime endDate;
  double totalIncome;
  double totalExpenses;
  late List<BudgetAmount> amounts;
  late List<FakeCategory> categories;

  BudgetMonth({
    this.docId,
    required ownerUid,
    required DateTime date,
    required this.templateId,
    this.totalIncome = 0,
    this.totalExpenses = 0,
  }) {
    if (ownerUid.runtimeType == List<String>) {
      ownerUids = ownerUid;
    } else {
      ownerUids.add(ownerUid);
    }

    startDate = EnhancedDateTime.getStartDate(date);
    endDate = EnhancedDateTime.getEndDate(date);
    categories = [];
    amounts = [];
  }

  bool containsDate(DateTime date) {
    return date.isAfter(startDate.dateTime) && date.isBefore(endDate.dateTime);
  }

  String getMonthString() {
    return startDate.monthString;
  }

  void addAmount(FakeCategory amount) {
    categories.add(amount);
    updateTotals();
  }

  void updateTotals() {
    // TODO: Fix implementation

    totalExpenses = 0;
    totalIncome = 0;

    for (FakeCategory category in categories) {
      if (category.categoryType == FakeCategory.EXPENSE_TYPE) {
        totalExpenses += category.amount;
      } else {
        totalIncome += category.amount;
      }
    }
  }

  @override
  static BudgetMonth deserialize({
    required Map<String, dynamic> doc,
    required String docId,
  }) {
    DateTime? tempDate =
        DateTime.tryParse(doc[DocKeyMonths.startDate] as String);
    tempDate ??= DateTime.now();

    List<String> ownerUIds = [];
    for (String uid in doc[DocKeyMonths.ownerUids]) {
      ownerUIds.add(uid);
    }

    BudgetMonth temp = BudgetMonth(
      docId: docId,
      ownerUid: ownerUIds,
      date: tempDate,
      templateId: doc[DocKeyMonths.templateId],
      totalExpenses: doc[DocKeyMonths.totalExpense],
      totalIncome: doc[DocKeyMonths.totalIncome],
    );

    return temp;
  }

  @override
  Map<String, dynamic> serialize() {
    return {
      DocKeyMonths.ownerUids: ownerUids,
      DocKeyMonths.startDate: startDate.dateTime.toIso8601String(),
      DocKeyMonths.templateId: templateId,
      DocKeyMonths.totalExpense: totalExpenses,
      DocKeyMonths.totalIncome: totalIncome,
    };
  }
}

class FakeCategory {
  static const int EXPENSE_TYPE = -1;
  static const int INCOME_TYPE = 1;

  String title;
  double amount;
  int categoryType;

  FakeCategory({
    required this.title,
    required this.amount,
    required this.categoryType,
  });
}
