from pathlib import Path
import shutil
from uuid import uuid4


UPLOAD_DIR = Path("app/uploads")
UPLOAD_DIR.mkdir(exist_ok=True)


class UploadService:

    def save(self, file):

        extension = Path(file.filename).suffix

        filename = f"{uuid4()}{extension}"

        destination = UPLOAD_DIR / filename

        with open(destination, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)

        return str(destination)