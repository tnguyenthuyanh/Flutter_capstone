class Budget {
  String ownerUID; // the firebase user docID of the budget owner
  String title; // the user assigned title of the budget
  String? docID; // the firebase docID of the budget
  bool? isCurrent; // is this budget the budget currently selected by the user
  bool dirty = false;

  Budget({
    required this.ownerUID,
    required this.title,
    this.docID,
    this.isCurrent,
  });

  Budget copyToNew({required String title}) =>
      Budget(ownerUID: ownerUID, title: title, isCurrent: false);

  Map<String, dynamic> serialize() {
    return {
      'ownerUID': ownerUID,
      'title': title,
      'isCurrent': isCurrent,
    };
  }

  static Budget? deserialize(
      {required Map<String, dynamic> doc, required docId}) {
    return Budget(
        docID: docId,
        ownerUID: doc['ownerUID'],
        title: doc['title'],
        isCurrent: doc['isCurrent']);
  }

  bool equals(Budget budget) {
    return docID == budget.docID;
  }
}
