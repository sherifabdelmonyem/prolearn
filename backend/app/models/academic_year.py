from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship

from app.database.base import Base


class AcademicYear(Base):
    __tablename__ = "academic_years"

    id = Column(Integer, primary_key=True, index=True)

    name = Column(String, unique=True, nullable=False)

    grades = relationship(
        "Grade",
        back_populates="academic_year",
        cascade="all, delete",
    )