// ignore_for_file: file_names

class DocKeyStorable {
  static get docId => "docId";
  static get title => "title";
  static get ownerUid => "ownerUid";
  static get isDirty => "isDirty";
  static get isCurrent => "isCurrent";
}

class DocKeyAccount {
  static get accountNumber => 'accountNumber';
  static get rate => 'rate';
  static get website => 'website';
  static get type => 'type';
}

class DocKeyMonths {
  static get docId => "docId";
  static get ownerUids => "ownerUids";
  static get templateId => 'templateId';
  static get startDate => 'startDate';
  static get endDate => 'endDate';
  static get totalIncome => 'totalIncome';
  static get totalExpense => 'totalExpense';
}
