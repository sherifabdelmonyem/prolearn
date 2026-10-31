from sqlalchemy import Column
from sqlalchemy import ForeignKey
from sqlalchemy import Integer
from sqlalchemy import String

from sqlalchemy.orm import relationship

from app.database.base import Base


class Unit(Base):
    __tablename__ = "units"

    id = Column(Integer, primary_key=True)

    name = Column(String, nullable=False)

    subject_id = Column(
        Integer,
        ForeignKey("subjects.id"),
    )

    subject = relationship(
        "Subject",
        back_populates="units",
    )

    lessons = relationship(
        "Lesson",
        back_populates="unit",
        cascade="all, delete",
    )