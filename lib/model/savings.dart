enum DocKeySavings {
  amount,
}

class Savings {
  String? docId;
  late String amount;

  Savings({
    this.docId,
    this.amount = '',
  });

  //serialization
  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeySavings.amount.name: amount,
    };
  }

  //deserialization
  static Savings? fromFirestoreDoc(
      {required Map<String, dynamic> doc, required String docId}) {
    return Savings(
      docId: docId,
      amount: doc[DocKeySavings.amount.name] ??= 'N/A',
    );
  }

  static String? validateTitle(String? value) {
    return (value == null || value.trim().length < 2)
        ? "Title too short"
        : null;
  }
}
