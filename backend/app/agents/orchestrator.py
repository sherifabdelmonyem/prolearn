from app.agents.summary_agent import SummaryAgent
from app.agents.teacher_agent import TeacherAgent
from app.agents.voice_agent import VoiceAgent
from app.agents.quiz_agent import QuizAgent


class AIOrchestrator:
    def __init__(self):
        self.summary_agent = SummaryAgent()
        self.teacher_agent = TeacherAgent()
        self.voice_agent = VoiceAgent()
        self.quiz_agent = QuizAgent()

    def process_text(self, text: str):
        # إنشاء الملخص
        summary = self.summary_agent.run(text)

        # إنشاء الدرس
        lesson = self.teacher_agent.run(summary)

        # إنشاء الصوت
        try:
            audio = self.voice_agent.run(lesson)
        except Exception as e:
            print("VOICE ERROR:", e)
            audio = {}

        # إنشاء الاختبار
        try:
            quiz = self.quiz_agent.run(lesson)

            # حماية إذا رجع None
            if quiz is None:
                quiz = []

        except Exception as e:
            print("QUIZ ERROR:", e)
            quiz = []

        return {
            "summary": summary,
            "lesson": lesson,
            "audio": audio,
            "quiz": quiz,
        }