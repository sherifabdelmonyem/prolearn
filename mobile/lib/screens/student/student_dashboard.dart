import 'package:flutter/material.dart';

import 'widgets/greeting_card.dart';
import 'widgets/progress_card.dart';
import 'widgets/subject_grid.dart';
import 'subject_screen.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final subjects = [
      {
        "name": "اللغة العربية",
        "progress": .70,
        "icon": Icons.menu_book,
      },
      {
        "name": "الرياضيات",
        "progress": .35,
        "icon": Icons.calculate,
      },
      {
        "name": "الفيزياء",
        "progress": .80,
        "icon": Icons.science,
      },
      {
        "name": "الكيمياء",
        "progress": .55,
        "icon": Icons.biotech,
      },
      {
        "name": "الأحياء",
        "progress": .20,
        "icon": Icons.eco,
      },
      {
        "name": "اللغة الإنجليزية",
        "progress": .90,
        "icon": Icons.language,
      },
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ProLearn"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const GreetingCard(
                studentName: "أحمد محمد",
                grade: "الصف الثالث الثانوي",
                semester: "الفصل الدراسي الأول",
              ),
              const SizedBox(height: 25),
              const ProgressCard(
                progress: .65,
              ),
              const SizedBox(height: 30),
              const Text(
                "المواد الدراسية",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              SubjectGrid(
                subjects: subjects,
                onTap: (subject) {

                   Navigator.push(
                        context,
    MaterialPageRoute(
      builder: (_) => SubjectScreen(
         subjectId: subject["id"],
         subjectName: subject["name"],
       )
    ),
  );

},
              ),
            ],
          ),
        ),
      ),
    );
  }
}