import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../services/quiz_voice_service.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  final dynamic quiz;

  const QuizScreen({
    super.key,
    required this.quiz,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizVoiceService voiceService = QuizVoiceService();

  final FlutterTts tts = FlutterTts();

  final TextEditingController answerController = TextEditingController();

  List<dynamic> questions = [];

  int currentQuestion = 0;

  int score = 0;

  bool isListening = false;

  bool isSpeaking = false;

  String spokenText = "";

  @override
  void initState() {
    super.initState();

    _loadQuiz();

    _initTTS();
  }

  Future<void> _loadQuiz() async {
    try {
      if (widget.quiz == null) {
        questions = [];
      } else if (widget.quiz is String) {
        questions = List<dynamic>.from(
          jsonDecode(widget.quiz),
        );
      } else if (widget.quiz is List) {
        questions = List<dynamic>.from(
          widget.quiz,
        );
      } else {
        questions = [];
      }
    } catch (_) {
      questions = [];
    }

    if (mounted) {
      setState(() {});
    }

    if (questions.isNotEmpty) {
      Future.delayed(
        const Duration(milliseconds: 600),
        () {
          speakCurrentQuestion();
        },
      );
    }
  }

  Future<void> _initTTS() async {
    await tts.setLanguage("ar");

    await tts.setSpeechRate(0.45);

    await tts.setPitch(1);

    await tts.awaitSpeakCompletion(true);

    tts.setStartHandler(() {
      if (!mounted) return;

      setState(() {
        isSpeaking = true;
      });
    });

    tts.setCompletionHandler(() async {
      if (!mounted) return;

      setState(() {
        isSpeaking = false;
      });

      await startVoiceAnswer();
    });

    tts.setCancelHandler(() {
      if (!mounted) return;

      setState(() {
        isSpeaking = false;
      });
    });
  }

  @override
  void dispose() {
    answerController.dispose();

    tts.stop();

    voiceService.stopListening();

    super.dispose();
  }

  Future<void> speakCurrentQuestion() async {
    if (questions.isEmpty) return;

    final q = questions[currentQuestion];

    final type = q["type"] ?? "mcq";

    String speech = "";

    speech += "السؤال رقم ${currentQuestion + 1}. ";

    speech += q["question"].toString();

    speech += ". ";

    if (type == "mcq") {
      final options = List<dynamic>.from(q["options"]);

      for (int i = 0; i < options.length; i++) {
        speech += "الخيار ${i + 1}. ${options[i]}. ";
      }
    }

    if (type == "true_false") {
      speech += "الإجابة تكون صح أو خطأ.";
    }

    if (type == "text") {
      speech += "يمكنك كتابة الإجابة أو قولها بصوتك.";
    }

    await tts.stop();

    await tts.speak(speech);
  }

  Future<void> startVoiceAnswer() async {
    if (isListening) return;

    setState(() {
      isListening = true;
    });

    await voiceService.startListening(
      onResult: (text) async {
        if (!mounted) return;

        spokenText = text;

        answerController.text = text;

        setState(() {});

        final result = text.trim().toLowerCase();

        if (result.contains("أعد") || result.contains("اعد")) {
          await speakCurrentQuestion();
          return;
        }

        if (result.contains("توقف")) {
          await stopVoiceAnswer();
          return;
        }

        final q = questions[currentQuestion];

        final type = q["type"] ?? "mcq";

        if (type == "mcq") {
          final options = List<String>.from(q["options"]);

          if (result.contains("الأول") ||
              result.contains("اول") ||
              result.contains("واحد")) {
            checkAnswer(options[0]);
            return;
          }

          if (options.length > 1 &&
              (result.contains("الثاني") ||
                  result.contains("اتنين") ||
                  result.contains("اثنين"))) {
            checkAnswer(options[1]);
            return;
          }

          if (options.length > 2 && result.contains("الثالث")) {
            checkAnswer(options[2]);
            return;
          }

          if (options.length > 3 && result.contains("الرابع")) {
            checkAnswer(options[3]);
            return;
          }

          checkAnswer(result);

          return;
        }

        if (type == "true_false") {
          if (result.contains("صح")) {
            checkAnswer("صح");

            return;
          }

          if (result.contains("خطأ") || result.contains("غلط")) {
            checkAnswer("خطأ");

            return;
          }
        }

        checkAnswer(result);
      },
    );
  }

  Future<void> stopVoiceAnswer() async {
    await voiceService.stopListening();

    setState(() {
      isListening = false;
    });
  }

  void checkAnswer(String answer) {
    final q = questions[currentQuestion];

    final correct = (q["answer"] ?? "").toString().trim().toLowerCase();

    if (answer.trim().toLowerCase() == correct) {
      score++;
    }

    nextQuestion();
  }

  void nextQuestion() {
    if (currentQuestion + 1 < questions.length) {
      setState(() {
        currentQuestion++;

        spokenText = "";

        answerController.clear();
      });

      Future.delayed(
        const Duration(milliseconds: 600),
        () {
          speakCurrentQuestion();
        },
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(
            score: score,
            total: questions.length,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("الاختبار"),
          ),
          body: const Center(
            child: Text(
              "لا يوجد اختبار متاح",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      );
    }

    final q = questions[currentQuestion];

    final type = q["type"] ?? "mcq";

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "السؤال ${currentQuestion + 1} من ${questions.length}",
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(
                value: (currentQuestion + 1) / questions.length,
              ),
              const SizedBox(height: 25),
              Text(
                q["question"] ?? "",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              if (spokenText.isNotEmpty)
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      spokenText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              if (isSpeaking)
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Icon(Icons.volume_up),
                      SizedBox(width: 10),
                      Text(
                        "يتم قراءة السؤال...",
                      ),
                    ],
                  ),
                ),
              if (isListening)
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Row(
                    children: [
                      Icon(
                        Icons.mic,
                        color: Colors.red,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "جاري الاستماع...",
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 25),
              if (type == "mcq")
                ...(q["options"] as List<dynamic>).map(
                  (option) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ElevatedButton(
                      onPressed: () {
                        checkAnswer(
                          option.toString(),
                        );
                      },
                      child: Text(
                        option.toString(),
                      ),
                    ),
                  ),
                ),
              if (type == "true_false") ...[
                ElevatedButton(
                  onPressed: () {
                    checkAnswer("صح");
                  },
                  child: const Text("صح"),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    checkAnswer("خطأ");
                  },
                  child: const Text("خطأ"),
                ),
              ],
              if (type == "text") ...[
                TextField(
                  controller: answerController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "اكتب الإجابة",
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    checkAnswer(
                      answerController.text,
                    );
                  },
                  child: const Text("إرسال"),
                ),
              ],
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: speakCurrentQuestion,
                      icon: const Icon(Icons.refresh),
                      label: const Text(
                        "أعد السؤال",
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (isListening) {
                          await stopVoiceAnswer();
                        } else {
                          await startVoiceAnswer();
                        }
                      },
                      icon: Icon(
                        isListening ? Icons.stop : Icons.mic,
                      ),
                      label: Text(
                        isListening ? "إيقاف" : "أجب بصوتك",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                ),
                onPressed: () async {
                  await tts.stop();

                  await stopVoiceAnswer();
                },
                icon: const Icon(Icons.volume_off),
                label: const Text(
                  "إيقاف القراءة",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}