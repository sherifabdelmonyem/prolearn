from sqlalchemy import Column
from sqlalchemy import Integer
from sqlalchemy import String

from app.database.base import Base


class Teacher(Base):
    __tablename__ = "teachers"

    id = Column(Integer, primary_key=True)

    full_name = Column(String, nullable=False)

    email = Column(String, unique=True)

    password = Column(String)