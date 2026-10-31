import 'package:flutter/material.dart';
import '../../services/lesson_service.dart';
import 'lesson_details_screen.dart';

class MyLessonsScreen extends StatefulWidget {
  const MyLessonsScreen({super.key});

  @override
  State<MyLessonsScreen> createState() => _MyLessonsScreenState();
}

class _MyLessonsScreenState extends State<MyLessonsScreen> {
  final LessonService _lessonService = LessonService();

  bool _loading = true;
  List<dynamic> _lessons = [];

  int? _hoveredIndex;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    try {
      final lessons = await _lessonService.getMyLessons();

      setState(() {
        _lessons = lessons;
        _loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _deleteLesson(int id) async {
    final ok = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("حذف الدرس"),
            content: const Text("هل تريد حذف هذا الدرس؟"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("إلغاء"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("حذف"),
              ),
            ],
          ),
        ) ??
        false;

    if (!ok) return;

    try {
      await _lessonService.deleteLesson(id);

      _loadLessons();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم حذف الدرس"),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("دروسي"),
        ),
        body: _loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _lessons.isEmpty
                ? const Center(
                    child: Text(
                      "لا توجد دروس حتى الآن",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: _lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = _lessons[index];

                      final hovered = _hoveredIndex == index;
                      final selected = _selectedIndex == index;

                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (_) {
                          setState(() {
                            _hoveredIndex = index;
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            _hoveredIndex = null;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xffdbeafe)
                                : hovered
                                    ? const Color(0xfff5f9ff)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: hovered
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: hovered
                                    ? Colors.blue.withOpacity(.15)
                                    : Colors.black12,
                                blurRadius: hovered ? 10 : 4,
                              )
                            ],
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: hovered
                                  ? Colors.blue
                                  : Colors.blueGrey,
                              child: Text(
                                "${index + 1}",
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            title: Text(
                              lesson["title"] ?? "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: hovered
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),

                            subtitle: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lesson["status"] ?? "",
                                ),
                                if (lesson["created_at"] != null)
                                  Text(
                                    lesson["created_at"],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                            ),

                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: "فتح الدرس",
                                  icon: const Icon(
                                    Icons.menu_book,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _selectedIndex = index;
                                    });

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

                                IconButton(
                                  tooltip: "حذف",
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _deleteLesson(
                                      lesson["id"],
                                    );
                                  },
                                ),
                              ],
                            ),

                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });

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
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}