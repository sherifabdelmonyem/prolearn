import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonService {
  static const String baseUrl = "http://127.0.0.1:8000";

  late final Dio dio;

  LessonService() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();

          final token = prefs.getString("token");

          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] =
                "Bearer $token";
          }

          print("=================================");
          print("REQUEST => ${options.method}");
          print("URL => ${options.uri}");
          print("TOKEN => $token");
          print("BODY => ${options.data}");
          print("=================================");

          handler.next(options);
        },
        onResponse: (response, handler) {
          print("=================================");
          print("STATUS => ${response.statusCode}");
          print("DATA => ${response.data}");
          print("=================================");
          handler.next(response);
        },
        onError: (e, handler) {
          print("=================================");
          print("ERROR => ${e.response?.statusCode}");
          print("BODY => ${e.response?.data}");
          print("=================================");
          handler.next(e);
        },
      ),
    );
  }

  //================================================
  // Upload Lesson (Text)
  //================================================

  Future<Map<String, dynamic>> uploadLesson({
    required String title,
    required String content,
  }) async {
    final response = await dio.post(
      "/contents/",
      data: {
        "title": title,
        "original_text": content,
      },
    );

    return Map<String, dynamic>.from(
      response.data,
    );
  }

  //================================================
  // Upload File (WEB + WINDOWS + ANDROID)
  //================================================

  Future<Map<String, dynamic>> uploadFileLesson({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(
        bytes,
        filename: fileName,
      ),
    });

    final response = await dio.post(
      "/learning-sessions/upload",
      data: formData,
      options: Options(
        contentType: "multipart/form-data",
      ),
    );

    return Map<String, dynamic>.from(
      response.data,
    );
  }

  //================================================
  // My Lessons
  //================================================

  Future<List<dynamic>> getMyLessons() async {
    final response = await dio.get(
      "/learning-sessions/",
    );

    if (response.data is List) {
      return List<dynamic>.from(
        response.data,
      );
    }

    if (response.data is Map &&
        response.data["items"] != null) {
      return List<dynamic>.from(
        response.data["items"],
      );
    }

    return [];
  }

  //================================================
  // Lesson Details
  //================================================

  Future<Map<String, dynamic>> getLessonDetails(
    int id,
  ) async {
    final response = await dio.get(
      "/contents/$id",
    );

    return Map<String, dynamic>.from(
      response.data,
    );
  }

  //================================================
  // Delete Lesson
  //================================================

  Future<void> deleteLesson(int id) async {
    await dio.delete(
      "/learning-sessions/$id",
    );
  }
}