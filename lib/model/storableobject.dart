abstract class StorableInterface {
  String? docId;
  String title;
  final String ownerUid;
  bool _dirty = false;
  bool? isCurrent = false;

  StorableInterface(
      {required this.ownerUid,
      required this.title,
      this.docId,
      this.isCurrent});

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
