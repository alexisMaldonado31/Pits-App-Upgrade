import 'dart:convert';

List<VehicleTypeModel> vehicleTypeModelFromJson(String str) =>
    List<VehicleTypeModel>.from(
        json.decode(str).map((x) => VehicleTypeModel.fromJson(x)));

class VehicleTypeModel {
  VehicleTypeModel({this.id, this.name});
  int? id;
  String? name;
  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) =>
      VehicleTypeModel(id: json["id"], name: json["name"]);
}