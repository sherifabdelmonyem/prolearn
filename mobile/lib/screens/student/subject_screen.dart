import 'package:flutter/material.dart';

import '../../services/subject_service.dart';
import '../lesson/lesson_details_screen.dart';

class SubjectScreen extends StatefulWidget {
  final int subjectId;
  final String subjectName;

  const SubjectScreen({
    super.key,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  final SubjectService _service = SubjectService();

  bool loading = true;
  bool hasError = false;

  List<dynamic> lessons = [];

  @override
  void initState() {
    super.initState();
    loadLessons();
  }

  Future<void> loadLessons() async {
    setState(() {
      loading = true;
      hasError = false;
    });

    try {
      lessons = await _service.getLessons(widget.subjectId);

      setState(() {
        loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      setState(() {
        hasError = true;
        loading = false;
      });
    }
  }

  IconData lessonIcon(String status) {
    switch (status) {
      case "مكتمل":
        return Icons.check_circle;
      case "جديد":
        return Icons.fiber_new;
      case "اختبار":
        return Icons.quiz;
      default:
        return Icons.menu_book;
    }
  }

  Color lessonColor(String status) {
    switch (status) {
      case "مكتمل":
        return Colors.green;
      case "جديد":
        return Colors.orange;
      case "اختبار":
        return Colors.deepPurple;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress =
        lessons.isEmpty ? 0.0 : 0.45;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.subjectName),
          actions: [
            IconButton(
              onPressed: loadLessons,
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
        body: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : hasError
                ? Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.cloud_off,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "تعذر تحميل الدروس",
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: loadLessons,
                          child: const Text("إعادة المحاولة"),
                        )
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: loadLessons,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius:
                                BorderRadius.circular(18),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.subjectName,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "عدد الدروس : ${lessons.length}",
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 18),
                              LinearProgressIndicator(
                                value: progress,
                                minHeight: 8,
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "نسبة الإنجاز ${(progress * 100).toInt()} %",
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: lessons.isEmpty
                              ? const Center(
                                  child: Text(
                                    "لا توجد دروس",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: lessons.length,
                                  itemBuilder:
                                      (context, index) {
                                    final lesson =
                                        lessons[index];

                                    final status =
                                        lesson["status"] ??
                                            "";

                                    return Card(
                                      margin:
                                          const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 8,
                                      ),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor:
                                              lessonColor(
                                                  status),
                                          child: Icon(
                                            lessonIcon(
                                                status),
                                            color: Colors.white,
                                          ),
                                        ),
                                        title: Text(
                                          lesson["title"] ??
                                              "",
                                        ),
                                        subtitle: Text(
                                          lesson["summary"] ??
                                              "",
                                        ),
                                        trailing: Chip(
                                          label: Text(status),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  LessonDetailsScreen(
                                                lesson: lesson,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}