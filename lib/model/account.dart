import 'package:cap_project/model/docKeys/docKeys.dart';
import 'package:cap_project/model/storableobject.dart';

class Account extends StorableInterface {
  Account({
    String? docId,
    required title,
    required ownerUid,
    isCurrent,
  }) : super(ownerUid: ownerUid, title: title, isCurrent: isCurrent);

  Account copyToNew({required String title}) =>
      Account(title: title, ownerUid: ownerUid, isCurrent: false);

  @override
  Map<String, dynamic> serialize() {
    return {
      DocKeyStorable.docId: docId,
      DocKeyStorable.title: title,
      DocKeyStorable.isCurrent: isCurrent,
    };
  }

  static Account? deserialize(
      {required Map<String, dynamic> doc, required docId}) {
    return Account(
        docId: docId,
        ownerUid: doc[DocKeyStorable.ownerUid],
        title: doc[DocKeyStorable.title],
        isCurrent: doc[DocKeyStorable.isCurrent]);
  }
}
