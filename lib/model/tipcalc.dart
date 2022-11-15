// ignore_for_file: constant_identifier_names

class TipCalc {
  String? docId;
  String? createBy;
  DateTime? timestamp;
  double? purchaseAmount;
  double? star;
  int? numOfPeople;
  String? note;
  double? totalTip;
  double? totalPay;
  double? tipPerPerson;
  double? amountPerPerson;

  TipCalc({
    this.docId,
    this.createBy,
    this.timestamp,
    this.purchaseAmount,
    this.star,
    this.numOfPeople,
    this.note,
    this.totalTip,
    this.totalPay,
    this.tipPerPerson,
    this.amountPerPerson,
  });

  static const CREATE_BY = 'createdBy';
  static const TIMESTAMP = 'timestamp';
  static const PURCHASE_AMOUNT = 'purchaseAmount';
  static const STAR = 'star';
  static const NUM_OF_PEOPLE = 'numOfPeople';
  static const NOTE = 'note';
  static const TOTAL_TIP = 'totalTip';
  static const TOTAL_PAY = 'totalPay';
  static const TIP_PER_PERSON = 'tipPerPerson';
  static const AMOUNT_PER_PERSON = 'amountPerPerson';

  // serialization
  Map<String, dynamic> toFirestoreDoc() {
    return {
      CREATE_BY: createBy,
      TIMESTAMP: timestamp,
      PURCHASE_AMOUNT: purchaseAmount,
      STAR: star,
      NUM_OF_PEOPLE: numOfPeople,
      NOTE: note,
      TOTAL_TIP: totalTip,
      TOTAL_PAY: totalPay,
      TIP_PER_PERSON: tipPerPerson,
      AMOUNT_PER_PERSON: amountPerPerson,
    };
  }

  // deserialization
  static TipCalc fromFirestoreDoc(
      {required String docId, required Map<String, dynamic> doc}) {
    return TipCalc(
      docId: docId,
      createBy: doc[CREATE_BY],
      timestamp: doc[TIMESTAMP] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
              doc[TIMESTAMP].millisecondsSinceEpoch),
      purchaseAmount: doc[PURCHASE_AMOUNT],
      star: doc[STAR],
      numOfPeople: doc[NUM_OF_PEOPLE],
      note: doc[NOTE],
      totalTip: doc[TOTAL_TIP],
      totalPay: doc[TOTAL_PAY],
      tipPerPerson: doc[TIP_PER_PERSON],
      amountPerPerson: doc[AMOUNT_PER_PERSON],
    );
  }

  static String? validatePurchaseAmount(String? value) {
    if (double.tryParse(value!) == null || double.parse(value) == 0) {
      return 'Insert a number';
    }
    return null;
  }
}
