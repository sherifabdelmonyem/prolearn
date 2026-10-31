import json

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from sqlalchemy.orm import Session

from app.database.session import get_db
from app.dependencies import get_current_active_user
from app.models.user import User
from app.schemas.learning_session import LearningSessionCreate

from app.services.learning_session_service import (
    create_learning_session,
    get_learning_session,
)

from app.services.content_service import (
    save_content,
    get_content,
)

from app.agents.orchestrator import AIOrchestrator


router = APIRouter(
    prefix="/contents",
    tags=["Contents"],
)


# ==========================================================
# Request Model
# ==========================================================

class UploadContentRequest(BaseModel):
    title: str
    original_text: str


# ==========================================================
# Upload Lesson
# ==========================================================

@router.post("/", status_code=status.HTTP_201_CREATED)
def upload_content(
    request: UploadContentRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):

    data = LearningSessionCreate(
        title=request.title,
        source_type="text",
        language="ar",
        original_text=request.original_text,
    )

    session = create_learning_session(
        db=db,
        user_id=current_user.id,
        data=data,
    )

    orchestrator = AIOrchestrator()

    lesson_text = f"""
عنوان الدرس هو:

{request.title}

الآن نبدأ شرح الدرس.

{request.original_text}
"""

    result = orchestrator.process_text(lesson_text)

    audio_data = result.get("audio", {})

    quiz_data = result.get("quiz", [])

    save_content(
        db=db,
        session_id=session.id,
        original_text=request.original_text,
        summary=result.get("summary", ""),
        lesson=result.get("lesson", ""),
        audio_url=json.dumps(
            audio_data,
            ensure_ascii=False,
        ),
        quiz=json.dumps(
            quiz_data,
            ensure_ascii=False,
        ),
    )

    return {
        "session_id": session.id,
        "title": session.title,
        "summary": result.get("summary", ""),
        "lesson": result.get("lesson", ""),
        "original_text": request.original_text,
        "audio": audio_data,
        "quiz": quiz_data,
    }


# ==========================================================
# Get Lesson
# ==========================================================

@router.get("/{session_id}")
def get_session_content(
    session_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):

    session = get_learning_session(
        db=db,
        session_id=session_id,
    )

    if session is None:
        raise HTTPException(
            status_code=404,
            detail="Session not found",
        )

    if session.user_id != current_user.id:
        raise HTTPException(
            status_code=403,
            detail="Access denied",
        )

    content = get_content(
        db=db,
        session_id=session_id,
    )

    if content is None:
        raise HTTPException(
            status_code=404,
            detail="Content not found",
        )

    return {
        "session_id": session.id,
        "title": session.title,
        "summary": content.summary,
        "lesson": content.lesson,
        "original_text": content.original_text,
        "audio": json.loads(content.audio_url)
        if content.audio_url
        else {},
        "quiz": json.loads(content.quiz)
        if content.quiz
        else [],
    }