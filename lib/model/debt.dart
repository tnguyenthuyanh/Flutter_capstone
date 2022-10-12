enum DocKeyDebt { createdby, title, category, balance, interest, payment }

class Debt {
  String? docId;
  late String createdBy;
  late String title;
  late String category;
  late String balance;
  late String interest;

  Debt({
    this.docId,
    this.createdBy = '',
    this.title = '',
    this.category = '',
    this.balance = '',
    this.interest = '',
  });

  Debt.clone(Debt d) {
    docId = d.docId;
    createdBy = d.createdBy;
    title = d.title;
    category = d.category;
    balance = d.balance;
    interest = d.interest;
  }

  void copyFrom(Debt d) {
    docId = d.docId;
    createdBy = d.createdBy;
    title = d.title;
    category = d.category;
    balance = d.balance;
    interest = d.interest;
  }

  //serialization
  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyDebt.title.name: title,
      DocKeyDebt.createdby.name: createdBy,
      DocKeyDebt.category.name: category,
      DocKeyDebt.balance.name: balance,
      DocKeyDebt.interest.name: interest,
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
      balance: doc[DocKeyDebt.balance.name] ??= 'N/A',
      interest: doc[DocKeyDebt.interest.name] ??= 'N/A',
    );
  }

  static String? validateTitle(String? value) {
    return (value == null || value.trim().length < 2)
        ? "Title too short"
        : null;
  }

  static String? validatePayment(String? value) {
    return (value == null || value.trim().length < 2)
        ? "Payment too small"
        : null;
  }

  static String? validateBalance(String? value) {
    var bal = double.parse(value!);
    return (bal < 1) ? "Balance too small" : null;
  }

  static String? validateInterest(String? value) {
    var bal = double.parse(value!);
    return (bal < .1) ? "Balance too small" : null;
  }
}
