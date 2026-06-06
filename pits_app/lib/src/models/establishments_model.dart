import 'dart:convert';

EstablishmentsModel establishmentModelFromJson(String str) =>
    EstablishmentsModel.fromJson(json.decode(str));

List<EstablishmentsModel> establishmentsModelFromJson(String str) =>
    List<EstablishmentsModel>.from(
        json.decode(str).map((x) => EstablishmentsModel.fromJson(x)));

class EstablishmentsModel {
  EstablishmentsModel({
    this.id,
    this.name,
    this.document,
    this.email,
    this.phone,
    this.mobile,
    this.address,
    this.city,
    this.latitude,
    this.longitude,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.logo,
    this.province,
    this.subscriptionName,
    this.subscriptionProductLimit,
    this.subscriptionComission,
    this.categories,
    this.stars,
    this.instagram,
    this.facebook,
    this.tiktok,
    this.youtube,
    this.webPage,
    this.textWebPage,
  });

  int? id;
  String? name;
  String? document;
  String? email;
  String? phone;
  String? mobile;
  String? address;
  String? city;
  String? latitude;
  String? longitude;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? logo;
  String? province;
  String? subscriptionName;
  int? subscriptionProductLimit;
  double? subscriptionComission;
  List<EstablishmentCategory>? categories;
  double? stars;
  String? instagram;
  String? facebook;
  String? tiktok;
  String? youtube;
  String? webPage;
  String? textWebPage;

  factory EstablishmentsModel.fromJson(Map<String, dynamic> json) =>
      EstablishmentsModel(
        id: json["id"],
        name: json["name"],
        document: json["document"],
        email: json["email"],
        phone: json["phone"],
        mobile: json["mobile"],
        address: json["address"],
        city: json["city"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        description: json["description"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        deletedAt: json["deleted_at"],
        logo: json["logo"],
        province: json["province"],
        subscriptionName: json["subscription_name"],
        subscriptionProductLimit: json["subscription_product_limit"],
        subscriptionComission:
            (json["subscription_comission"] ?? 0).toDouble(),
        categories: json["categories"] != null
            ? List<EstablishmentCategory>.from(
                json["categories"].map((x) => EstablishmentCategory.fromJson(x)))
            : [],
        stars: (json["stars"] ?? 0).toDouble(),
        instagram: json["instagram"],
        facebook: json["facebook"],
        tiktok: json["tiktok"],
        youtube: json["youtube"],
        webPage: json["web_page_link"],
        textWebPage: json["text_web_page_link"],
      );
}

class EstablishmentCategory {
  EstablishmentCategory({this.id, this.name, this.image, this.description});

  int? id;
  String? name;
  String? image;
  String? description;

  factory EstablishmentCategory.fromJson(Map<String, dynamic> json) =>
      EstablishmentCategory(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        description: json["description"],
      );
}