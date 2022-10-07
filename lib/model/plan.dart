enum DocKeyPlan {
  createdBy,
  title,
}

class Plan {
  String? docId;
  late String createdBy;
  late String title;

  Plan({
    this.docId,
    this.createdBy = '',
    this.title = '',
  });

  //serialization
  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyPlan.createdBy.name: createdBy,
      DocKeyPlan.title.name: title,
    };
  }

  //deserialization
  static Plan? fromFirestoreDoc(
      {required Map<String, dynamic> doc, required String docId}) {
    return Plan(
      docId: docId,
      createdBy: doc[DocKeyPlan.createdBy.name] ??= 'N/A',
      title: doc[DocKeyPlan.title.name] ??= 'N/A',
    );
  }

  static String? validateTitle(String? value) {
    return (value == null || value.trim().length < 2)
        ? "Title too short"
        : null;
  }
}//end plan class
