from app.agents.summary_agent import SummaryAgent
from app.agents.voice_agent import VoiceAgent
from app.agents.quiz_agent import QuizAgent

class OrchestratorService:

    def __init__(self):
        self.summary_agent = SummaryAgent()
        self.voice_agent = VoiceAgent()
        self.quiz_agent = QuizAgent()

    def process_text(self, text: str):

        summary = self.summary_agent.run(text)

        audio = self.voice_agent.run(summary)
        quiz = self.quiz_agent.run(summary)

        return {
            "summary": summary,
            "audio": audio,
            "quiz": quiz,
    }