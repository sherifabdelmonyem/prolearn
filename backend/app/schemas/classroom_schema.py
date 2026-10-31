from pydantic import BaseModel


class ClassroomCreate(BaseModel):
    name: str
    grade: str
    semester: str
    teacher_id: int


class ClassroomResponse(BaseModel):
    id: int
    name: str
    grade: str
    semester: str
    teacher_id: int

    class Config:
        from_attributes = True