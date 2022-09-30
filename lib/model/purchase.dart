enum DocKeyPurchase {
  createdby,
  title,
  category,
}

class Purchase {
  String? docId;
  late String createdBy;
  late String title;
  late String category;

  Purchase({
    this.docId,
    this.createdBy = '',
    this.title = '',
    this.category = '',
  });

  //serialization
  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyPurchase.title.name: title,
      DocKeyPurchase.createdby.name: createdBy,
      DocKeyPurchase.category.name: category,
    };
  }

  //deserialization
  static Purchase? fromFirestoreDoc(
      {required Map<String, dynamic> doc, required String docId}) {
    return Purchase(
      docId: docId,
      createdBy: doc[DocKeyPurchase.createdby.name] ??= 'N/A',
      title: doc[DocKeyPurchase.title.name] ??= 'N/A',
      category: doc[DocKeyPurchase.category.name] ??= 'N/A',
    );
  }

  static String? validateTitle(String? value) {
    return (value == null || value.trim().length < 2)
        ? "Title too short"
        : null;
  }
}
