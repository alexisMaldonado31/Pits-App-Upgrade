import 'dart:convert';

ParametersModel parametersModelFromJson(String str) =>
    ParametersModel.fromJson(json.decode(str));

String parametersModelToJson(ParametersModel data) =>
    json.encode(data.toJson());

class ParametersModel {
  ParametersModel({
    required this.iva,
    required this.kilometerDefault,
    required this.promotionsNumber,
    required this.facebook,
    required this.instagram,
    required this.whatsapp,
    required this.contactPhone,
    required this.contactEmail,
    required this.instagramUrl,
    required this.facebookUrl,
  });

  String iva;
  String kilometerDefault;
  String promotionsNumber;
  String facebook;
  String instagram;
  String whatsapp;
  String contactPhone;
  String contactEmail;
  String instagramUrl;
  String facebookUrl;

  factory ParametersModel.fromJson(Map<String, dynamic> json) =>
      ParametersModel(
        iva: json["iva"],
        kilometerDefault: json["kilometer_default"],
        promotionsNumber: json["promotions_number"],
        facebook: json["facebook"],
        instagram: json["instagram"],
        whatsapp: json["whatsapp"],
        contactPhone: json["contact_phone"],
        contactEmail: json["contact_email"],
        instagramUrl: json["instagram_url"],
        facebookUrl: json["facebook_url"],
      );

  Map<String, dynamic> toJson() => {
    "iva": iva,
    "kilometer_default": kilometerDefault,
    "promotions_number": promotionsNumber,
    "facebook": facebook,
    "instagram": instagram,
    "whatsapp": whatsapp,
    "contact_phone": contactPhone,
    "contact_email": contactEmail,
    "instagram_url": instagramUrl,
    "facebook_url": facebookUrl,
  };
}
