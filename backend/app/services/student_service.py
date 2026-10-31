from fastapi import HTTPException
from sqlalchemy.orm import Session

from app.models.student import Student
from app.models.user import User

from app.repositories.student_repository import StudentRepository

from app.schemas.student_schema import StudentCreate


class StudentService:

    # =====================================================
    # Get All
    # =====================================================

    @staticmethod
    def students(
        db: Session,
    ):
        return StudentRepository.get_all(db)

    # =====================================================
    # Classroom Students
    # =====================================================

    @staticmethod
    def classroom_students(
        db: Session,
        classroom_id: int,
    ):
        return StudentRepository.get_by_classroom(
            db,
            classroom_id,
        )

    # =====================================================
    # Get One
    # =====================================================

    @staticmethod
    def student(
        db: Session,
        student_id: int,
    ):
        return StudentRepository.get_by_id(
            db,
            student_id,
        )

    # =====================================================
    # Create
    # =====================================================

    @staticmethod
    def create(
        db: Session,
        student: StudentCreate,
    ):

        if student.user_id is not None:

            user = (
                db.query(User)
                .filter(User.id == student.user_id)
                .first()
            )

            if user is None:
                raise HTTPException(
                    status_code=404,
                    detail="User not found",
                )

        new_student = Student(
            full_name=student.full_name,
            email=student.email,
            classroom_id=student.classroom_id,
            user_id=student.user_id,
        )

        return StudentRepository.create(
            db,
            new_student,
        )

    # =====================================================
    # Delete
    # =====================================================

    @staticmethod
    def delete(
        db: Session,
        student_id: int,
    ):
        return StudentRepository.delete(
            db,
            student_id,
        )