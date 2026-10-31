from datetime import datetime
from pydantic import BaseModel
from fastapi import UploadFile


class LearningSessionCreate(BaseModel):
    title: str
    source_type: str
    language: str = "ar"
    original_text: str | None = None  # إضافة هذا الحقل لاستقبال محتوى الدرس


class LearningSessionResponse(BaseModel):
    id: int
    user_id: int
    title: str
    status: str
    source_type: str
    language: str
    is_completed: bool
    created_at: datetime
    updated_at: datetime

    model_config = {
        "from_attributes": True
    }