import 'dart:convert';

SubCategory categoryFromJson(String str) => SubCategory.fromJson(json.decode(str));

String categoryToJson(SubCategory data) => json.encode(data.toJson());

class SubCategory {
  SubCategory({
    this.userid,
    required this.subcategoryid,
    required this.label,
    required this.categoryid,
    this.isSelected = false
  });

  String? userid;
  String subcategoryid;
  String label;
  String categoryid;
  bool isSelected;


  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
    userid: json["userid"]??"",
    subcategoryid: json["subcategoryid"]??"",
    label: json["label"]??"",
    categoryid: json["categoryid"]??"",
  );



  Map<String, dynamic> toJson() => {
    "userid": userid,
    "subcategoryid": subcategoryid,
    "label": label,
    "categoryid": categoryid,
  };
}
