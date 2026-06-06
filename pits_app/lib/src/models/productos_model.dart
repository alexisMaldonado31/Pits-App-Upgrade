import 'dart:convert';

List<ProductsModel> productsModelFromJson(String str) =>
    List<ProductsModel>.from(
        json.decode(str).map((x) => ProductsModel.fromJson(x)));

class ProductsModel {
  ProductsModel({
    this.id,
    this.code,
    this.name,
    this.description,
    this.iva,
    this.price,
    this.offer,
    this.offerPrice,
    this.featuredImage,
    this.images,
    this.hoursDuration,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.type,
    this.establishmentId,
    this.taxRate,
    this.priceWithTax,
    this.offerPriceWithTax,
    this.establishmentName,
    this.categories,
  });

  int? id;
  String? code;
  String? name;
  String? description;
  bool? iva;
  String? price;
  bool? offer;
  String? offerPrice;
  String? featuredImage;
  dynamic images;
  int? hoursDuration;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? type;
  int? establishmentId;
  String? taxRate;
  String? priceWithTax;
  String? offerPriceWithTax;
  String? establishmentName;
  List<dynamic>? categories;

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        description: json["description"],
        iva: json["iva"],
        price: json["price"],
        offer: json["offer"],
        offerPrice: json["offer_price"],
        featuredImage: json["featured_image"],
        images: json["images"],
        hoursDuration: json["hours_duration"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        deletedAt: json["deleted_at"],
        type: json["type"],
        establishmentId: json["establishment_id"],
        taxRate: json["tax_rate"]?.toString(),
        priceWithTax: json["price_with_tax"],
        offerPriceWithTax: json["offer_price_with_tax"],
        establishmentName: json["establishment_name"],
        categories: json["categories"],
      );
}