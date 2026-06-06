import 'dart:convert';

List<NewsModel> newsModelFromJson(String str) =>
    List<NewsModel>.from(json.decode(str).map((x) => NewsModel.fromJson(x)));

class NewsModel {
  NewsModel({
    this.id,
    this.title,
    this.body,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.datePublication,
    this.summary,
    this.image,
    this.urlVideo,
  });

  int? id;
  String? title;
  String? body;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  DateTime? datePublication;
  String? summary;
  String? image;
  String? urlVideo;

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        id: json["id"],
        title: json["title"],
        body: json["body"],
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
        updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
        deletedAt: json["deleted_at"],
        datePublication: json["date_publication"] != null ? DateTime.parse(json["date_publication"]) : null,
        summary: json["summary"],
        image: json["image"],
        urlVideo: json["url_video"],
      );
}