enum DocKeyUserprof {
  email,
  debts,
  purchases,
}

class UserProfile {
  String? docId; //firestore auto generated id
  late String email;
  late List<dynamic> debts;
  late List<dynamic> purchases;

  UserProfile({
    this.docId,
    this.email = '',
    List<dynamic>? debts,
    List<dynamic>? purchases,
  }) {
    this.debts = debts == null ? [] : [...debts];
    this.purchases = purchases == null ? [] : [...purchases];
  }

  UserProfile.set(String mail) {
    email = mail;
  }

  UserProfile.clone(UserProfile p) {
    docId = p.docId;
    email = p.email;
    debts = [...debts];
    purchases = [...purchases];
  }

  //a.copyFrom(b) ==> a = b
  void copyFrom(UserProfile p) {
    docId = p.docId;
    email = p.email;
    debts.clear();
    debts.addAll(p.debts);
    purchases.clear();
    purchases.addAll(p.purchases);
  }

  //serialization
  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyUserprof.email.name: email,
    };
  }

  //deserialization
  static UserProfile? fromFirestoreDoc(
      {required Map<String, dynamic> doc, required String docId}) {
    return UserProfile(
      docId: docId,
      email: doc[DocKeyUserprof.email.name] ??= 'N/A',
      debts: doc[DocKeyUserprof.debts.name] ??= [],
      purchases: doc[DocKeyUserprof.purchases.name] ??= [],
    );
  }
}
