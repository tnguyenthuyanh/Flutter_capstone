class UserTransaction {
  static const FROM_UID = 'from_uid';
  static const FROM_EMAIL = 'from_email';
  static const TO_UID = 'to_uid';
  static const TO_EMAIL = 'to_email';
  static const TYPE = 'type';
  static const AMOUNT = 'amount';
  static const TIMESTAMP = 'timestamp';

  String? docId; //firestore auto generated id
  late String from_uid;
  late String from_email;
  late String to_uid;
  late String to_email;
  late double amount;
  late String type;
  DateTime? timestamp;

  UserTransaction({
    this.docId,
    this.from_email = '',
    this.from_uid = '',
    this.to_email = '',
    this.to_uid = '',
    this.type = '',
    this.amount = 0,
    this.timestamp,
  });

  Map<String, dynamic> toFirestoreDoc() {
    return {
      FROM_UID: this.from_uid,
      FROM_EMAIL: this.from_email,
      TO_UID: this.to_uid,
      TO_EMAIL: this.to_email,
      TYPE: this.type,
      AMOUNT: this.amount,
      TIMESTAMP: this.timestamp,
    };
  }

  static UserTransaction? fromFirestoreDoc({
    required Map<String, dynamic> doc,
    required String docId,
  }) {
    for (var key in doc.keys) {
      if (doc[key] == null) return null;
    }
    return UserTransaction(
      docId: docId,
      from_email: doc[FROM_EMAIL],
      from_uid: doc[FROM_UID],
      to_email: doc[TO_EMAIL],
      to_uid: doc[TO_UID],
      type: doc[TYPE],
      amount: doc[AMOUNT],
      timestamp: DateTime.fromMillisecondsSinceEpoch(
          doc[TIMESTAMP].millisecondsSinceEpoch),
    );
  }
}
