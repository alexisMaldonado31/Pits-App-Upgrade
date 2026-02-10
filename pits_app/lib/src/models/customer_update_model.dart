import 'dart:convert';

CustomerUpdateModel customerUpdateModelFromJson(String str) =>
    CustomerUpdateModel.fromJson(json.decode(str));

String customerUpdateModelToJson(CustomerUpdateModel data) =>
    json.encode(data.toJson());

class CustomerUpdateModel {
  CustomerUpdateModel({
    this.id,
    this.firstname,
    this.lastname,
    this.document,
    this.mobile,
    this.city,
    this.address,
    this.facebookUser,
    this.googleUser,
    this.password,
    this.kilometersRadio,
    this.provinceId,
  });

  int? id;
  String? firstname;
  String? lastname;
  String? document;
  String? mobile;
  String? city;
  String? address;
  String? facebookUser;
  String? googleUser;
  String? password;
  String? kilometersRadio;
  int? provinceId;

  factory CustomerUpdateModel.fromJson(Map<String, dynamic> json) =>
      CustomerUpdateModel(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        document: json["document"],
        mobile: json["mobile"],
        city: json["city"],
        address: json["address"],
        facebookUser: json["facebook_user"],
        googleUser: json["google_user"],
        password: json["password"],
        kilometersRadio: json["kilometers_radio"],
        provinceId: json["province_id"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstname": firstname,
    "lastname": lastname,
    "document": document,
    "mobile": mobile,
    "city": city,
    "address": address,
    "facebook_user": facebookUser,
    "google_user": googleUser,
    "password": password,
    "kilometers_radio": kilometersRadio,
    "province_id": provinceId,
  };
}
