class CreateOrderModel {
  CreateOrderModel({
    this.customerId,
    this.establishmentId,
    this.paymentType,
    this.discount,
    this.discountCode,
    this.subtotal,
    this.tax,
    this.total,
    this.status,
    this.reference,
    this.transactionId,
    this.authorizationNumber,
    this.products,
  });

  int? customerId;
  int? establishmentId;
  String? paymentType;
  int? discount;
  String? discountCode;
  double? subtotal;
  double? tax;
  double? total;
  String? status;
  String? reference;
  String? transactionId;
  String? authorizationNumber;
  List<ProductOrder>? products;

  Map<String, dynamic> toJson() => {
        "customer_id": customerId,
        "establishment_id": establishmentId,
        "payment_type": paymentType,
        "discount": discount,
        "discount_code": discountCode,
        "subtotal": subtotal,
        "tax": tax,
        "total": total,
        "status": status,
        "reference": reference,
        "transaction_id": transactionId,
        "authorization_number": authorizationNumber,
        "products": products?.map((x) => x.toJson()).toList() ?? [],
      };
}

class ProductOrder {
  ProductOrder({
    this.productServiceId,
    this.quantity,
    this.productServiceType,
    this.unitPrice,
    this.scheduleDate,
    this.scheduleHour,
    this.tax,
    this.rowPrice,
    this.carId,
  });

  int? productServiceId;
  int? quantity;
  String? productServiceType;
  double? unitPrice;
  String? scheduleDate;
  String? scheduleHour;
  double? tax;
  double? rowPrice;
  dynamic carId;

  Map<String, dynamic> toJson() => {
        "product_service_id": productServiceId,
        "quantity": quantity,
        "product_service_type": productServiceType,
        "unit_price": unitPrice,
        "schedule_date": scheduleDate,
        "schedule_hour": scheduleHour,
        "tax": tax,
        "row_price": rowPrice,
        "car_id": carId,
      };
}