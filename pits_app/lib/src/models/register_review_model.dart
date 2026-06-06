import 'dart:convert';

RegisterReviewModel registerReviewModelFromJson(String str) =>
    RegisterReviewModel.fromJson(json.decode(str));

class RegisterReviewModel {
  RegisterReviewModel({
    this.establishmentId,
    this.stars,
    this.comment,
    this.orderId,
  });

  int? establishmentId;
  double? stars;
  String? comment;
  int? orderId;

  factory RegisterReviewModel.fromJson(Map<String, dynamic> json) =>
      RegisterReviewModel(
        establishmentId: json["establishment_id"],
        stars: json["stars"]?.toDouble(),
        comment: json["comment"],
        orderId: json["order_id"],
      );

  Map<String, dynamic> toJson() => {
        "establishment_id": establishmentId,
        "stars": stars,
        "comment": comment,
        "order_id": orderId,
      };
}