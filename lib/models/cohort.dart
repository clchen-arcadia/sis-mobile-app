// To parse this JSON data, do
//
//     final cohort = cohortFromJson(jsonString);

import 'dart:convert';

Cohort cohortFromJson(String str) => Cohort.fromJson(json.decode(str));

String cohortToJson(Cohort data) => json.encode(data.toJson());

class Cohort {
  Cohort({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  final int count;
  final dynamic next;
  final dynamic previous;
  final List<Result> results;

  factory Cohort.fromJson(Map<String, dynamic> json) => Cohort(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    required this.id,
    required this.title,
    required this.status,
    required this.apiUrl,
  });

  final String id;
  final String title;
  final String status;
  final String apiUrl;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        title: json["title"],
        status: json["status"],
        apiUrl: json["api_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "status": status,
        "api_url": apiUrl,
      };
}
