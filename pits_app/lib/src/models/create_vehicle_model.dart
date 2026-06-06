class CreateVehicleModel {
  CreateVehicleModel({
    this.customerId,
    this.brandId,
    this.typeVehicleId,
    this.licensePlate,
    this.chassis,
    this.image,
    this.kilometraje,
    this.onSale,
  });

  int? customerId;
  int? brandId;
  int? typeVehicleId;
  String? licensePlate;
  String? chassis;
  String? image;
  String? kilometraje;
  int? onSale;
}