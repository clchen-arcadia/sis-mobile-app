import 'dart:io';

import '../models/curriculum-items.dart';

import 'package:http/http.dart' as http;

//     final curriculumItems = curriculumItemsFromJson(jsonString);

class ApiConstants {
  static String baseUrl = 'http://localhost:8000/api/';
  static String cohortItems = 'cohortitems/';
  static String cohortEndpoint = 'cohorts/';
}

Future<List<CurriculumItems>> fetchCurriculumItems() async {
  print('Before request');
  final response = await http.get(
    Uri.parse('http://localhost:8000/api/cohortitems/'),
    headers: {
      HttpHeaders.authorizationHeader:
          'Token 57113e449ac123cfef1d2b72be0d3df512c64449'
    },
  );
  print('after request');

  if (response.statusCode == 200) {
    return curriculumItemsFromJson(response.body);
    // return CurriculumItems.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Assessment List');
  }
}
