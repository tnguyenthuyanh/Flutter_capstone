enum DocKeyUserprof {
  email,
  likedSports,
  following,
}

class Userprof {
  String? docId; //firestore auto generated id
  late String email;

  Userprof({
    this.docId,
    this.email = '',
  }) {}

  Userprof.set(String mail) {
    email = mail;
  }

  Userprof.clone(Userprof p) {
    docId = p.docId;
    email = p.email;
  }

  //a.copyFrom(b) ==> a = b
  void copyFrom(Userprof p) {
    docId = p.docId;
    email = p.email;
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
