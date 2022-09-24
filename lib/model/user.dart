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

class UserInfo {
  static const UID = 'uid';
  static const EMAIL = 'email';
  static const NAME = 'name';
  static const BIO = 'bio';

  String? docId; //firestore auto generated id
  late String email;
  late String name;
  late String bio;
  late String uid;

  UserInfo({
    this.docId,
    this.uid = '',
    this.name = '',
    this.bio = '',
    this.email = '',
  });

  static UserInfo? fromFirestoreDoc({
    required Map<String, dynamic> doc,
    required String docId,
  }) {
    for (var key in doc.keys) {
      if (doc[key] == null) return null;
    }
    return UserInfo(
      docId: docId,
      uid: doc[UID],
      name: doc[NAME] ??= 'N/A', // if null give a value as 'N/A'
      bio: doc[BIO] ??= 'N/A',
      email: doc[EMAIL],
    );
  }
}
