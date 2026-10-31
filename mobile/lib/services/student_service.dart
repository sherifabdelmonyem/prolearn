import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/student_model.dart';

class StudentService {
  static const String baseUrl =
      "http://10.0.2.2:8000";

  Future<List<StudentModel>> getStudents(
      int classroomId) async {
    final response = await http.get(
      Uri.parse(
        "$baseUrl/students/classroom/$classroomId",
      ),
    );

    if (response.statusCode == 200) {
      final List data =
          jsonDecode(response.body);

      return data
          .map(
            (e) => StudentModel.fromJson(e),
          )
          .toList();
    }

    return [];
  }

  Future<bool> createStudent({
    required String fullName,
    required String email,
    required int classroomId,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/students"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "full_name": fullName,
        "email": email,
        "classroom_id": classroomId,
      }),
    );

    return response.statusCode == 200 ||
        response.statusCode == 201;
  }

  Future<bool> deleteStudent(
      int studentId) async {
    final response = await http.delete(
      Uri.parse(
        "$baseUrl/students/$studentId",
      ),
    );

    return response.statusCode == 200;
  }
}