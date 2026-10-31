from sqlalchemy.orm import Session

from app.models.user import User

from app.core.security import (
    hash_password,
    verify_password,
    create_access_token,
)


class AuthService:

    # ==========================================================
    # Register
    # ==========================================================

    @staticmethod
    def register(
        db: Session,
        full_name: str,
        email: str,
        password: str,
        role: str,
    ):

        existing_user = (
            db.query(User)
            .filter(User.email == email)
            .first()
        )

        if existing_user:
            raise ValueError("Email already exists")

        user = User(
            full_name=full_name,
            email=email,
            password_hash=hash_password(password),
            role=role,
            is_active=True,
        )

        db.add(user)
        db.commit()
        db.refresh(user)

        access_token = create_access_token(
            {
                "sub": user.email,
                "role": user.role,
                "user_id": user.id,
            }
        )

        return {
            "access_token": access_token,
            "token_type": "bearer",
            "user": user,
        }

    # ==========================================================
    # Login
    # ==========================================================

    @staticmethod
    def login(
        db: Session,
        email: str,
        password: str,
    ):

        user = (
            db.query(User)
            .filter(User.email == email)
            .first()
        )

        if user is None:
            raise ValueError(
                "Invalid email or password"
            )

        if not verify_password(
            password,
            user.password_hash,
        ):
            raise ValueError(
                "Invalid email or password"
            )

        if not user.is_active:
            raise ValueError(
                "Account disabled"
            )

        access_token = create_access_token(
            {
                "sub": user.email,
                "role": user.role,
                "user_id": user.id,
            }
        )

        return {
            "access_token": access_token,
            "token_type": "bearer",
            "user": user,
        }

    # ==========================================================
    # Current User
    # ==========================================================

    @staticmethod
    def get_current_user(
        db: Session,
        user_id: int,
    ):
        return (
            db.query(User)
            .filter(User.id == user_id)
            .first()
        )

    # ==========================================================
    # Update Profile
    # ==========================================================

    @staticmethod
    def update_profile(
        db: Session,
        user: User,
        full_name: str,
        email: str,
    ):

        exists = (
            db.query(User)
            .filter(
                User.email == email,
                User.id != user.id,
            )
            .first()
        )

        if exists:
            raise ValueError(
                "Email already exists"
            )

        user.full_name = full_name
        user.email = email

        db.commit()
        db.refresh(user)

        return user

    # ==========================================================
    # Change Password
    # ==========================================================

    @staticmethod
    def change_password(
        db: Session,
        user: User,
        current_password: str,
        new_password: str,
    ):

        if not verify_password(
            current_password,
            user.password_hash,
        ):
            raise ValueError(
                "Current password is incorrect"
            )

        user.password_hash = hash_password(
            new_password,
        )

        db.commit()
        db.refresh(user)

        return {
            "message": "Password updated successfully",
        }