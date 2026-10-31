import 'dart:convert';

import 'package:flutter/material.dart';

import '../../lesson_audio_player.dart';
import '../quiz/quiz_screen.dart';

class LessonDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> lesson;

  const LessonDetailsScreen({
    super.key,
    required this.lesson,
  });

  String? _extractAudioUrl() {
    try {
      final audio = lesson["audio"];

      if (audio == null) return null;

      if (audio is Map) {
        final url = audio["url"];
        if (url != null) {
          return "http://127.0.0.1:8000$url";
        }
      }

      if (audio is String) {
        try {
          final decoded = jsonDecode(audio);

          if (decoded["url"] != null) {
            return "http://127.0.0.1:8000${decoded["url"]}";
          }
        } catch (_) {
          if (audio.startsWith("/uploads")) {
            return "http://127.0.0.1:8000$audio";
          }

          return audio;
        }
      }
    } catch (_) {}

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final audioUrl = _extractAudioUrl();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            lesson["title"] ?? "الدرس",
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "عنوان الدرس",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                lesson["title"] ?? "",
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              const Divider(),

              const SizedBox(height: 20),

              const Text(
                "ملخص الدرس",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                lesson["summary"] ?? "",
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.8,
                ),
              ),

              const SizedBox(height: 30),

              const Divider(),

              const SizedBox(height: 20),

              const Text(
                "الشرح الكامل",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                lesson["lesson"] ??
                    lesson["original_text"] ??
                    "",
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 18,
                  height: 2,
                ),
              ),

              const SizedBox(height: 35),

              if (audioUrl != null) ...[
                const Divider(),

                const SizedBox(height: 20),

                const Text(
                  "الشرح الصوتي",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 15),

                LessonAudioPlayerWidget(
                  audioUrl: audioUrl,
                ),

                const SizedBox(height: 30),
              ],

              const Divider(),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.quiz),
                  label: const Text(
                    "ابدأ الاختبار",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    if (lesson["quiz"] == null ||
                        lesson["quiz"]
                            .toString()
                            .trim()
                            .isEmpty) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "لا يوجد اختبار لهذا الدرس",
                          ),
                        ),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizScreen(
                          quiz: lesson["quiz"],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}