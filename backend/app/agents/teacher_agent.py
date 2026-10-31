from app.services.ai_service import AIService


class TeacherAgent:

    def __init__(self):
        self.ai = AIService()

    def run(self, summary: str) -> str:
        print("[TeacherAgent] Explaining lesson")

        if not isinstance(summary, str):
            summary = str(summary)

        summary = summary.strip()

        if summary == "":
            return ""

        try:
            lesson = self.ai.explain(summary)

            if lesson is None:
                return summary

            lesson = lesson.strip()

            if lesson == "":
                return summary

            return lesson

        except Exception as e:
            print("TeacherAgent ERROR:", e)
            return summary