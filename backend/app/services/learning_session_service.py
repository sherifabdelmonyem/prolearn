import json

from sqlalchemy.orm import Session

from app.models.learning_session import LearningSession

from app.schemas.learning_session import (
    LearningSessionCreate,
)

from app.repositories.learning_session_repository import (
    create_learning_session as create_learning_session_repo,
    get_learning_session_by_id,
    get_user_learning_sessions,
    delete_learning_session as delete_learning_session_repo,
)

from app.services.content_service import (
    save_content,
)

from app.agents.orchestrator import AIOrchestrator


# ==========================================================
# Create Session
# ==========================================================

def create_learning_session(
    db: Session,
    user_id: int,
    data: LearningSessionCreate,
):

    session = LearningSession(
        user_id=user_id,
        title=data.title,
        source_type=data.source_type,
        language=data.language,
        status="processing",
        is_completed=False,
    )

    session = create_learning_session_repo(
        db,
        session,
    )

    original_text = data.original_text or ""

    full_text = (
        f"عنوان الدرس: {data.title}\n\n"
        f"{original_text}"
    )

    orchestrator = AIOrchestrator()

    result = orchestrator.process_text(
        full_text,
    )

    save_content(
        db=db,
        session_id=session.id,
        original_text=full_text,
        summary=result.get(
            "summary",
            "",
        ),
        lesson=result.get(
            "lesson",
            "",
        ),
        audio_url=json.dumps(
            result.get(
                "audio",
                {},
            ),
            ensure_ascii=False,
        ),
        quiz=json.dumps(
            result.get(
                "quiz",
                [],
            ),
            ensure_ascii=False,
        ),
    )

    session.status = "completed"
    session.is_completed = True

    db.commit()
    db.refresh(session)

    return session


# ==========================================================
# List Sessions
# ==========================================================

def list_learning_sessions(
    db: Session,
    user_id: int,
):
    return get_user_learning_sessions(
        db=db,
        user_id=user_id,
    )


# ==========================================================
# Get Session
# ==========================================================

def get_learning_session(
    db: Session,
    session_id: int,
):
    return get_learning_session_by_id(
        db=db,
        session_id=session_id,
    )


# ==========================================================
# Delete Session
# ==========================================================

def remove_learning_session(
    db: Session,
    session: LearningSession,
):

    delete_learning_session_repo(
        db=db,
        session=session,
    )