import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // القيم الافتراضية لدور المستخدم (مثلاً طالب أو معلم)
  String _selectedRole = 'student';
  bool _isLoading = false;

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await _authService.register(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        role: _selectedRole,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تم إنشاء الحساب بنجاح، يمكنك تسجيل الدخول الآن")),
        );
        Navigator.pop(context); // العودة لصفحة تسجيل الدخول
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("فشل إنشاء الحساب، يرجى المحاولة لاحقاً")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إنشاء حساب جديد"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "انضم إلى منصة ProLearn",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // حقل الاسم الكامل
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      labelText: "الاسم الكامل",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "يرجى إدخال الاسم الكامل";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // حقل البريد الإلكتروني
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "البريد الإلكتروني",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || !value.contains('@')) {
                        return "يرجى إدخال بريد إلكتروني صالح";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // حقل كلمة المرور
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "كلمة المرور",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return "كلمة المرور يجب ألا تقل عن 6 أحرف أو أرقام";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // اختيار نوع المستخدم (دور الحساب)
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: const InputDecoration(
                      labelText: "نوع الحساب",
                      prefixIcon: Icon(Icons.group),
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'student', child: Text('طالب')),
                      DropdownMenuItem(value: 'teacher', child: Text('معلم')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedRole = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // زر التسجيل
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitRegister,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            "تسجيل الحساب",
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}