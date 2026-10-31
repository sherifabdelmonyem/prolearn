from sqlalchemy import Column
from sqlalchemy import ForeignKey
from sqlalchemy import Integer
from sqlalchemy import String

from sqlalchemy.orm import relationship

from app.database.base import Base


class Semester(Base):
    __tablename__ = "semesters"

    id = Column(Integer, primary_key=True)

    name = Column(String)

    grade_id = Column(
        Integer,
        ForeignKey("grades.id"),
    )

    grade = relationship(
        "Grade",
        back_populates="semesters",
    )

    subjects = relationship(
        "Subject",
        back_populates="semester",
        cascade="all, delete",
    )