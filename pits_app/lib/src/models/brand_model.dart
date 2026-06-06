import 'dart:convert';

List<BrandModel> brandModelFromJson(String str) =>
    List<BrandModel>.from(json.decode(str).map((x) => BrandModel.fromJson(x)));

class BrandModel {
  BrandModel({this.id, this.name});
  int? id;
  String? name;
  factory BrandModel.fromJson(Map<String, dynamic> json) =>
      BrandModel(id: json["id"], name: json["name"]);
}