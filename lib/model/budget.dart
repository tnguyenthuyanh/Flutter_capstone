class Budget {
  List<String> ownerUIDs = []; // the firebase user docID of the budget owner
  String title; // the user assigned title of the budget
  String? docID; // the firebase docID of the budget
  bool? isCurrent; // is this budget the budget currently selected by the user
  bool dirty = false;

  dynamic get ownerUID => ownerUIDs.length == 1 ? ownerUIDs[0] : ownerUIDs;

  set ownerUID(dynamic value) {
    if (value.runtimeType == List<String>) {
      ownerUIDs = value;
    } else {
      ownerUIDs.add(value);
    }
  }

  Budget({
    required ownerUIDs,
    required this.title,
    this.docID,
    this.isCurrent,
  }) {
    if (ownerUID.runtimeType == String) {
      ownerUIDs.add(ownerUID);
    } else {
      ownerUIDs = ownerUID;
    }
  }

  Budget copyToNew({required String title}) =>
      Budget(ownerUIDs: ownerUIDs, title: title, isCurrent: false);

  Map<String, dynamic> serialize() {
    return {
      'ownerUIDs': ownerUIDs,
      'title': title,
      'isCurrent': isCurrent,
    };
  }

  static Budget? deserialize(
      {required Map<String, dynamic> doc, required docId}) {
    return Budget(
        docID: docId,
        ownerUIDs: doc['ownerUIDs'],
        title: doc['title'],
        isCurrent: doc['isCurrent']);
  }

  bool equals(Budget budget) {
    return docID == budget.docID;
  }

  void addOwner({required String ownerUid}) {
    if (!ownerUIDs.contains(ownerUid)) {
      ownerUIDs.add(ownerUid);
    }
  }

  void removeOwner({required String ownerUid}) {
    if (ownerUIDs.contains(ownerUid)) {
      ownerUIDs.remove(ownerUid);
    }
  }
}
