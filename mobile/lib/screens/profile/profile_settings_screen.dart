import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() =>
      _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState
    extends State<ProfileSettingsScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _notificationsEnabled = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _nameController.text =
          prefs.getString("user_name") ?? "";
      _emailController.text =
          prefs.getString("email") ?? "";
    });
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      print("TOKEN = $token");

      final dio = Dio(
        BaseOptions(
          baseUrl: "http://127.0.0.1:8000",
        ),
      );

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            print(options.headers);
            handler.next(options);
          },
        ),
      );

      await dio.put(
        "/auth/me",
        data: {
          "full_name": _nameController.text,
          "email": _emailController.text,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      await prefs.setString(
        "user_name",
        _nameController.text,
      );

      await prefs.setString(
        "email",
        _emailController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "تم تحديث البيانات بنجاح",
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "فشل التحديث : $e",
            ),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _changePassword() async {
    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("أدخل كلمات المرور"),
        ),
      );
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final dio = Dio(
        BaseOptions(
          baseUrl: "http://127.0.0.1:8000",
        ),
      );

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            print(options.headers);
            handler.next(options);
          },
        ),
      );

      await dio.put(
        "/auth/change-password",
        data: {
          "current_password":
              _currentPasswordController.text,
          "new_password":
              _newPasswordController.text,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      _currentPasswordController.clear();
      _newPasswordController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "تم تغيير كلمة المرور",
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "فشل تغيير كلمة المرور : $e",
            ),
          ),
        );
      }
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      "/",
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إعدادات الحساب"),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  "المعلومات الشخصية",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "الاسم الكامل",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "البريد الإلكتروني",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: _updateProfile,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "حفظ التعديلات",
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        const Size.fromHeight(50),
                  ),
                ),
                const Divider(
                  height: 40,
                  thickness: 1,
                ),
                const Text(
                  "الأمان",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller:
                      _currentPasswordController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(
                    labelText:
                        "كلمة المرور الحالية",
                    border:
                        OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller:
                      _newPasswordController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(
                    labelText:
                        "كلمة المرور الجديدة",
                    border:
                        OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.lock,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                OutlinedButton.icon(
                  onPressed: _changePassword,
                  icon: const Icon(Icons.key),
                  label: const Text(
                    "تحديث كلمة المرور",
                  ),
                  style:
                      OutlinedButton.styleFrom(
                    minimumSize:
                        const Size.fromHeight(50),
                  ),
                ),
                const Divider(
                  height: 40,
                  thickness: 1,
                ),
                const Text(
                  "التفضيلات",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SwitchListTile(
                  title: const Text(
                    "تلقي إشعارات الدروس والاختبارات",
                  ),
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled =
                          value;
                    });
                  },
                ),
                const Divider(
                  height: 40,
                  thickness: 1,
                ),
                ElevatedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "تسجيل الخروج",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize:
                        const Size.fromHeight(50),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }
}