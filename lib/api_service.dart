import 'dart:developer';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiConstants {
  static String baseUrl = 'http://localhost:8000/api/';
  static String cohortEndpoint = 'cohorts/';
  static String assessmentSessionsEndpoint = 'assessmentsessions/';
  static String exerciseSessionsEndpoint = 'exercisesessions/';
  static String lectureSessionsEndpoint = 'lecturesessions/';
  static String events = 'events/';
  static String resourceSessionsEndpoint = 'resourcesessions/';
}

Future<AssessmentSessionList> fetchAssessmentSessionList() async {
  final response = await http.get(
    Uri.parse(ApiConstants.baseUrl + ApiConstants.assessmentSessionsEndpoint),
    headers: {
      HttpHeaders.authorizationHeader:
          'Token 57113e449ac123cfef1d2b72be0d3df512c64449'
    },
  );
  print(response.body);
  if (response.statusCode == 200) {
    return AssessmentSessionList.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Assessment List');
  }
}

class AssessmentSessionList {
  final int? count;
  final String? next;
  final String? previous;
  final List<dynamic> results;

  const AssessmentSessionList({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory AssessmentSessionList.fromJson(Map<String, dynamic> json) {
    return AssessmentSessionList(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: json['results'],
    );
  }
}

class AssessmentSession {
  AssessmentSession({
    required this.id,
    required this.title,
    required this.status,
    required this.apiUrl,
  });
  int id;
  String title;
  String status;
  String apiUrl;
}
