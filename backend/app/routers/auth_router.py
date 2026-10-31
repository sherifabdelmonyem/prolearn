from fastapi import APIRouter
from fastapi import Depends
from fastapi import HTTPException
from fastapi import status
from fastapi.security import OAuth2PasswordRequestForm

from sqlalchemy.orm import Session

from pydantic import BaseModel

from app.database.session import get_db

from app.schemas.user_schema import (
    UserCreate,
    ProfileUpdate,
    UserResponse,
)

from app.schemas.auth_schema import AuthResponse

from app.services.auth_service import AuthService
from app.dependencies import get_current_active_user

import traceback

router = APIRouter(
    prefix="/auth",
    tags=["Authentication"],
)

# ==========================================================
# Password Change Schema
# ==========================================================

class PasswordChange(BaseModel):
    current_password: str
    new_password: str


# ==========================================================
# Register
# ==========================================================

@router.post(
    "/register",
    response_model=AuthResponse,
    status_code=status.HTTP_201_CREATED,
)
def register(
    user: UserCreate,
    db: Session = Depends(get_db),
):
    try:
        return AuthService.register(
            db=db,
            full_name=user.full_name,
            email=user.email,
            password=user.password,
            role=user.role,
        )

    except Exception as e:
        traceback.print_exc()

        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e),
        )


# ==========================================================
# Login
# ==========================================================

@router.post(
    "/login",
    response_model=AuthResponse,
)
def login(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db),
):
    try:
        return AuthService.login(
            db=db,
            email=form_data.username,
            password=form_data.password,
        )

    except Exception as e:
        traceback.print_exc()

        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=str(e),
        )


# ==========================================================
# Current User
# ==========================================================

@router.get(
    "/me",
    response_model=UserResponse,
)
def me(
    current_user=Depends(get_current_active_user),
):
    return current_user


# ==========================================================
# Update Profile
# ==========================================================

@router.put(
    "/me",
    response_model=UserResponse,
)
def update_profile(
    data: ProfileUpdate,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_active_user),
):
    try:
        return AuthService.update_profile(
            db=db,
            user=current_user,
            full_name=data.full_name,
            email=data.email,
        )

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e),
        )


# ==========================================================
# Change Password
# ==========================================================

@router.put("/change-password")
def change_password(
    data: PasswordChange,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_active_user),
):
    try:
        return AuthService.change_password(
            db=db,
            user=current_user,
            current_password=data.current_password,
            new_password=data.new_password,
        )

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e),
        )


# ==========================================================
# Logout
# ==========================================================

@router.post("/logout")
def logout():
    return {
        "message": "Logged out successfully",
    }