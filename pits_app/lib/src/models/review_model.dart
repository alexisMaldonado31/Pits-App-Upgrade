import 'dart:convert';

List<ReviewModel> reviewModelFromJson(String? str) => List<ReviewModel>.from(
    json.decode(str as String).map((x) => ReviewModel.fromJson(x)));

String reviewModelToJson(List<ReviewModel>? data) =>
    json.encode(List<dynamic>.from(data!.map((x) => x.toJson())));

class ReviewModel {
  ReviewModel({
    this.id,
    this.stars,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.establishmentId,
    this.orderId,
  });

  int? id;
  int? stars;
  String? comment;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? establishmentId;
  dynamic orderId;

  factory ReviewModel.fromJson(Map<String, dynamic>? json) => ReviewModel(
        id: json!["id"],
        stars: json!["stars"],
        comment: json!["comment"],
        createdAt: DateTime.parse(json!["created_at"]),
        updatedAt: DateTime.parse(json!["updated_at"]),
        deletedAt: json!["deleted_at"],
        establishmentId: json!["establishment_id"],
        orderId: json!["order_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "stars": stars,
        "comment": comment,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "establishment_id": establishmentId,
        "order_id": orderId,
      };
}
