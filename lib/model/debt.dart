enum DocKeyDebt {
  createdby,
  title,
  category,
  balance,
  interest,
  payment,
  original,
}

class Debt {
  String? docId;
  late String createdBy;
  late String title;
  late String category;
  late String balance;
  late String interest;
  late String original;

  Debt({
    this.docId,
    this.createdBy = '',
    this.title = '',
    this.category = '',
    this.balance = '',
    this.interest = '',
    this.original = '',
  });

  Debt.clone(Debt d) {
    docId = d.docId;
    createdBy = d.createdBy;
    title = d.title;
    category = d.category;
    balance = d.balance;
    interest = d.interest;
    original = d.original;
  }

  void copyFrom(Debt d) {
    docId = d.docId;
    createdBy = d.createdBy;
    title = d.title;
    category = d.category;
    balance = d.balance;
    interest = d.interest;
    original = d.original;
  }

  //serialization
  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyDebt.title.name: title,
      DocKeyDebt.createdby.name: createdBy,
      DocKeyDebt.category.name: category,
      DocKeyDebt.balance.name: balance,
      DocKeyDebt.interest.name: interest,
      DocKeyDebt.original.name: original,
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
      original: doc[DocKeyDebt.original.name] ??= 'N/A',
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
    if (value != null) {
      var bal = double.parse(value);
      return (bal < 1) ? "Balance too small" : null;
    }
    return null;
  }

  static String? validateOriginal(String? value) {
    if (value != null) {
      var bal = double.parse(value);
      return (bal < 100) ? "Principal/credit max too small" : null;
    }
    return null;
  }

  static String? validateEditBalance(String? value) {
    if (value != null) {
      String tempVal = value.substring(10);
      var bal = double.parse(tempVal);
      return (bal < 1) ? "Balance too small" : null;
    }
    return null;
  }

  static String? validateInterest(String? value) {
    if (value != null) {
      var bal = double.parse(value);
      return (bal < 1) ? "Balance too small" : null;
    }
    return null;
  }

  static String? validateEditInterest(String? value) {
    if (value != null) {
      String tempVal = value.substring(15, value.length - 1);
      var bal = double.parse(tempVal);
      return (bal < 1) ? "Balance too small" : null;
    }
    return null;
  }

  static String? validateEditOriginal(String? value) {
    if (value != null) {
      String tempVal = value.substring(17, value.length - 1);
      var bal = double.parse(tempVal);
      return (bal < 100) ? "Balance too small" : null;
    }
    return null;
  }
}
