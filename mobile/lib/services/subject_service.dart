import 'package:dio/dio.dart';

class SubjectService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://127.0.0.1:8000",
    ),
  );

  Future<List<dynamic>> getLessons(
      int subjectId) async {
    final response = await dio.get(
      "/subjects/$subjectId/lessons/",
    );

    return response.data;
  }
}