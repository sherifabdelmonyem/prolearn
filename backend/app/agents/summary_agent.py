from app.services.ai_service import AIService


class SummaryAgent:

    def __init__(self):
        self.ai = AIService()

    def run(self, text: str) -> str:

        return self.ai.summarize(text)