import 'package:cap_project/model/storableobject.dart';

class Account extends StorableInterface {
  String title; // the user assigned title of the budget
  bool? isCurrent; // is this budget the budget currently selected by the user

  Account({
    required ownerUid,
    required this.title,
    String? docId,
    this.isCurrent,
  }) : super(ownerUid: ownerUid);

  Account copyToNew({required String title}) =>
      Account(ownerUid: ownerUid, title: title, isCurrent: false);

  @override
  Map<String, dynamic> serialize() {
    return {
      'ownerUID': ownerUid,
      'title': title,
      'isCurrent': isCurrent,
    };
  }

  static Account? deserialize(
      {required Map<String, dynamic> doc, required docId}) {
    return Account(
        docId: docId,
        ownerUid: doc['ownerUid'],
        title: doc['title'],
        isCurrent: doc['isCurrent']);
  }
}
