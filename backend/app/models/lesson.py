from sqlalchemy import Column
from sqlalchemy import ForeignKey
from sqlalchemy import Integer
from sqlalchemy import String
from sqlalchemy import Text

from sqlalchemy.orm import relationship

from app.database.base import Base


class Lesson(Base):
    __tablename__ = "lessons"

    id = Column(Integer, primary_key=True)

    title = Column(String)

    summary = Column(Text)

    lesson = Column(Text)

    status = Column(String)

    audio = Column(Text)

    quiz = Column(Text)

    unit_id = Column(
        Integer,
        ForeignKey("units.id"),
    )

    unit = relationship(
        "Unit",
        back_populates="lessons",
    )