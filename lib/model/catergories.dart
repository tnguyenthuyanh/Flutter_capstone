import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  Category(
      {this.userid,
      required this.type,
      required this.label,
      required this.categoryid,
      this.isSelected = false,
      this.globalAvg,
      this.nature});

  String? userid;
  String type;
  String label;
  String categoryid;
  String? globalAvg;
  bool isSelected;
  String? nature;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        userid: json["userid"],
        type: json["type"],
        label: json["label"],
        categoryid: json["categoryid"],
        globalAvg:
            json["globalAvg"] != null ? json["globalAvg"].toString() : null,
        nature: json["nature"],
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "type": type,
        "label": label,
        "categoryid": categoryid,
      };
}
