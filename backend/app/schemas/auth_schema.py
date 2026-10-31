from pydantic import BaseModel
from pydantic import EmailStr


# ==========================================================
# Login Request
# ==========================================================

class LoginRequest(BaseModel):
    email: EmailStr
    password: str


# ==========================================================
# User داخل الـ Auth
# ==========================================================

class AuthUser(BaseModel):
    id: int
    full_name: str
    email: EmailStr
    role: str
    is_active: bool

    class Config:
        from_attributes = True


# ==========================================================
# Login / Register Response
# ==========================================================

class AuthResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: AuthUser