from sqlalchemy import Column
from sqlalchemy import ForeignKey
from sqlalchemy import Integer
from sqlalchemy import String

from sqlalchemy.orm import relationship

from app.database.base import Base


class Subject(Base):
    __tablename__ = "subjects"

    id = Column(
        Integer,
        primary_key=True,
        index=True,
    )

    name = Column(
        String,
        nullable=False,
    )

    semester_id = Column(
        Integer,
        ForeignKey("semesters.id"),
    )

    classroom_id = Column(
        Integer,
        ForeignKey("classrooms.id"),
    )

    semester = relationship(
        "Semester",
        back_populates="subjects",
    )

    classroom = relationship(
        "Classroom",
    )

    units = relationship(
        "Unit",
        back_populates="subject",
        cascade="all, delete",
    )