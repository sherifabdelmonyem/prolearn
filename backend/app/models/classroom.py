from sqlalchemy import Column
from sqlalchemy import ForeignKey
from sqlalchemy import Integer
from sqlalchemy import String

from sqlalchemy.orm import relationship

from app.database.base import Base


class Classroom(Base):
    __tablename__ = "classrooms"

    id = Column(
        Integer,
        primary_key=True,
        index=True,
    )

    name = Column(
        String,
        nullable=False,
    )

    grade = Column(
        String,
        nullable=False,
    )

    semester = Column(
        String,
        nullable=False,
    )

    teacher_id = Column(
        Integer,
        ForeignKey("users.id"),
    )

    teacher = relationship(
        "User",
        back_populates="classrooms",
    )

    students = relationship(
        "Student",
        back_populates="classroom",
    )