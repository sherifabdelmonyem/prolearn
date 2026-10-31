import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/classroom_model.dart';

class ClassroomService {
  static const String baseUrl = "http://10.0.2.2:8000";

  Future<List<ClassroomModel>> getClassrooms() async {
    final response = await http.get(
      Uri.parse("$baseUrl/classrooms/"),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data
          .map(
            (e) => ClassroomModel.fromJson(e),
          )
          .toList();
    }

    return [];
  }

  Future<ClassroomModel?> createClassroom({
    required String name,
    required String grade,
    required String semester,
    required int teacherId,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/classrooms/"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "grade": grade,
        "semester": semester,
        "teacher_id": teacherId,
      }),
    );

    if (response.statusCode == 200) {
      return ClassroomModel.fromJson(
        jsonDecode(response.body),
      );
    }

    return null;
  }

  Future<bool> deleteClassroom(
    int id,
  ) async {
    final response = await http.delete(
      Uri.parse(
        "$baseUrl/classrooms/$id",
      ),
    );

    return response.statusCode == 200;
  }
}