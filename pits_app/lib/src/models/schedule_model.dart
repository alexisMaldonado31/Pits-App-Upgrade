import 'dart:convert';

List<String> scheduleModelFromJson(String str) =>
    List<String>.from(json.decode(str).map((x) => x));