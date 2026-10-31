from fastapi import HTTPException
from sqlalchemy.orm import Session

from app.models.classroom import Classroom
from app.models.user import User

from app.repositories.classroom_repository import ClassroomRepository

from app.schemas.classroom_schema import ClassroomCreate


class ClassroomService:

    # =====================================================
    # Get All
    # =====================================================

    @staticmethod
    def classrooms(
        db: Session,
    ):
        return ClassroomRepository.get_all(db)

    # =====================================================
    # Get One
    # =====================================================

    @staticmethod
    def classroom(
        db: Session,
        classroom_id: int,
    ):
        return ClassroomRepository.get_by_id(
            db,
            classroom_id,
        )

    # =====================================================
    # Create
    # =====================================================

    @staticmethod
    def create(
        db: Session,
        classroom: ClassroomCreate,
    ):

        teacher = (
            db.query(User)
            .filter(User.id == classroom.teacher_id)
            .first()
        )

        if teacher is None:
            raise HTTPException(
                status_code=404,
                detail="Teacher not found",
            )

        if teacher.role != "teacher":
            raise HTTPException(
                status_code=400,
                detail="Selected user is not a teacher",
            )

        new_classroom = Classroom(
            name=classroom.name,
            grade=classroom.grade,
            semester=classroom.semester,
            teacher_id=classroom.teacher_id,
        )

        return ClassroomRepository.create(
            db,
            new_classroom,
        )

    # =====================================================
    # Delete
    # =====================================================

    @staticmethod
    def delete(
        db: Session,
        classroom_id: int,
    ):
        return ClassroomRepository.delete(
            db,
            classroom_id,
        )