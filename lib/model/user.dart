enum DocKeyUserprof {
  email,
  likedSports,
  following,
  uid,
  number
}

class Userprof {
  String? uid; //firestore auto generated id
  late String email;
  late String number;

  Userprof({
    this.uid,
    this.email = '',
  }) {}

  Userprof.set(String email,String number) {
    this.email = email;
    this.number = number;
  }

  Userprof.clone(Userprof p) {
    uid = p.uid;
    email = p.email;
    number = p.number;
  }

  //a.copyFrom(b) ==> a = b
  void copyFrom(Userprof p) {
    uid = p.uid;
    email = p.email;
    number = p.number;
  }

  //serialization
  Map<String, dynamic> toFirestoreDoc() {
    return {
      DocKeyUserprof.email.name: email,
      DocKeyUserprof.number.name: number,
      DocKeyUserprof.uid.name: uid,

    };
  }

  //deserialization
  static Userprof? fromFirestoreDoc(
      {required Map<String, dynamic> doc, required String docId}) {
    return Userprof(
      uid: docId,
      email: doc[DocKeyUserprof.email.name] ??= 'N/A',
    );
  }
}
