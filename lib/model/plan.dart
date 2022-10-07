enum DocKeyPlan {
  createdBy,
  title,
  costs,
  reduction,
  length,
  timeStamp,
}

class Plan {
  String? docId;
  late String createdBy;
  late String title;
  late double costs;
  late String reduction;
  late double length;
  DateTime? timeStamp;

  Plan({
    this.docId,
    this.createdBy = '',
    this.title = '',
    this.costs = 0,
    this.reduction = '',
    this.length = 0,
    this.timeStamp,
  });

  //serialization
  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyPlan.createdBy.name: createdBy,
      DocKeyPlan.title.name: title,
      DocKeyPlan.costs.name: costs,
      DocKeyPlan.reduction.name: reduction,
      DocKeyPlan.length.name: length,
      DocKeyPlan.timeStamp.name: timeStamp,
    };
  }

  //deserialization
  static Plan? fromFirestoreDoc(
      {required Map<String, dynamic> doc, required String docId}) {
    return Plan(
        docId: docId,
        createdBy: doc[DocKeyPlan.createdBy.name] ??= 'N/A',
        title: doc[DocKeyPlan.title.name] ??= 'N/A',
        costs: doc[DocKeyPlan.costs.name] ??= 'N/A',
        reduction: doc[DocKeyPlan.reduction.name] ??= 'N/A',
        length: doc[DocKeyPlan.length.name] ??= 'N/A',
        timeStamp: doc[DocKeyPlan.timeStamp] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                doc[DocKeyPlan.timeStamp].millisecondsSinceEpoch)
            : DateTime.now());
  }

  static String? validateTitle(String? value) {
    return (value == null || value.trim().length < 2)
        ? "Title too short"
        : null;
  }
}//end plan class
