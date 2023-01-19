// To parse this JSON data, do
//
//     final cohort = cohortFromJson(jsonString);

import 'dart:convert';

Cohort cohortFromJson(String str) => Cohort.fromJson(json.decode(str));

String cohortToJson(Cohort data) => json.encode(data.toJson());

class Cohort {
  Cohort({
    required this.id,
    required this.course,
    required this.courseInfo,
    required this.title,
    required this.description,
    required this.modality,
    required this.domainName,
    required this.formalTitle,
    this.formalLogoSvg,
    this.siteLogo,
    required this.dri,
    required this.startAmTime,
    required this.startPmTime,
    required this.weekgroupVocab,
    required this.onlineMeetingUrl,
    required this.status,
    required this.apiUrl,
  });

  final String id;
  final String course;
  final CourseInfo courseInfo;
  final String title;
  final String description;
  final String modality;
  final String domainName;
  final String formalTitle;
  final dynamic formalLogoSvg;
  final dynamic siteLogo;
  final String dri;
  final String startAmTime;
  final String startPmTime;
  final List<String> weekgroupVocab;
  final String onlineMeetingUrl;
  final String status;
  final String apiUrl;

  factory Cohort.fromJson(Map<String, dynamic> json) => Cohort(
        id: json["id"],
        course: json["course"],
        courseInfo: CourseInfo.fromJson(json["course_info"]),
        title: json["title"],
        description: json["description"],
        modality: json["modality"],
        domainName: json["domain_name"],
        formalTitle: json["formal_title"],
        formalLogoSvg: json["formal_logo_svg"],
        siteLogo: json["site_logo"],
        dri: json["dri"],
        startAmTime: json["start_am_time"],
        startPmTime: json["start_pm_time"],
        weekgroupVocab:
            List<String>.from(json["weekgroup_vocab"].map((x) => x)),
        onlineMeetingUrl: json["online_meeting_url"],
        status: json["status"],
        apiUrl: json["api_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course": course,
        "course_info": courseInfo.toJson(),
        "title": title,
        "description": description,
        "modality": modality,
        "domain_name": domainName,
        "formal_title": formalTitle,
        "formal_logo_svg": formalLogoSvg,
        "site_logo": siteLogo,
        "dri": dri,
        "start_am_time": startAmTime,
        "start_pm_time": startPmTime,
        "weekgroup_vocab": List<dynamic>.from(weekgroupVocab.map((x) => x)),
        "online_meeting_url": onlineMeetingUrl,
        "status": status,
        "api_url": apiUrl,
      };
}

class CourseInfo {
  CourseInfo({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  factory CourseInfo.fromJson(Map<String, dynamic> json) => CourseInfo(
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
      };
}
