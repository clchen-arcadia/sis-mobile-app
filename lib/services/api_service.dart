import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/curriculum-items.dart';
import '../models/cohort.dart';

import 'package:http/http.dart' as http;

class ApiConstants {
  static String baseUrl = dotenv.env['API_BASE_URL'].toString();
  static String token = dotenv.env['API_TOKEN'].toString();
  static String cohortItems = 'cohortitems/';
  static String cohortData = 'cohorts/';
  static String cohort = 'r99/';
}

// Fetch Curriculum Items for current Cohort
Future<List<CurriculumItems>> fetchCurriculumItems() async {
  print('Before request');
  print(ApiConstants.baseUrl);
  print(ApiConstants.token);
  final response = await http.get(
    Uri.parse(ApiConstants.baseUrl + ApiConstants.cohortItems),
    headers: {HttpHeaders.authorizationHeader: ApiConstants.token},
  );
  print('after request');

  if (response.statusCode == 200) {
    return curriculumItemsFromJson(response.body);
  } else {
    throw Exception('Failed to load Assessment List');
  }
}

// Fetch Data about current Cohort
Future<Cohort> fetchCohortData() async {
  print('Fetching Cohort');
  final response = await http.get(
    Uri.parse(
        ApiConstants.baseUrl + ApiConstants.cohortData + ApiConstants.cohort),
    headers: {HttpHeaders.authorizationHeader: ApiConstants.token},
  );
  if (response.statusCode == 200) {
    return cohortFromJson(response.body);
  } else {
    throw Exception('Failed to load Cohort Data');
  }
}
