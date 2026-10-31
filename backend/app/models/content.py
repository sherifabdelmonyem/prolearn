from sqlalchemy import Column, Integer, Text, ForeignKey

from app.database.base import Base


class Content(Base):
    __tablename__ = "contents"

    id = Column(Integer, primary_key=True, index=True)

    session_id = Column(
        Integer,
        ForeignKey("learning_sessions.id"),
        nullable=False,
    )

    original_text = Column(Text)

    summary = Column(Text)

    lesson = Column(Text)

    audio_url = Column(Text)

    quiz = Column(Text)