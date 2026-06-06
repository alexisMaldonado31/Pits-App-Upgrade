import 'dart:convert';

List<AdvertisementModel> advertisementModelFromJson(String str) =>
    List<AdvertisementModel>.from(
        json.decode(str).map((x) => AdvertisementModel.fromJson(x)));

class AdvertisementModel {
  AdvertisementModel({
    this.id,
    this.name,
    this.shortDescription,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.establishmentId,
  });

  int? id;
  String? name;
  String? shortDescription;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? establishmentId;

  factory AdvertisementModel.fromJson(Map<String, dynamic> json) =>
      AdvertisementModel(
        id: json["id"],
        name: json["name"],
        shortDescription: json["short_description"],
        image: json["image"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        deletedAt: json["deleted_at"],
        establishmentId: json["establishment_id"],
      );
}