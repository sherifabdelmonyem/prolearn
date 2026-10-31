import 'package:flutter/material.dart';

class SubjectGrid extends StatelessWidget {
  final List<Map<String, dynamic>> subjects;

  final Function(Map<String, dynamic>) onTap;

  const SubjectGrid({
    super.key,
    required this.subjects,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: subjects.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        final subject = subjects[index];

        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => onTap(subject),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor:
                        const Color(0xff1565C0),
                    child: Icon(
                      subject["icon"],
                      color: Colors.white,
                      size: 32,
                    ),
                  ),

                  Text(
                    subject["name"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  LinearProgressIndicator(
                    value: subject["progress"],
                    backgroundColor:
                        Colors.grey.shade300,
                    valueColor:
                        const AlwaysStoppedAnimation(
                      Color(0xff42A5F5),
                    ),
                  ),

                  Text(
                    "${(subject["progress"] * 100).toInt()}%",
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}