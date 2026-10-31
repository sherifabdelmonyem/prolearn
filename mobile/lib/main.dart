import 'package:flutter/material.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';

import 'screens/home/home_screen.dart';
import 'screens/upload/upload_lesson_screen.dart';
import 'screens/lesson/my_lessons_screen.dart';

void main() {
  runApp(const ProLearnApp());
}

class ProLearnApp extends StatelessWidget {
  const ProLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProLearn',
      debugShowCheckedModeBanner: false,

      initialRoute: '/',

      routes: {
        '/': (context) => const LoginScreen(),

        // أضيف هذا السطر
        '/login': (context) => const LoginScreen(),

        '/register': (context) => const RegisterScreen(),

        '/forgot-password': (context) =>
            const ForgotPasswordScreen(),

        '/home': (context) => const HomeScreen(),

        '/upload-lesson': (context) =>
            const UploadLessonScreen(),

        '/my-lessons': (context) =>
            const MyLessonsScreen(),
      },
    );
  }
}