class UserModel {
  final int id;

  final String fullName;

  final String email;

  final String role;

  final bool isActive;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.isActive,
  });

  factory UserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserModel(
      id: json["id"] ?? 0,
      fullName: json["full_name"] ?? "",
      email: json["email"] ?? "",
      role: json["role"] ?? "",
      isActive: json["is_active"] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "full_name": fullName,
      "email": email,
      "role": role,
      "is_active": isActive,
    };
  }
}