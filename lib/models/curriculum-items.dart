// To parse this JSON data, do
//

import 'dart:convert';

// final curriculumItems = curriculumItemsFromJson(jsonString);

List<CurriculumItems> curriculumItemsFromJson(String str) =>
    List<CurriculumItems>.from(
        json.decode(str).map((x) => CurriculumItems.fromJson(x)));

String curriculumItemsToJson(List<CurriculumItems> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CurriculumItems {
  CurriculumItems({
    required this.title,
    required this.startAt,
    required this.startDate,
    required this.description,
    required this.staffTerse,
    required this.id,
    required this.status,
    required this.type,
    required this.weekGroup,
    required this.staffIds,
    required this.driId,
  });

  final String title;
  final DateTime startAt;
  final DateTime startDate;
  final String description;
  final String staffTerse;
  final String id;
  final Status status;
  final Type type;
  final WeekGroup weekGroup;
  final List<Id> staffIds;
  final Id driId;

  factory CurriculumItems.fromJson(Map<String, dynamic> json) =>
      CurriculumItems(
        title: json["title"],
        startAt: DateTime.parse(json["start_at"]),
        startDate: DateTime.parse(json["start_date"]),
        description: json["description"],
        staffTerse: json["staff_terse"],
        id: json["id"],
        status: statusValues.map[json["status"]]!,
        type: typeValues.map[json["type"]]!,
        weekGroup: weekGroupValues.map[json["week_group"]]!,
        staffIds: List<Id>.from(json["staff_ids"].map((x) => idValues.map[x]!)),
        driId: idValues.map[json["dri_id"]]!,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "start_at": startAt.toIso8601String(),
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "description": description,
        "staff_terse": staffTerse,
        "id": id,
        "status": statusValues.reverse[status],
        "type": typeValues.reverse[type],
        "week_group": weekGroupValues.reverse[weekGroup],
        "staff_ids":
            List<dynamic>.from(staffIds.map((x) => idValues.reverse[x])),
        "dri_id": idValues.reverse[driId],
      };
}

enum Id { NATE, BRIT, SPENCER, WHISKEY, JOEL, ELIE, MATT }

final idValues = EnumValues({
  "brit": Id.BRIT,
  "elie": Id.ELIE,
  "joel": Id.JOEL,
  "matt": Id.MATT,
  "nate": Id.NATE,
  "spencer": Id.SPENCER,
  "whiskey": Id.WHISKEY
});

enum Status { PUBLISHED, RETIRED, PRIVATE }

final statusValues = EnumValues({
  "private": Status.PRIVATE,
  "published": Status.PUBLISHED,
  "retired": Status.RETIRED
});

enum Type { A, L, V, E }

final typeValues =
    EnumValues({"A": Type.A, "E": Type.E, "L": Type.L, "V": Type.V});

enum WeekGroup { TOPIC_1, TOPIC_2 }

final weekGroupValues =
    EnumValues({"Topic 1": WeekGroup.TOPIC_1, "Topic 2": WeekGroup.TOPIC_2});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
