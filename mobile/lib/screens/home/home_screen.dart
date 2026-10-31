import 'package:flutter/material.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ProLearn"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 70,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.upload_file),
                label: const Text(
                  "Upload Lesson",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/upload-lesson');
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 70,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.menu_book),
                label: const Text(
                  "My Lessons",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                   Navigator.pushNamed(context, "/my-lessons");
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 70,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.person),
                label: const Text(
                  "Profile",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}