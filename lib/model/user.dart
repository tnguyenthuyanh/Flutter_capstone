enum DocKeyUserprof {
  email,
  debts,
}

class UserProfile {
  String? docId; //firestore auto generated id
  late String email;
  late List<dynamic> debts;

  UserProfile({
    this.docId,
    this.email = '',
    List<dynamic>? debts,
  }) {
    this.debts = debts == null ? [] : [...debts];
  }

  UserProfile.set(String mail) {
    email = mail;
  }

  UserProfile.clone(UserProfile p) {
    docId = p.docId;
    email = p.email;
    debts = [...debts];
  }

  //a.copyFrom(b) ==> a = b
  void copyFrom(UserProfile p) {
    docId = p.docId;
    email = p.email;
    debts.clear();
    debts.addAll(p.debts);
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
    );
  }
}
