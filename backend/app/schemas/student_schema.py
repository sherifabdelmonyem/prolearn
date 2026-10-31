from pydantic import BaseModel
from typing import Optional


class StudentCreate(BaseModel):
    full_name: str
    email: str
    classroom_id: int
    user_id: Optional[int] = None


class StudentResponse(BaseModel):
    id: int
    full_name: str
    email: str
    classroom_id: int
    user_id: Optional[int]

    class Config:
        from_attributes = True