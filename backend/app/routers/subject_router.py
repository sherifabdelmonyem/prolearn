from fastapi import APIRouter
from fastapi import Depends
from fastapi import HTTPException

from sqlalchemy.orm import Session

from app.database.session import get_db
from app.dependencies import get_current_active_user

from app.models.user import User

from app.schemas.subject_schema import SubjectResponse
from app.schemas.lesson_schema import LessonResponse

from app.services.subject_service import SubjectService

router = APIRouter(
    prefix="/subjects",
    tags=["Subjects"],
)


# ==========================================================
# Get All Subjects
# ==========================================================

@router.get(
    "/",
    response_model=list[SubjectResponse],
)
def get_subjects(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):
    return SubjectService.subjects(db)


# ==========================================================
# Get Subject Lessons
# ==========================================================

@router.get(
    "/{subject_id}/lessons",
    response_model=list[LessonResponse],
)
def get_lessons(
    subject_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):

    lessons = SubjectService.lessons(
        db,
        subject_id,
    )

    if lessons is None:
        raise HTTPException(
            status_code=404,
            detail="Subject not found",
        )

    return lessons