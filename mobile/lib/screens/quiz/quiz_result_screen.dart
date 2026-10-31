import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class QuizResultScreen extends StatefulWidget {
  final int score;
  final int total;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.total,
  });

  @override
  State<QuizResultScreen> createState() =>
      _QuizResultScreenState();
}

class _QuizResultScreenState
    extends State<QuizResultScreen> {

  final FlutterTts tts = FlutterTts();

  @override
  void initState() {
    super.initState();

    _speakResult();
  }

  Future<void> _speakResult() async {

    await tts.setLanguage("ar");

    await tts.setSpeechRate(0.45);

    double percent =
        (widget.score / widget.total) * 100;

    String message;

    if (percent >= 90) {

      message =
          "ممتاز. لقد حصلت على ${widget.score} من ${widget.total}. أداء رائع.";

    } else if (percent >= 70) {

      message =
          "أحسنت. لقد حصلت على ${widget.score} من ${widget.total}.";

    } else {

      message =
          "يمكنك التحسن. لقد حصلت على ${widget.score} من ${widget.total}. حاول مراجعة الدرس ثم أعد الاختبار.";
    }

    await tts.speak(message);
  }

  @override
  void dispose() {

    tts.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final percent =
        (widget.score / widget.total) * 100;

    final success =
        percent >= 70;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(

        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "نتيجة الاختبار",
          ),
        ),

        body: Center(
          child: Padding(
            padding:
                const EdgeInsets.all(25),

            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [

                Icon(
                  success
                      ? Icons.emoji_events
                      : Icons.menu_book,
                  color: success
                      ? Colors.amber
                      : Colors.blueGrey,
                  size: 110,
                ),

                const SizedBox(height: 25),

                Text(
                  success
                      ? "أحسنت 🎉"
                      : "حاول مرة أخرى",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight:
                        FontWeight.bold,
                    color: success
                        ? Colors.green
                        : Colors.red,
                  ),
                ),

                const SizedBox(height: 35),

                Text(
                  "${widget.score} / ${widget.total}",
                  style: const TextStyle(
                    fontSize: 46,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                LinearProgressIndicator(
                  value: percent / 100,
                  minHeight: 12,
                  borderRadius:
                      BorderRadius.circular(12),
                ),

                const SizedBox(height: 10),

                Text(
                  "${percent.toStringAsFixed(1)} %",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 50),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    icon:
                        const Icon(Icons.refresh),
                    label: const Text(
                      "إعادة الاختبار",
                    ),
                    onPressed: () {

                      Navigator.pop(context);

                    },
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton.icon(
                    icon: const Icon(
                      Icons.menu_book,
                    ),
                    label: const Text(
                      "العودة إلى الدرس",
                    ),
                    onPressed: () {

                      Navigator.pop(context);

                      Navigator.pop(context);

                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}