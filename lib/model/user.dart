enum DocKeyUserprof {
  email,
  debt,
}

class Userprof {
  String? docId; //firestore auto generated id
  late String email;
  late List<dynamic> debts;

  Userprof({
    this.docId,
    this.email = '',
  }) {
    this.debts = debts == null ? [] : [...debts];
  }

  Userprof.set(String mail) {
    email = mail;
  }

  Userprof.clone(Userprof p) {
    docId = p.docId;
    email = p.email;
    debts = [...debts];
  }

  //a.copyFrom(b) ==> a = b
  void copyFrom(Userprof p) {
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
  static Userprof? fromFirestoreDoc(
      {required Map<String, dynamic> doc, required String docId}) {
    return Userprof(
      docId: docId,
      email: doc[DocKeyUserprof.email.name] ??= 'N/A',
    );
  }
}
