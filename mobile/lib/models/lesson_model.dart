class LessonModel {
  final int id;

  final String title;

  final String summary;

  final String status;

  LessonModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.status,
  });

  factory LessonModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LessonModel(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      summary: json["summary"] ?? "",
      status: json["status"] ?? "",
    );
  }
}