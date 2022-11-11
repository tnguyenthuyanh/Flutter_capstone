import 'package:cap_project/model/catergories.dart';
import 'package:cap_project/model/docKeys/docKeys.dart';
import 'enhanceddatetime.dart';

class BudgetMonth {
  String? docId;
  List<String> ownerUids = [];
  String templateId;
  late EnhancedDateTime startDate;
  late EnhancedDateTime endDate;
  double? totalIncome;
  double? totalExpenses;
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
  }

  bool containsDate(DateTime date) {
    return date.isAfter(startDate.dateTime) && date.isBefore(endDate.dateTime);
  }

  String getMonthString() {
    return startDate.monthString;
  }

  void addCategory(FakeCategory category) {
    categories.add(category);
  }

  @override
  static BudgetMonth deserialize({
    required Map<String, dynamic> doc,
    required String docId,
  }) {
    DateTime? tempDate =
        DateTime.tryParse(doc[DocKeyMonths.startDate] as String);
    tempDate ??= DateTime.now();

    BudgetMonth temp = BudgetMonth(
      docId: docId,
      ownerUid: doc[DocKeyMonths.ownerUids],
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
  }) {}
}
