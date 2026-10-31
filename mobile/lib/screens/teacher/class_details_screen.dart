import 'package:flutter/material.dart';

import '../../models/classroom_model.dart';
import 'students_screen.dart';

class ClassDetailsScreen extends StatelessWidget {
  final ClassroomModel classroom;

  const ClassDetailsScreen({
    super.key,
    required this.classroom,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(classroom.name),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classroom.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text("الصف : ${classroom.grade}"),
                    Text("الفصل الدراسي : ${classroom.semester}"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _card(
                    Icons.people,
                    "الطلاب",
                    "0",
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _card(
                    Icons.menu_book,
                    "الدروس",
                    "0",
                    Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _card(
                    Icons.quiz,
                    "الاختبارات",
                    "0",
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _card(
                    Icons.analytics,
                    "التقارير",
                    "0",
                    Colors.purple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StudentsScreen(
                      classroomId: classroom.id,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.people),
              label: const Text("إدارة الطلاب"),
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () {
                // شاشة إنشاء درس
              },
              icon: const Icon(Icons.menu_book),
              label: const Text("إنشاء درس"),
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () {
                // شاشة الاختبارات
              },
              icon: const Icon(Icons.quiz),
              label: const Text("إنشاء اختبار"),
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () {
                // شاشة التحليلات
              },
              icon: const Icon(Icons.analytics),
              label: const Text("عرض التحليلات"),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                // حذف الفصل
              },
              icon: const Icon(Icons.delete),
              label: const Text("حذف الفصل"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 34,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}