from sqlalchemy.orm import Session

from app.models.content import Content

from app.repositories.content_repository import (
    create_content,
    get_content_by_session,
)


# ==========================================================
# Save Content
# ==========================================================

def save_content(
    db: Session,
    session_id: int,
    original_text: str,
    summary: str,
    lesson: str,
    audio_url: str,
    quiz: str,
):

    content = Content(
        session_id=session_id,
        original_text=original_text,
        summary=summary,
        lesson=lesson,
        audio_url=audio_url,
        quiz=quiz,
    )

    return create_content(
        db,
        content,
    )


# ==========================================================
# Get Content
# ==========================================================

def get_content(
    db: Session,
    session_id: int,
):

    return get_content_by_session(
        db=db,
        session_id=session_id,
    )