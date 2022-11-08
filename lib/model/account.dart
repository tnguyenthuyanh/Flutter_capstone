import 'package:cap_project/model/docKeys/docKeys.dart';
import 'package:cap_project/model/storableobject.dart';

class Account extends StorableInterface {
  String accountNumber;
  String website;
  String type;
  double rate;

  Account({
    String? docId,
    required title,
    required ownerUid,
    isCurrent,
    required this.accountNumber,
    this.type = 'Checking',
    this.website = '',
    this.rate = 0.0,
  }) : super(
            ownerUid: ownerUid,
            title: title,
            isCurrent: isCurrent,
            docId: docId);

  Account copyToNew({required String title, required String accountNumber}) =>
      Account(
        title: title,
        ownerUid: ownerUid,
        isCurrent: false,
        accountNumber: accountNumber,
        type: type,
        rate: rate,
        website: website,
      );

  @override
  Map<String, dynamic> serialize() {
    return {
      DocKeyStorable.ownerUid: ownerUid,
      DocKeyStorable.title: title,
      DocKeyStorable.isCurrent: isCurrent,
      DocKeyAccount.accountNumber: accountNumber,
      DocKeyAccount.rate: rate,
      DocKeyAccount.website: website,
      DocKeyAccount.type: type,
    };
  }

  static Account? deserialize(
      {required Map<String, dynamic> doc, required docID}) {
    return Account(
      docId: docID,
      ownerUid: doc[DocKeyStorable.ownerUid],
      title: doc[DocKeyStorable.title],
      isCurrent: doc[DocKeyStorable.isCurrent],
      accountNumber: doc[DocKeyAccount.accountNumber],
      rate: doc[DocKeyAccount.rate],
      website: doc[DocKeyAccount.website],
      type: doc[DocKeyAccount.type],
    );
  }
}
