from fastapi import APIRouter
from fastapi import Depends
from fastapi import HTTPException
from fastapi import status

from sqlalchemy.orm import Session

from app.database.session import get_db
from app.dependencies import get_current_active_user

from app.models.user import User

from app.schemas.classroom_schema import (
    ClassroomCreate,
    ClassroomResponse,
)

from app.services.classroom_service import ClassroomService

router = APIRouter(
    prefix="/classrooms",
    tags=["Classrooms"],
)


# ==========================================================
# Get All Classrooms
# ==========================================================

@router.get(
    "/",
    response_model=list[ClassroomResponse],
)
def get_classrooms(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):
    return ClassroomService.classrooms(db)


# ==========================================================
# Get Classroom
# ==========================================================

@router.get(
    "/{classroom_id}",
    response_model=ClassroomResponse,
)
def get_classroom(
    classroom_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):

    classroom = ClassroomService.classroom(
        db,
        classroom_id,
    )

    if classroom is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Classroom not found",
        )

    return classroom


# ==========================================================
# Create Classroom
# ==========================================================

@router.post(
    "/",
    response_model=ClassroomResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_classroom(
    classroom: ClassroomCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):
    return ClassroomService.create(
        db,
        classroom,
    )


# ==========================================================
# Delete Classroom
# ==========================================================

@router.delete("/{classroom_id}")
def delete_classroom(
    classroom_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user),
):

    classroom = ClassroomService.classroom(
        db,
        classroom_id,
    )

    if classroom is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Classroom not found",
        )

    ClassroomService.delete(
        db,
        classroom_id,
    )

    return {
        "message": "Classroom deleted successfully",
    }