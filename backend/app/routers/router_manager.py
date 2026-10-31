from enum import Enum


class AgentType(str, Enum):
    PDF = "pdf_agent"
    SUMMARY = "summary_agent"
    AUDIO = "audio_agent"
    QUIZ = "quiz_agent"
    TUTOR = "tutor_agent"
    WHATSAPP = "whatsapp_agent"
    MEMORY = "memory_agent"
    ANALYTICS = "analytics_agent"


class RouterManager:

    def route(self, task: str):

        task = task.lower()

        if "pdf" in task:
            return AgentType.PDF

        elif "summary" in task:
            return AgentType.SUMMARY

        elif "audio" in task:
            return AgentType.AUDIO

        elif "quiz" in task:
            return AgentType.QUIZ

        elif "tutor" in task:
            return AgentType.TUTOR

        elif "whatsapp" in task:
            return AgentType.WHATSAPP

        elif "analytics" in task:
            return AgentType.ANALYTICS

        else:
            return AgentType.MEMORY