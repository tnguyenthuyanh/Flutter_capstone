class Terms {
  static const TITLE = "Title";
  static const DEF = "Definition";
  static const IMAGE = 'Image';

  String? docId;
  late String title;
  late String def;
  late String img;

  Terms({
    this.docId,
    this.title = '',
    this.def = '',
    this.img = '',
  });

  Map<String, dynamic> serialize() {
    return {
      TITLE: title,
      DEF: def,
      IMAGE: img,
    };
  }

  static Terms deserialize(
      {required Map<String, dynamic> doc, required String docId}) {
    return Terms(
      docId: docId,
      title: doc[TITLE],
      def: doc[DEF],
      img: doc[IMAGE],
    );
  }
}

var termList = [
  Terms(
      title: 'FICO',
      def:
          'FICO Score is a three digit number used to measure your ability to pay back loans or debts',
      img: 'https://bankruptcylawnetwork.com/wp-content/uploads/FICO.jpg'),
];
