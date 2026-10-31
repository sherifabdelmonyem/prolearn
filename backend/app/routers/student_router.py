from fastapi import APIRouter
from fastapi import Depends
from fastapi import HTTPException
from sqlalchemy.orm import Session

from app.database.session import get_db
from app.dependencies import get_current_active_user


from app.models.user import User

from app.schemas.student_schema import (
    StudentCreate,
    StudentResponse,
)

from app.services.student_service import StudentService

router = APIRouter(
    prefix="/students",
    tags=["Students"],
)


# ==========================================================
# All Students
# ==========================================================

@router.get(
    "/",
    response_model=list[StudentResponse],
)
def get_students(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):
    return StudentService.students(db)


# ==========================================================
# Classroom Students
# ==========================================================

@router.get(
    "/classroom/{classroom_id}",
    response_model=list[StudentResponse],
)
def get_classroom_students(
    classroom_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):
    return StudentService.classroom_students(
        db,
        classroom_id,
    )


# ==========================================================
# Student Details
# ==========================================================

@router.get(
    "/{student_id}",
    response_model=StudentResponse,
)
def get_student(
    student_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):

    student = StudentService.student(
        db,
        student_id,
    )

    if student is None:
        raise HTTPException(
            status_code=404,
            detail="Student not found",
        )

    return student


# ==========================================================
# Create Student
# ==========================================================

@router.post(
    "/",
    response_model=StudentResponse,
)
def create_student(
    student: StudentCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):
    return StudentService.create(
        db,
        student,
    )


# ==========================================================
# Delete Student
# ==========================================================

@router.delete("/{student_id}")
def delete_student(
    student_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):

    student = StudentService.student(
        db,
        student_id,
    )

    if student is None:
        raise HTTPException(
            status_code=404,
            detail="Student not found",
        )

    StudentService.delete(
        db,
        student_id,
    )

    return {
        "message": "Student deleted successfully",
    }