from pydantic import BaseModel


class LessonResponse(BaseModel):
    id: int
    title: str
    summary: str
    lesson: str
    status: str
    subject_id: int

    class Config:
        from_attributes = True