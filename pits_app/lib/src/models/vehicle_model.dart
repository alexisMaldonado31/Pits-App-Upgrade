import 'dart:convert';

List<VehicleModel> vehicleModelFromJson(String str) =>
    List<VehicleModel>.from(
        json.decode(str).map((x) => VehicleModel.fromJson(x)));

class VehicleModel {
  VehicleModel({
    this.id,
    this.customerId,
    this.brandId,
    this.typeVehicleId,
    this.licensePlate,
    this.chassis,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.image,
    this.kilometers,
    this.onSale,
    this.brandName,
    this.typeVehicleName,
  });

  int? id;
  int? customerId;
  int? brandId;
  int? typeVehicleId;
  String? licensePlate;
  String? chassis;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? image;
  int? kilometers;
  bool? onSale;
  String? brandName;
  String? typeVehicleName;

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
        id: json["id"],
        customerId: json["customer_id"],
        brandId: json["brand_id"],
        typeVehicleId: json["type_vehicle_id"],
        licensePlate: json["license_plate"],
        chassis: json["chassis"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        deletedAt: json["deleted_at"],
        image: json["image"],
        kilometers: json["kilometers"],
        onSale: json["on_sale"],
        brandName: json["brand_name"],
        typeVehicleName: json["type_vehicle_name"],
      );
}