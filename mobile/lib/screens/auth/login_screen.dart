import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final AuthService authService = AuthService();

  bool loading = false;

  Future<void> login() async {
    setState(() {
      loading = true;
    });

    try {
      print("STEP 1");

      UserModel? user = await authService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      print("STEP 2");

      if (user == null) {
        throw Exception(
          "البريد الإلكتروني أو كلمة المرور غير صحيحة",
        );
      }

      print("STEP 3");

      final prefs =
          await SharedPreferences.getInstance();

      print("STEP 4");

      await prefs.setInt("user_id", user.id);
      await prefs.setString("user_name", user.fullName);
      await prefs.setString("email", user.email);
      await prefs.setString("role", user.role);

      print("STEP 5");
      print("USER ROLE = ${user.role}");

      if (!mounted) {
        print("NOT MOUNTED");
        return;
      }

      print("STEP 6");
      print("GO TO HOME");

      Navigator.pushReplacementNamed(
        context,
        "/home",
      );

      print("STEP 7");
    } catch (e, s) {
      print("LOGIN ERROR");
      print(e);
      print(s);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("تسجيل الدخول"),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const Icon(
                  Icons.school,
                  size: 100,
                  color: Colors.blue,
                ),

                const SizedBox(height: 20),

                const Text(
                  "ProLearn",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "منصة التعلم الذكية",
                  style: TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 40),

                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "البريد الإلكتروني",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "كلمة المرور",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: loading ? null : login,
                    child: loading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "تسجيل الدخول",
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ),

                const SizedBox(height: 15),

                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      "/register",
                    );
                  },
                  child: const Text("إنشاء حساب جديد"),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      "/forgot-password",
                    );
                  },
                  child: const Text("نسيت كلمة المرور؟"),
                ),

                const SizedBox(height: 25),

                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "سيتم تفعيل تسجيل الدخول بالصوت قريبًا",
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.mic),
                  label: const Text(
                    "تسجيل الدخول بالصوت",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}