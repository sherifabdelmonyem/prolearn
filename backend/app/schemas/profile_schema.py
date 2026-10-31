from pydantic import BaseModel, EmailStr


class ProfileUpdate(BaseModel):
    full_name: str
    email: EmailStr