import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class AuthService {
  static const String baseUrl = "http://127.0.0.1:8000";

  // ==========================================================
  // LOGIN
  // ==========================================================

  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "username": email,
        "password": password,
      },
    );

    print("LOGIN STATUS : ${response.statusCode}");
    print("LOGIN BODY   : ${response.body}");

    if (response.statusCode != 200) {
      return null;
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body);

    final prefs = await SharedPreferences.getInstance();

    //----------------------------------------------------------
    // Save JWT
    //----------------------------------------------------------

    await prefs.setString(
      "token",
      data["access_token"],
    );

    //----------------------------------------------------------
    // Save User
    //----------------------------------------------------------

    final user = UserModel.fromJson(
      data["user"],
    );

    await prefs.setInt(
      "user_id",
      user.id,
    );

    await prefs.setString(
      "user_name",
      user.fullName,
    );

    await prefs.setString(
      "user_email",
      user.email,
    );

    await prefs.setString(
      "role",
      user.role,
    );

    await prefs.setBool(
      "is_logged_in",
      true,
    );

    return user;
  }

  // ==========================================================
  // REGISTER
  // ==========================================================

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/register"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "full_name": fullName,
        "email": email,
        "password": password,
        "role": role,
      }),
    );

    print("REGISTER STATUS : ${response.statusCode}");
    print("REGISTER BODY   : ${response.body}");

    return response.statusCode == 200 ||
        response.statusCode == 201;
  }

  // ==========================================================
  // TOKEN
  // ==========================================================

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // ==========================================================
  // CURRENT USER
  // ==========================================================

  Future<UserModel?> currentUser() async {
    final prefs = await SharedPreferences.getInstance();

    if (!(prefs.getBool("is_logged_in") ?? false)) {
      return null;
    }

    return UserModel(
      id: prefs.getInt("user_id") ?? 0,
      fullName: prefs.getString("user_name") ?? "",
      email: prefs.getString("user_email") ?? "",
      role: prefs.getString("role") ?? "",
      isActive: true,
    );
  }

  // ==========================================================
  // IS LOGGED
  // ==========================================================

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("is_logged_in") ?? false;
  }

  // ==========================================================
  // LOGOUT
  // ==========================================================

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}