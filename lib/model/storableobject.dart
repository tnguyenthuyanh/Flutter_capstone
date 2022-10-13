abstract class StorableInterface {
  final String ownerUid;
  bool _dirty = false;
  String? docId;

  StorableInterface({required this.ownerUid, this.docId});

  Map<String, dynamic> serialize();
  static Object? deserialize(
      {required Map<String, dynamic> doc, required docId}) {}

  bool isDirty() {
    return _dirty;
  }

  void setDirty(bool isDirty) {
    _dirty = isDirty;
  }

  bool compare(Object object) {
    return identical(this, object);
  }
}
