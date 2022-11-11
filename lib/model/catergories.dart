import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  Category(
      {this.userid,
      required this.type,
      required this.label,
      required this.categoryid,
      this.isSelected = false});

  String? userid;
  String type;
  String label;
  String categoryid;
  bool isSelected;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        userid: json["userid"],
        type: json["type"],
        label: json["label"],
        categoryid: json["categoryid"],
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "type": type,
        "label": label,
        "categoryid": categoryid,
      };
}
