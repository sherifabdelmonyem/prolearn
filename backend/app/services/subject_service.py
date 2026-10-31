from fastapi import HTTPException
from sqlalchemy.orm import Session

from app.repositories.subject_repository import (
    SubjectRepository,
)


class SubjectService:

    # =====================================================
    # Get All Subjects
    # =====================================================

    @staticmethod
    def subjects(
        db: Session,
    ):
        return SubjectRepository.get_subjects(
            db,
        )

    # =====================================================
    # Get Subject Lessons
    # =====================================================

    @staticmethod
    def lessons(
        db: Session,
        subject_id: int,
    ):

        lessons = SubjectRepository.get_lessons(
            db,
            subject_id,
        )

        if lessons is None:
            raise HTTPException(
                status_code=404,
                detail="Subject not found",
            )

        return lessons