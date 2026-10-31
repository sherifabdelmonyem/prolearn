from app.services.file_parser_service import FileParserService


class FileAgent:

    def __init__(self):
        self.parser = FileParserService()

    def run(self, file_path: str):

        return self.parser.extract_text(file_path)