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
