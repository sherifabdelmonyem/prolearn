import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_settings_screen.dart'; // استيراد صفحة الإعدادات

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> _userProfileFuture;

  @override
  void initState() {
    super.initState();
    _userProfileFuture = fetchUserProfile();
  }

  Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      //final token = prefs.getString('token');
      final token = prefs.getString('token');

      final dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:8000'));

      final response = await dio.get(
        '/auth/me',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response.data;
    } catch (e) {
      throw Exception("فشل في جلب بيانات البروفايل: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الملف الشخصي"),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userProfileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("حدث خطأ في تحميل البيانات: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("لا توجد بيانات متاحة"));
          }

          final data = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    child: Text(
                      data['full_name'] != null ? data['full_name'][0].toUpperCase() : 'U',
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text("الاسم: ${data['full_name'] ?? 'غير متوفر'}", style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 15),
                Text("البريد الإلكتروني: ${data['email'] ?? 'غير متوفر'}", style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 15),
                Text("الدور: ${data['role'] ?? 'student'}", style: const TextStyle(fontSize: 18)),
                
                const SizedBox(height: 40), // مسافة آمنة قبل ظهور الزر
                
                // زر الانتقال لإعدادات الحساب الواضح والمباشر
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileSettingsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text("إعدادات الحساب", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}