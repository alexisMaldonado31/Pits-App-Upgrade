import 'dart:convert';

CustomerCreateModel customerCreateModelFromJson(String str) =>
    CustomerCreateModel.fromJson(json.decode(str));

String customerCreateModelToJson(CustomerCreateModel data) =>
    json.encode(data.toJson());

class CustomerCreateModel {
  CustomerCreateModel({
    required this.firstname,
    required this.lastname,
    required this.document,
    required this.email,
    required this.password,
  });

  String firstname;
  String lastname;
  String document;
  String email;
  String password;

  factory CustomerCreateModel.fromJson(Map<String, dynamic> json) =>
      CustomerCreateModel(
        firstname: json["firstname"],
        lastname: json["lastname"],
        document: json["document"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
    "firstname": firstname,
    "lastname": lastname,
    "document": document,
    "email": email,
    "password": password,
  };
}
