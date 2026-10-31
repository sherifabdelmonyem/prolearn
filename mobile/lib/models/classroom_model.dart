class ClassroomModel {
  final int id;

  final String name;

  final String grade;

  final String semester;

  final int teacherId;

  ClassroomModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.semester,
    required this.teacherId,
  });

  factory ClassroomModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClassroomModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      grade: json["grade"] ?? "",
      semester: json["semester"] ?? "",
      teacherId: json["teacher_id"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "grade": grade,
      "semester": semester,
      "teacher_id": teacherId,
    };
  }
}