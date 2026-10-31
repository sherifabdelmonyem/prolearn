from pathlib import Path

from docx import Document
from pypdf import PdfReader


class FileParserService:

    def extract_text(self, file_path: str) -> str:

        suffix = Path(file_path).suffix.lower()

        if suffix == ".txt":
            with open(file_path, "r", encoding="utf-8") as f:
                return f.read()

        if suffix == ".pdf":
            reader = PdfReader(file_path)

            text = ""

            for page in reader.pages:
                text += page.extract_text() or ""

            return text

        if suffix == ".docx":
            doc = Document(file_path)

            return "\n".join(
                p.text
                for p in doc.paragraphs
            )

        raise ValueError("Unsupported file type")