enum DocKeyPurchase {
  createdby,
  amount,
  note,
  transactionType,
}

class Purchase {
  String? docId;
  late String createdBy;
  late String amount;
  late String note;
  late String transactionType;

  Purchase({
    this.docId,
    this.createdBy = '',
    this.amount = '',
    this.note = '',
    this.transactionType = '',
  });

  //serialization
  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyPurchase.amount.name: amount,
      DocKeyPurchase.createdby.name: createdBy,
      DocKeyPurchase.note.name: note,
      DocKeyPurchase.transactionType.name: transactionType,
    };
  }

  //deserialization
  static Purchase? fromFirestoreDoc(
      {required Map<String, dynamic> doc, required String docId}) {
    return Purchase(
      docId: docId,
      createdBy: doc[DocKeyPurchase.createdby.name] ??= 'N/A',
      amount: doc[DocKeyPurchase.amount.name] ??= 'N/A',
      note: doc[DocKeyPurchase.note.name] ??= 'N/A',
      transactionType: doc[DocKeyPurchase.transactionType.name] ??='N/A',
    );
  }

  static String? validateTitle(String? value) {
    return (value == null || value.trim().length < 2)
        ? "Title too short"
        : null;
  }
}
