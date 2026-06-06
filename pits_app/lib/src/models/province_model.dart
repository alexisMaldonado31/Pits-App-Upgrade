import 'dart:convert';

List<ProvinceModel> provinceModelFromJson(String str) =>
    List<ProvinceModel>.from(
        json.decode(str).map((x) => ProvinceModel.fromJson(x)));

class ProvinceModel {
  ProvinceModel({this.id, this.name});

  int? id;
  String? name;

  factory ProvinceModel.fromJson(Map<String, dynamic> json) =>
      ProvinceModel(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}