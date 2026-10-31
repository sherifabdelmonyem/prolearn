from pydantic import BaseModel


class SubjectResponse(BaseModel):
    id: int
    name: str
    grade: str
    semester: str
    progress: int

    class Config:
        from_attributes = True