from app.services.ai_service import AIService


class QuizAgent:

    def __init__(self):
        self.ai = AIService()

    def run(self, lesson: str):

        print("\n================ QUIZ AGENT START ================\n")

        if lesson is None:
            print("ERROR: Lesson is None")
            return []

        if not isinstance(lesson, str):
            lesson = str(lesson)

        lesson = lesson.strip()

        if lesson == "":
            print("ERROR: Lesson is Empty")
            return []

        print("Lesson Length:", len(lesson))
        print("\n=========== LESSON PREVIEW ===========")
        print(lesson[:500])
        print("\n======================================")

        try:

            print("\nSending lesson to Gemini...\n")

            quiz = self.ai.generate_quiz(lesson)

            print("\n============= RAW QUIZ OBJECT =============")
            print(type(quiz))
            print(quiz)
            print("===========================================\n")

            if quiz is None:
                print("ERROR: Gemini returned None")
                return []

            if not isinstance(quiz, list):
                print("ERROR: Gemini did NOT return List")
                return []

            print("Raw Questions Count:", len(quiz))

            clean_quiz = []

            for index, item in enumerate(quiz):

                print(f"\nChecking Question #{index + 1}")

                if not isinstance(item, dict):
                    print("Skipped -> Not Dict")
                    continue

                if "question" not in item:
                    print("Skipped -> Missing question")
                    continue

                if "options" not in item:
                    print("Skipped -> Missing options")
                    continue

                if "answer" not in item:
                    print("Skipped -> Missing answer")
                    continue

                if not isinstance(item["options"], list):
                    print("Skipped -> options ليست List")
                    continue

                if len(item["options"]) != 4:
                    print(
                        f"Skipped -> options count = {len(item['options'])}"
                    )
                    continue

                clean_quiz.append(
                    {
                        "question": item["question"],
                        "options": item["options"],
                        "answer": item["answer"],
                    }
                )

                print("Accepted")

            print("\n============= FINAL RESULT =============")
            print("Valid Questions:", len(clean_quiz))
            print("========================================\n")

            return clean_quiz

        except Exception as e:

            print("\n============= QUIZ AGENT ERROR =============")
            print(e)
            print("============================================\n")

            return []