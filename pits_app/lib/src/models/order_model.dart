import 'dart:convert';

List<OrderModel> orderModelFromJson(String str) =>
    List<OrderModel>.from(json.decode(str).map((x) => OrderModel.fromJson(x)));

class OrderModel {
  OrderModel({
    this.id,
    this.customerId,
    this.establishmentId,
    this.paymentType,
    this.discount,
    this.discountCode,
    this.subtotal,
    this.tax,
    this.total,
    this.status,
    this.error,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.establishmentName,
    this.reviewed,
    this.products,
  });

  int? id;
  int? customerId;
  int? establishmentId;
  String? paymentType;
  String? discount;
  String? discountCode;
  String? subtotal;
  String? tax;
  String? total;
  String? status;
  dynamic error;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? establishmentName;
  bool? reviewed;
  List<Product>? products;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        customerId: json["customer_id"],
        establishmentId: json["establishment_id"],
        paymentType: json["payment_type"],
        discount: json["discount"],
        discountCode: json["discount_code"],
        subtotal: json["subtotal"],
        tax: json["tax"],
        total: json["total"],
        status: json["status"],
        error: json["error"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
        deletedAt: json["deleted_at"],
        establishmentName: json["establishment_name"],
        reviewed: json["reviewed"],
        products: json["products"] != null
            ? List<Product>.from(
                json["products"].map((x) => Product.fromJson(x)))
            : [],
      );
}

class Product {
  Product({
    this.id,
    this.code,
    this.name,
    this.description,
    this.featuredImage,
    this.hoursDuration,
    this.quantity,
    this.unitPrice,
    this.tax,
    this.rowPrice,
    this.carPlate,
    this.scheduleDate,
    this.scheduleHour,
    this.productServiceType,
  });

  int? id;
  String? code;
  String? name;
  String? description;
  String? featuredImage;
  int? hoursDuration;
  int? quantity;
  String? unitPrice;
  String? tax;
  String? rowPrice;
  String? carPlate;
  DateTime? scheduleDate;
  String? scheduleHour;
  String? productServiceType;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        description: json["description"],
        featuredImage: json["featured_image"],
        hoursDuration: json["hours_duration"],
        quantity: json["quantity"],
        unitPrice: json["unit_price"],
        tax: json["tax"],
        rowPrice: json["row_price"],
        carPlate: json["car_plate"],
        scheduleDate: json["schedule_date"] != null
            ? DateTime.parse(json["schedule_date"])
            : null,
        scheduleHour: json["schedule_hour"],
        productServiceType: json["product_service_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "quantity": quantity,
        "unit_price": unitPrice,
        "tax": tax,
        "row_price": rowPrice,
        "car_plate": carPlate,
        "schedule_date": scheduleDate != null
            ? "${scheduleDate!.year.toString().padLeft(4, '0')}-${scheduleDate!.month.toString().padLeft(2, '0')}-${scheduleDate!.day.toString().padLeft(2, '0')}"
            : null,
        "schedule_hour": scheduleHour,
        "product_service_type": productServiceType,
      };
}