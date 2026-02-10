import 'dart:convert';

CustomerModel customerModelFromJson(String str) =>
    CustomerModel.fromJson(json.decode(str));

String customerModelToJson(CustomerModel data) => json.encode(data.toJson());

class CustomerModel {
  CustomerModel({
    this.id,
    required this.firstname,
    required this.lastname,
    required this.document,
    required this.email,
    required this.mobile,
    required this.city,
    required this.address,
    required this.facebookUser,
    required this.provinceId,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.establishmentId,
    required this.googleUser,
    required this.kilometersRadio,
    required this.ordersByReview,
  });

  int? id;
  String firstname;
  String lastname;
  String document;
  String email;
  String mobile;
  String city;
  String address;
  dynamic facebookUser;
  int provinceId;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  dynamic establishmentId;
  dynamic googleUser;
  String kilometersRadio;
  int ordersByReview;

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
    id: json["id"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    document: json["document"],
    email: json["email"],
    mobile: json["mobile"],
    city: json["city"],
    address: json["address"],
    facebookUser: json["facebook_user"],
    provinceId: json["province_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    googleUser: json["google_user"],
    kilometersRadio: json["kilometers_radio"],
    ordersByReview: json["ordersByReview"],
    establishmentId: null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstname": firstname,
    "lastname": lastname,
    "document": document,
    "email": email,
    "mobile": mobile,
    "city": city,
    "address": address,
    "facebook_user": facebookUser,
    "province_id": provinceId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
    "establishment_id": establishmentId,
    "google_user": googleUser,
    "kilometers_radio": kilometersRadio,
    "ordersByReview": ordersByReview,
  };
}
