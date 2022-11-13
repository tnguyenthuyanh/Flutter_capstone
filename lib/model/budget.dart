class Budget {
  List<String> ownerUIDs = []; // the firebase user docID of the budget owner
  String title; // the user assigned title of the budget
  String? docID; // the firebase docID of the budget
  bool _isCurrent =
      false; // is this budget the budget currently selected by the user
  bool dirty = false;

  Budget({
    required ownerUID,
    required this.title,
    this.docID,
    isCurrent,
  }) {
    if (ownerUID.runtimeType == String) {
      ownerUIDs.add(ownerUID);
    } else {
      ownerUIDs = ownerUID;
    }

    _isCurrent = isCurrent;
  }

  /*----------------------------------------------------------------------------
    Getters/Setters
  ----------------------------------------------------------------------------*/
  dynamic get ownerUID => ownerUIDs.length == 1 ? ownerUIDs[0] : ownerUIDs;

  set ownerUID(dynamic value) {
    if (value.runtimeType == List<String>) {
      ownerUIDs = value;
    } else {
      ownerUIDs.add(value);
    }
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

  set isCurrent(bool value) {
    if (value != _isCurrent) {
      _isCurrent = value;
      dirty = true;
    }
  }

  bool get isCurrent => _isCurrent;

  /*----------------------------------------------------------------------------
    Overrides/helpers
  ----------------------------------------------------------------------------*/
  bool equals(Budget budget) {
    return docID == budget.docID;
  }

  @override
  String toString() {
    String ownerString = 'owners: ';
    for (String owner in ownerUIDs) {
      ownerString += "$owner ";
    }

    return "Title: $title, $ownerString, docId: $docID, isCurrent: $isCurrent, dirty: $dirty";
  }

  /*----------------------------------------------------------------------------
    Serialization/Deserialization
  ----------------------------------------------------------------------------*/
  Map<String, dynamic> serialize() {
    return {
      'ownerUIDs': ownerUIDs,
      'title': title,
      'isCurrent': isCurrent,
    };
  }

  static Budget? deserialize({
    required Map<String, dynamic> doc,
    required docId,
  }) {
    List<String> ownerIds = [];
    for (String id in doc['ownerUIDs']) {
      ownerIds.add(id);
    }

    return Budget(
        docID: docId,
        ownerUID: ownerIds,
        title: doc['title'],
        isCurrent: doc['isCurrent']);
  }
}
