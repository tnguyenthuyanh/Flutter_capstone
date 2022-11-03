class Wallet {
  static const CARD_NUMBER = 'card_number';
  static const EXP = 'expired_date';
  static const CVV = 'cvv';
  static const HOLDER_NAME = 'holder_name';
  static const CARD_SAVED = 'card_saved';
  static const BALANCE = 'balance';
  static const UID = 'uid';
  static const EMAIL = 'email';

  String? docId; //firestore auto generated id
  late String card_number;
  late String exp;
  late String cvv;
  late String holder_name;
  late int card_saved;
  late double balance;
  late String uid;
  late String email;

  Wallet({
    this.docId,
    this.card_saved = 0,
    this.card_number = '',
    this.exp = '',
    this.cvv = '',
    this.holder_name = '',
    this.balance = 0,
    this.uid = '',
    this.email = '',
  });

  Map<String, dynamic> toFirestoreDoc() {
    return {
      CARD_NUMBER: this.card_number,
      EXP: this.exp,
      CVV: this.cvv,
      HOLDER_NAME: this.holder_name,
      CARD_SAVED: this.card_saved,
      BALANCE: this.balance,
      UID: this.uid,
      EMAIL: this.email,
    };
  }

  static Wallet? fromFirestoreDoc({
    required Map<String, dynamic> doc,
    required String docId,
  }) {
    for (var key in doc.keys) {
      if (doc[key] == null) return null;
    }
    return Wallet(
      docId: docId,
      card_number: doc[CARD_NUMBER],
      exp: doc[EXP],
      cvv: doc[CVV],
      holder_name: doc[HOLDER_NAME],
      card_saved: doc[CARD_SAVED],
      balance: doc[BALANCE],
      uid: doc[UID],
      email: doc[EMAIL],
    );
  }
}
