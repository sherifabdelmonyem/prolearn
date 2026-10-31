from sqlalchemy import Column
from sqlalchemy import ForeignKey
from sqlalchemy import Integer
from sqlalchemy import String

from sqlalchemy.orm import relationship

from app.database.base import Base


class Student(Base):
    __tablename__ = "students"

    id = Column(
        Integer,
        primary_key=True,
        index=True,
    )

    full_name = Column(
        String,
        nullable=False,
    )

    email = Column(
        String,
        unique=True,
    )

    classroom_id = Column(
        Integer,
        ForeignKey("classrooms.id"),
    )

    user_id = Column(
        Integer,
        ForeignKey("users.id"),
    )

    classroom = relationship(
        "Classroom",
        back_populates="students",
    )

    user = relationship(
        "User",
        back_populates="student",
    )