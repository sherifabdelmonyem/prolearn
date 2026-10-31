import 'package:flutter/material.dart';

import '../../models/student_model.dart';
import '../../services/student_service.dart';

class StudentsScreen extends StatefulWidget {
  final int classroomId;

  const StudentsScreen({
    super.key,
    required this.classroomId,
  });

  @override
  State<StudentsScreen> createState() =>
      _StudentsScreenState();
}

class _StudentsScreenState
    extends State<StudentsScreen> {
  final StudentService service = StudentService();

  List<StudentModel> students = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  Future<void> loadStudents() async {
    setState(() {
      loading = true;
    });

    students =
        await service.getStudents(widget.classroomId);

    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

  Future<void> deleteStudent(int id) async {
    final ok = await service.deleteStudent(id);

    if (ok) {
      loadStudents();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الطلاب"),
          centerTitle: true,
        ),
        floatingActionButton:
            FloatingActionButton.extended(
          onPressed: () {
            // سنضيف شاشة إضافة الطالب لاحقًا
          },
          icon: const Icon(Icons.person_add),
          label: const Text("إضافة طالب"),
        ),
        body: loading
            ? const Center(
                child:
                    CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: loadStudents,
                child: students.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 220),
                          Center(
                            child: Text(
                              "لا يوجد طلاب",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        itemCount: students.length,
                        itemBuilder:
                            (context, index) {
                          final student =
                              students[index];

                          return Card(
                            margin:
                                const EdgeInsets
                                    .all(8),
                            child: ListTile(
                              leading:
                                  const CircleAvatar(
                                child:
                                    Icon(Icons.person),
                              ),
                              title: Text(
                                student.fullName,
                              ),
                              subtitle: Text(
                                student.email,
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  deleteStudent(
                                      student.id);
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
      ),
    );
  }
}