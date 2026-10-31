import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../lesson_audio_player.dart';
import '../../services/lesson_service.dart';
import '../lesson/lesson_details_screen.dart';

class UploadLessonScreen extends StatefulWidget {
  const UploadLessonScreen({super.key});

  @override
  State<UploadLessonScreen> createState() => _UploadLessonScreenState();
}

class _UploadLessonScreenState extends State<UploadLessonScreen> {
  final LessonService _lessonService = LessonService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool _loading = false;
  PlatformFile? _selectedFile;
  Uint8List? _selectedBytes;
  String? _fileName;
  String? _audioUrl;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: [
        "pdf",
        "doc",
        "docx",
        "txt",
      ],
    );

    if (result == null) return;

    setState(() {
      _selectedFile = result.files.single;
      _selectedBytes = result.files.single.bytes;
      _fileName = result.files.single.name;
    });
  }

  Future<void> _sendLesson() async {
    if (_loading) return;

    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("اكتب عنوان الدرس"),
        ),
      );
      return;
    }

    if (_selectedFile == null && _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("اكتب المحتوى أو اختر ملفاً"),
        ),
      );
      return;
    }

    setState(() {
      _loading = true;
      _audioUrl = null;
    });

    try {
      Map<String, dynamic> response;

      if (_selectedFile != null) {
        response = await _lessonService.uploadFileLesson(
          bytes: _selectedBytes!,
          fileName: _fileName!,
        );
      } else {
        response = await _lessonService.uploadLesson(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
        );
      }

      String? audio;
      final rawAudio = response["audio"];

      if (rawAudio is Map) {
        audio = rawAudio["url"];
      } else if (rawAudio is String) {
        try {
          final decoded = jsonDecode(rawAudio);
          audio = decoded["url"];
        } catch (_) {
          audio = rawAudio;
        }
      }

      if (audio != null) {
        audio = audio.replaceAll("\\", "/");

        if (audio.startsWith("/")) {
          audio = "http://127.0.0.1:8000$audio";
        }

        _audioUrl = audio;
      }

      _titleController.clear();
      _contentController.clear();

      _selectedFile = null;
      _selectedBytes = null;
      _fileName = null;

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم إنشاء الدرس بنجاح"),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LessonDetailsScreen(
            lesson: response,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Widget _buildSelectedFile() {
    if (_selectedFile == null) {
      return const SizedBox();
    }

    return Card(
      color: Colors.green.shade50,
      child: ListTile(
        leading: const Icon(
          Icons.insert_drive_file,
          color: Colors.green,
        ),
        title: Text(_fileName ?? ""),
        subtitle: const Text(
          "الملف جاهز للرفع",
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            setState(() {
              _selectedFile = null;
              _selectedBytes = null;
              _fileName = null;
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "رفع محتوى جديد",
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "عنوان الدرس",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _contentController,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: "اكتب محتوى الدرس",
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(
                  Icons.upload_file,
                ),
                label: const Text(
                  "أو اختر ملف PDF / Word / TXT",
                ),
              ),
              const SizedBox(height: 12),
              _buildSelectedFile(),
              const SizedBox(height: 25),
              ElevatedButton.icon(
                icon: _loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.auto_awesome,
                      ),
                label: Text(
                  _loading ? "جارى التحليل..." : "إرسال إلى المساعد الذكي",
                ),
                onPressed: _loading ? null : _sendLesson,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(55),
                ),
              ),
              if (_audioUrl != null) ...[
                const SizedBox(height: 35),
                const Divider(),
                const SizedBox(height: 15),
                const Text(
                  "الشرح الصوتي",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 15),
                LessonAudioPlayerWidget(
                  audioUrl: _audioUrl!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}