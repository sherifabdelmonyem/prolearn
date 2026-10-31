import json

from fastapi import APIRouter, Depends, File, UploadFile, HTTPException, status
from sqlalchemy.orm import Session

from app.database.session import get_db
from app.dependencies import get_current_active_user

from app.models.user import User
from app.models.learning_session import LearningSession

from app.schemas.learning_session import (
    LearningSessionCreate,
    LearningSessionResponse,
)

from app.services.learning_session_service import (
    create_learning_session,
    list_learning_sessions,
    get_learning_session,
    remove_learning_session,
)

from app.services.upload_service import UploadService
from app.services.file_parser_service import FileParserService
from app.services.content_service import save_content

from app.agents.orchestrator import AIOrchestrator

router = APIRouter(
    prefix="/learning-sessions",
    tags=["Learning Sessions"],
)


# ==========================================================
# Create Session
# ==========================================================

@router.post(
    "/",
    response_model=LearningSessionResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_session(
    data: LearningSessionCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):
    return create_learning_session(
        db=db,
        user_id=current_user.id,
        data=data,
    )


# ==========================================================
# My Sessions
# ==========================================================

@router.get("/")
def get_my_sessions(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):
    return list_learning_sessions(
        db=db,
        user_id=current_user.id,
    )


# ==========================================================
# Session Details
# ==========================================================

@router.get("/{session_id}")
def get_session(
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

    return session


# ==========================================================
# Delete Session
# ==========================================================

@router.delete("/{session_id}")
def delete_session(
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

    remove_learning_session(
        db=db,
        session=session,
    )

    return {
        "message": "Session deleted successfully",
    }


# ==========================================================
# Upload File
# ==========================================================

@router.post("/upload")
def upload_file(
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):

    uploader = UploadService()
    parser = FileParserService()
    orchestrator = AIOrchestrator()

    # حفظ الملف
    file_path = uploader.save(file)

    # استخراج النص
    extracted_text = parser.extract_text(file_path)

    # إنشاء جلسة جديدة
    session = LearningSession(
        user_id=current_user.id,
        title=file.filename,
        source_type="upload",
        language="ar",
        status="processing",
        is_completed=False,
    )

    db.add(session)
    db.commit()
    db.refresh(session)

    # تشغيل الـ AI
    result = orchestrator.process_text(extracted_text)

    audio_data = result.get("audio", {})
    quiz_data = result.get("quiz", [])

    # حفظ المحتوى
    save_content(
        db=db,
        session_id=session.id,
        original_text=extracted_text,
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

    # تحديث حالة الجلسة
    session.status = "completed"
    session.is_completed = True

    db.commit()
    db.refresh(session)

    # نفس تنسيق /contents/
    return {
        "session_id": session.id,
        "title": file.filename,
        "original_text": extracted_text,
        "summary": result.get("summary", ""),
        "lesson": result.get("lesson", ""),
        "audio": audio_data,
        "quiz": quiz_data,
    }