enum DocKeyDebt {
  createdby,
  title,
  category,
}

class Debt {
  String? docId;
  late String createdBy;
  late String title;
  late String category;

  Debt({
    this.docId,
    this.createdBy = '',
    this.title = '',
    this.category = '',
  });

  //serialization
  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyDebt.title.name: title,
      DocKeyDebt.createdby.name: createdBy,
      DocKeyDebt.category.name: category,
    };
  }

  //deserialization
  static Debt? fromFirestoreDoc(
      {required Map<String, dynamic> doc, required String docId}) {
    return Debt(
      docId: docId,
      createdBy: doc[DocKeyDebt.createdby.name] ??= 'N/A',
      title: doc[DocKeyDebt.title.name] ??= 'N/A',
      category: doc[DocKeyDebt.category.name] ??= 'N/A',
    );
  }

  static String? validateTitle(String? value) {
    return (value == null || value.trim().length < 2)
        ? "Title too short"
        : null;
  }
}
