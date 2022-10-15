// enum DocKeyPlan {
//   createdBy,
//   title,
//   costs,
//   reduction,
//   length,
//   timeStamp,
// }

class Plan {
  static const CREATED_BY = 'createdBy';
  static const TITLE = 'title';
  static const COSTS = 'costs';
  static const REDUCTION = 'reduction';
  static const LENGTH = 'length';
  static const TIMESTAMP = 'timeStamp';

  String? docId;
  late String createdBy;
  late String title;
  late String costs;
  late String reduction;
  late String length;
  DateTime? timeStamp;

  Plan({
    this.docId,
    this.createdBy = '',
    this.title = '',
    this.costs = '',
    this.reduction = '',
    this.length = '',
    this.timeStamp,
  });

  Plan.clone(Plan p) {
    docId = p.docId;
    createdBy = p.createdBy;
    title = p.title;
    costs = p.costs;
    reduction = p.reduction;
    length = p.length;
  }

  void assign(Plan p) {
    docId = p.docId;
    createdBy = p.createdBy;
    title = p.title;
    costs = p.costs;
    reduction = p.reduction;
    length = p.length;
  }

  //serialization
  Map<String, dynamic> toFirestoreDoc() {
    return {
      CREATED_BY: createdBy,
      TITLE: title,
      COSTS: costs,
      REDUCTION: reduction,
      LENGTH: length,
      TIMESTAMP: timeStamp,
    };
  }

  //deserialization
  static Plan? fromFirestoreDoc(
      {required Map<String, dynamic> doc, required String docId}) {
    for (var key in doc.keys) {
      if (doc[key] == null) return null;
    }
    return Plan(
      docId: docId,
      createdBy: doc[CREATED_BY] ??= 'N/A',
      title: doc[TITLE] ??= 'N/A',
      costs: doc[COSTS] ??= 'N/A',
      reduction: doc[REDUCTION] ??= 'N/A',
      length: doc[LENGTH] ??= 'N/A',
    );
  }

  static String? validateTitle(String? value) {
    return (value == null || value.trim().length < 2)
        ? "Title too short"
        : null;
  }
}//end plan class
