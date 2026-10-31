import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  final double progress;

  const ProgressCard({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).toInt();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Row(
            children: [
              Icon(
                Icons.trending_up,
                color: Color(0xff1565C0),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "مستوى التقدم",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation(
                Color(0xff42A5F5),
              ),
            ),
          ),

          const SizedBox(height: 18),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "$percent %",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xff1565C0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}