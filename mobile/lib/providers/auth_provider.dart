import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  UserModel? currentUser;

  bool loading = false;

  Future<bool> login(
    String email,
    String password,
  ) async {
    loading = true;

    notifyListeners();

    currentUser = await _service.login(
      email: email,
      password: password,
    );

    loading = false;

    notifyListeners();

    return currentUser != null;
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    loading = true;

    notifyListeners();

    final result = await _service.register(
      fullName: fullName,
      email: email,
      password: password,
      role: role,
    );

    loading = false;

    notifyListeners();

    return result;
  }
}