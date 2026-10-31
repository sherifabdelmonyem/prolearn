class SubjectModel {
  final int id;
  final String name;
  final String grade;
  final String semester;
  final double progress;

  SubjectModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.semester,
    required this.progress,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      grade: json["grade"] ?? "",
      semester: json["semester"] ?? "",
      progress: (json["progress"] ?? 0).toDouble(),
    );
  }
}