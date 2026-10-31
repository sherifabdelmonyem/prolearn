from datetime import datetime
from typing import Optional

from pydantic import BaseModel
from pydantic import ConfigDict
from pydantic import EmailStr
from pydantic import Field


# ==========================================================
# Register
# ==========================================================

class UserCreate(BaseModel):
    full_name: str = Field(min_length=3, max_length=150)
    email: EmailStr
    password: str = Field(min_length=6)
    role: str


# ==========================================================
# Login
# ==========================================================

class UserLogin(BaseModel):
    email: EmailStr
    password: str


# ==========================================================
# Update Profile
# ==========================================================

class ProfileUpdate(BaseModel):
    full_name: str = Field(min_length=3, max_length=150)
    email: EmailStr


# ==========================================================
# User Response
# ==========================================================

class UserResponse(BaseModel):
    id: int
    full_name: str
    email: EmailStr
    role: str
    is_active: bool
    created_at: Optional[datetime] = None

    model_config = ConfigDict(
        from_attributes=True,
    )


# ==========================================================
# Auth Response
# ==========================================================

class AuthResponse(BaseModel):
    access_token: str
    token_type: str
    user: UserResponse