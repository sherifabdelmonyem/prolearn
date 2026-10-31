import 'package:flutter/material.dart';

import '../../services/classroom_service.dart';

class CreateClassroomScreen extends StatefulWidget {
  const CreateClassroomScreen({super.key});

  @override
  State<CreateClassroomScreen> createState() =>
      _CreateClassroomScreenState();
}

class _CreateClassroomScreenState
    extends State<CreateClassroomScreen> {
  final nameController = TextEditingController();

  final gradeController = TextEditingController();

  final semesterController = TextEditingController();

  final ClassroomService classroomService =
      ClassroomService();

  bool loading = false;

  Future<void> create() async {
    if (nameController.text.isEmpty ||
        gradeController.text.isEmpty ||
        semesterController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("أكمل جميع البيانات"),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    final classroom =
        await classroomService.createClassroom(
      name: nameController.text.trim(),
      grade: gradeController.text.trim(),
      semester: semesterController.text.trim(),
      teacherId: 1,
    );

    if (!mounted) return;

    setState(() {
      loading = false;
    });

    if (classroom != null) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("حدث خطأ أثناء إنشاء الفصل"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إنشاء فصل"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "اسم الفصل",
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: gradeController,
                decoration: const InputDecoration(
                  labelText: "الصف الدراسي",
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: semesterController,
                decoration: const InputDecoration(
                  labelText: "الفصل الدراسي",
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: loading ? null : create,
                  child: loading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "إنشاء الفصل",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}