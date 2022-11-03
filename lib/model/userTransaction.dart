class UserTransaction {
  static const FROM_UID = 'from_uid';
  static const FROM_EMAIL = 'from_email';
  static const TO_UID = 'to_uid';
  static const TO_EMAIL = 'to_email';
  static const TYPE = 'type';
  static const AMOUNT = 'amount';
  static const TIMESTAMP = 'timestamp';
  static const IS_REQUEST_PAID = 'is_request_paid';
  static const REQUEST_AMOUNT = 'request_amount';

  String? docId; //firestore auto generated id
  late String from_uid;
  late String from_email;
  late String to_uid;
  late String to_email;
  late double amount;
  late String type;
  DateTime? timestamp;
  late int is_request_paid;
  late double request_amount;

  UserTransaction({
    this.docId,
    this.from_email = '',
    this.from_uid = '',
    this.to_email = '',
    this.to_uid = '',
    this.type = '',
    this.amount = 0,
    this.timestamp,
    this.is_request_paid = 0,
    this.request_amount = 0,
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
      IS_REQUEST_PAID: this.is_request_paid,
      REQUEST_AMOUNT: this.request_amount,
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
      request_amount: doc[REQUEST_AMOUNT],
      is_request_paid: doc[IS_REQUEST_PAID],
      timestamp: DateTime.fromMillisecondsSinceEpoch(
          doc[TIMESTAMP].millisecondsSinceEpoch),
    );
  }
}
