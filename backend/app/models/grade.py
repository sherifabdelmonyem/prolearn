from sqlalchemy import Column
from sqlalchemy import ForeignKey
from sqlalchemy import Integer
from sqlalchemy import String

from sqlalchemy.orm import relationship

from app.database.base import Base


class Grade(Base):
    __tablename__ = "grades"

    id = Column(Integer, primary_key=True)

    name = Column(String, nullable=False)

    academic_year_id = Column(
        Integer,
        ForeignKey("academic_years.id"),
    )

    academic_year = relationship(
        "AcademicYear",
        back_populates="grades",
    )

    semesters = relationship(
        "Semester",
        back_populates="grade",
        cascade="all, delete",
    )