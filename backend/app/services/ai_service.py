import json
import re
import time

from google import genai
from google.genai import types

from app.core.config import settings


class AIService:

    def __init__(self):
        self.client = genai.Client(
            api_key=settings.GEMINI_API_KEY,
        )

        # تم تحديث الموديل إلى الإصدار المدعوم والمستقر
        self.model = "gemini-2.5-flash"

    # =====================================================
    # إرسال Prompt إلى Gemini مع آلية إعادة المحاولة لتفادي أخطاء 503
    # =====================================================

    def _generate(self, prompt: str) -> str:
        for attempt in range(3):
            try:

                response = self.client.models.generate_content(
                    model=self.model,
                    contents=prompt,
                    config=types.GenerateContentConfig(
                        temperature=0.3,
                        top_p=0.9,
                        max_output_tokens=4096,
                    ),
                )

                print("\n================ MODEL RESPONSE ================\n")
                print(response)
                print("\n================================================\n")

                if response is None:
                    return ""

                if getattr(response, "text", None):
                    return response.text.strip()

                # استخراج النص إذا لم يوجد response.text
                if hasattr(response, "candidates") and response.candidates:

                    parts = (
                        response.candidates[0]
                        .content
                        .parts
                    )

                    if parts:

                        text = "".join(
                            getattr(part, "text", "")
                            for part in parts
                        )

                        return text.strip()

                return ""

            except Exception as e:
                error_str = str(e)
                if "503" in error_str and attempt < 2:
                    print(f"Attempt {attempt + 1} failed with 503, retrying in 2 seconds...")
                    time.sleep(2)
                    continue
                print("GEMINI ERROR:", repr(e))
                return ""
        return ""

    # =====================================================
    # تلخيص
    # =====================================================

    def summarize(self, text: str) -> str:

        prompt = f"""
أنت مدرس محترف.

قم بتلخيص النص التالي.

- لا تضف أي معلومة خارج النص.
- استخدم العربية.
- اجعل الملخص منظمًا.

النص:

{text}
"""

        summary = self._generate(prompt)

        if summary == "":
            return text

        return summary

    # =====================================================
    # شرح
    # =====================================================

    def explain(self, summary: str) -> str:

        prompt = f"""
أنت مدرس محترف.

اشرح الدرس التالي.

- لا تضف أي معلومة خارج النص.
- استخدم العربية.
- قسم الشرح لفقرات.

النص:

{summary}
"""

        lesson = self._generate(prompt)

        if lesson == "":
            return summary

        return lesson

    # =====================================================
    # استخراج JSON
    # =====================================================

    def _extract_json(self, text: str):

        if not text:
            return []

        text = text.replace("```json", "")
        text = text.replace("```", "")
        text = text.strip()

        try:
            return json.loads(text)
        except Exception:
            pass

        match = re.search(r"\[[\s\S]*\]", text)

        if match:

            try:
                return json.loads(match.group())
            except Exception as e:
                print("JSON PARSE ERROR:", repr(e))

        return []

    # =====================================================
    # إنشاء اختبار
    # =====================================================

    def generate_quiz(self, lesson: str):

        prompt = f"""
أنت معلم محترف.

اعتمد فقط على الدرس التالي.

أنشئ 10 أسئلة اختيار من متعدد.

الشروط:

- لا تستخدم أي معلومة خارج الدرس.
- كل سؤال يحتوي على 4 اختيارات.
- إجابة واحدة صحيحة.
- أعد JSON فقط.
- ممنوع Markdown.
- ممنوع كتابة أي شرح.
- لا تكتب ```json.

الصيغة المطلوبة:

[
  {{
    "question":"...",
    "options":[
      "...",
      "...",
      "...",
      "..."
    ],
    "answer":"..."
  }}
]

الدرس:

{lesson}
"""

        try:

            text = self._generate(prompt)

            print("\n================ QUIZ RAW RESPONSE ================\n")
            print(repr(text))
            print("\n===================================================\n")

            if not text:
                print("Gemini returned EMPTY response")
                return []

            quiz = self._extract_json(text)

            print("\n================ PARSED QUIZ ======================\n")
            print(quiz)
            print("\n===================================================\n")

            if isinstance(quiz, list) and len(quiz) > 0:

                print(f"Quiz Generated Successfully ({len(quiz)} Questions)")

                return quiz

            print("First Parsing Failed")

            retry_prompt = f"""
أعد نفس الاختبار.

أعد JSON فقط.

بدون أي كلام.

{prompt}
"""

            retry = self._generate(retry_prompt)

            print("\n================ RETRY RESPONSE ===================\n")
            print(repr(retry))
            print("\n===================================================\n")

            quiz = self._extract_json(retry)

            print("\n================ RETRY PARSED =====================\n")
            print(quiz)
            print("\n===================================================\n")

            return quiz if isinstance(quiz, list) else []

        except Exception as e:
            print("QUIZ ERROR:", repr(e))
            return []