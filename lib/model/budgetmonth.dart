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

  BudgetMonth({
    this.docId,
    required ownerUid,
    required DateTime date,
    required this.templateId,
  }) {
    if (ownerUid.runtimeType == List<String>) {
      ownerUids = ownerUid;
    } else {
      ownerUids.add(ownerUid);
    }

    startDate = EnhancedDateTime.getStartDate(date);
    endDate = EnhancedDateTime.getEndDate(date);
  }

  bool containsDate(DateTime date) {
    return date.isAfter(startDate.dateTime) && date.isBefore(endDate.dateTime);
  }

  String getMonthString() {
    return startDate.monthString;
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
    );

    return temp;
  }

  @override
  Map<String, dynamic> serialize() {
    return {
      DocKeyMonths.ownerUids: ownerUids,
      DocKeyMonths.startDate: startDate.dateTime.toIso8601String(),
      DocKeyMonths.templateId: templateId,
    };
  }
}
