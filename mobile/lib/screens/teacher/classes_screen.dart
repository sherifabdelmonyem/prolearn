import 'package:flutter/material.dart';

import '../../models/classroom_model.dart';
import '../../services/classroom_service.dart';
import 'class_details_screen.dart';
import 'create_classroom_screen.dart';

class ClassroomsScreen extends StatefulWidget {
  const ClassroomsScreen({super.key});

  @override
  State<ClassroomsScreen> createState() => _ClassroomsScreenState();
}

class _ClassroomsScreenState extends State<ClassroomsScreen> {
  final ClassroomService classroomService = ClassroomService();

  bool loading = true;

  List<ClassroomModel> classrooms = [];

  @override
  void initState() {
    super.initState();
    loadClassrooms();
  }

  Future<void> loadClassrooms() async {
    setState(() {
      loading = true;
    });

    classrooms = await classroomService.getClassrooms();

    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

  Future<void> openCreateScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateClassroomScreen(),
      ),
    );

    if (result == true) {
      await loadClassrooms();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("فصولي"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: openCreateScreen,
          icon: const Icon(Icons.add),
          label: const Text("فصل جديد"),
        ),
        body: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: loadClassrooms,
                child: classrooms.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 220),
                          Center(
                            child: Text(
                              "لا توجد فصول",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        itemCount: classrooms.length,
                        itemBuilder: (context, index) {
                          final classroom = classrooms[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            elevation: 3,
                            child: ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.groups),
                              ),
                              title: Text(
                                classroom.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "${classroom.grade} • ${classroom.semester}",
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ClassDetailsScreen(
                                      classroom: classroom,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
      ),
    );
  }
}