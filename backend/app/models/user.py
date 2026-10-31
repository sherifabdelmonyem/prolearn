from datetime import datetime

from sqlalchemy import Boolean
from sqlalchemy import Column
from sqlalchemy import DateTime
from sqlalchemy import Integer
from sqlalchemy import String

from sqlalchemy.orm import relationship

from app.database.base import Base


class User(Base):
    __tablename__ = "users"

    id = Column(
        Integer,
        primary_key=True,
        index=True,
    )

    full_name = Column(
        String(150),
        nullable=False,
    )

    email = Column(
        String(150),
        unique=True,
        index=True,
        nullable=False,
    )

    # سيتم تخزين كلمة المرور مشفرة
    password_hash = Column(
        String(255),
        nullable=False,
    )

    role = Column(
        String(20),
        nullable=False,
        default="student",
    )

    is_active = Column(
        Boolean,
        default=True,
        nullable=False,
    )

    created_at = Column(
        DateTime,
        default=datetime.utcnow,
        nullable=False,
    )

    updated_at = Column(
        DateTime,
        default=datetime.utcnow,
        onupdate=datetime.utcnow,
        nullable=False,
    )

    # ===========================
    # Relationships
    # ===========================

    classrooms = relationship(
        "Classroom",
        back_populates="teacher",
        cascade="all, delete-orphan",
    )

    student = relationship(
        "Student",
        back_populates="user",
        uselist=False,
        cascade="all, delete-orphan",
    )

    # ===========================

    def __repr__(self):
        return (
            f"<User("
            f"id={self.id}, "
            f"email='{self.email}', "
            f"role='{self.role}'"
            f")>"
        )