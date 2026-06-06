class PaymentCheckout {
  PaymentCheckout({this.transaction, this.card});

  Transaction? transaction;
  CardModel? card;

  factory PaymentCheckout.fromJson(Map<String, dynamic> json) =>
      PaymentCheckout(
        transaction: json["transaction"] != null
            ? Transaction.fromJson(json["transaction"])
            : null,
        card: json["card"] != null ? CardModel.fromJson(json["card"]) : null,
      );
}

class Transaction {
  Transaction({
    this.status,
    this.authorizationCode,
    this.id,
    this.devReference,
  });

  String? status;
  String? authorizationCode;
  String? id;
  String? devReference;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        status: json["status"],
        authorizationCode: json["id"], // en v3 usa id como referencia
        id: json["id"],
        devReference: json["status_detail"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "authorization_code": authorizationCode,
        "id": id,
        "dev_reference": devReference,
      };
}

class CardModel {
  CardModel({this.number, this.type});
  String? number;
  String? type;

  factory CardModel.fromJson(Map<String, dynamic> json) =>
      CardModel(number: json["number"], type: json["type"]);
}