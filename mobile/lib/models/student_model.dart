class StudentModel {
  final int id;
  final String fullName;
  final String email;
  final int classroomId;
  final int? userId;

  StudentModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.classroomId,
    this.userId,
  });

  factory StudentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StudentModel(
      id: json["id"] ?? 0,
      fullName: json["full_name"] ?? "",
      email: json["email"] ?? "",
      classroomId: json["classroom_id"] ?? 0,
      userId: json["user_id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "full_name": fullName,
      "email": email,
      "classroom_id": classroomId,
      "user_id": userId,
    };
  }
}